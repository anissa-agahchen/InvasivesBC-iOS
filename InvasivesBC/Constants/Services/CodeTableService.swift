//
//  CodeTables.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-05-11.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON

class CodeTableService {
    
    public static let shared = CodeTableService()
    private init() {}
    
    
    /// Get the Code Table object of the specified type.
    /// - Parameter type: Type /  Name of code table
    /// - Returns: Code Table Object
    public func get(type: String) -> CodeTable? {
        do {
            let realm = try Realm()
            let objs = realm.objects(CodeTable.self).filter("type ==  %@", type).map { $0 }
            let found = Array(objs)
            return found.first
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
            return nil
        }
    }
    
    /// Resurns all stored Code Tables.
    /// - Returns: All Code Table Objects
    private func getAll() -> [CodeTable] {
        do {
            let realm = try Realm()
            let objs = realm.objects(CodeTable.self)
            return Array(objs)
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
            return []
        }
    }
    
    /// Deletes all stored Code Tables.
    private func deleteAll() {
        let all = getAll()
        for each in all {
            RealmRequests.deleteObject(each)
        }
    }
    
    /// Download, Process and Store all code tables from API.
    /// Note that the existing code tables will be deleted by this function before
    /// storing the new results.
    /// - Parameters:
    ///   - completion: Completion call back (Bool)
    ///   - status: Status call back (String)
    public func download(completion: @escaping (_ success: Bool) -> Void, status: @escaping(_ newStatus: String) -> Void) {
        guard let url = URL(string: APIURL.codeTables) else { return completion(false)}
        APIService.get(endpoint: url) { (_result) in
            status("Processing Response")
            guard let result = _result else {return completion(false)}
            guard let jsonResult = result as? JSON else {return completion(false)}
            if let errors = jsonResult["errors"].array, errors.count > 0 {
                print(errors)
                return completion(false)
            }
            status("Processing Code Tables")
            var dictionaryResult: [String:Any] = [String:Any]()
            let data = jsonResult["data"]
            DispatchQueue.global(qos: .background).async {
                for (key, value) in data {
                    dictionaryResult[key] = value.arrayValue
                }
                let codeTables = self.processCodeTableResult(in: dictionaryResult)
                status("Deleting Existing Data")
                self.deleteAll()
                status("Storing Code Tables")
                let group = DispatchGroup()
                for codeTable in codeTables {
                    group.enter()
                    RealmRequests.saveObject(object: codeTable)
                    group.leave()
                }
                group.notify(queue: .main) {
                    return completion(true)
                }
            }
        }
    }
    
    /// Process API response for code tables and return an array of Code Table objects
    /// - Parameter dictionary: API Response
    /// - Returns: Code Table Objects
    private func processCodeTableResult(in dictionary: [String: Any]) -> [CodeTable] {
        var codeTables: [CodeTable] = []
        for (key, value) in dictionary {
            guard let itemJSON: [JSON] = value as? [JSON] else {
                ErrorLog("Unexpected code array received")
                continue
            }
            let tempCodeItems = itemJSON.map { $0.dictionaryObject }
            guard let codeItems: [[String: Any]] = tempCodeItems as? [[String: Any]] else { return []}
            let model = CodeTable()
            model.type = key
            let _: [CodeObject] = codeItems.map({ (codeDict: [String : Any]) -> CodeObject in
                let codeObj = CodeObject()
                // Get id key
                let idKey: [String] = codeDict.keys.filter { (k: String) -> Bool in
                    return k.contains("_id")
                }
                let id = idKey[0]
                codeObj.displayLabel = codeDict["displayLabel"] as? String ?? "NA"
                codeObj.remoteDescription = codeDict["description"] as? String ?? "NA"
                codeObj.remoteId = codeDict[id] as? Int ?? -1
                codeObj.primaryKeyName = id
                model.codes.append(codeObj)
                return codeObj
            })
            codeTables.append(model)
        }
        return codeTables
    }
}
