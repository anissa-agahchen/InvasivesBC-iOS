//
//  CodeTables.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-05-11.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import SwiftyJSON

class CodeTableService {
    public static let shared = CodeTableService()
    private init() {}
    
    func download(completion: @escaping (_ success: Bool) -> Void, status: @escaping(_ newStatus: String) -> Void) {
        guard let url = URL(string: APIURL.codeTables) else { return completion(false)}
        APIService.get(endpoint: url) { (_result) in
            guard let result = _result else {return completion(false)}
            guard let jsonResult = result as? JSON else {return completion(false)}
            var dictionaryResult: [String:Any] = [String:Any]()
            let data = jsonResult["data"]
            DispatchQueue.global(qos: .background).async {
                for (key, value) in data {
                    dictionaryResult[key] = value.arrayValue
                }
                let codeTables = self.processCodeTableResult(in: dictionaryResult)
            }
            
        }
    }
    
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
                codeObj. = codeDict["description"] as? String ?? "NA"
                codeObj.remoteId = codeDict[id] as? Int ?? -1
                model.codes.append(codeObj)
                return codeObj
            })
            codeTables.append(model)
        }
    }
}
