//
//  FoundationExtension.swift
//  PhototainmentVR
//
//  Created by Admin on 29/06/17.
//  Copyright © 2018 Pushan Mitra (ios.dev.mitra@gmail.com). All rights reserved.
//

import Foundation
import UIKit

// Various Action Types
public typealias Action = () -> Void
public typealias InfoAction = (_ info: Any?) -> Void
public typealias BooleanAction = (_ success: Bool) -> Void
public typealias ActionWithError = (_ error: Error?,_ info: Any?) -> Void
public typealias IndexAction = (_ index: Int) -> Void
public typealias VarInfoAction = (_ info:Any?...) -> Void
public typealias RemoteAction = VarInfoAction


// Null Check
func isNil(_ variable: Any?) -> Bool {
    if let _ = variable {
        return false
    }
    return true
}

// Associated Date: Temporal object
protocol AssociatedDate {
    var date: Date { get }
}

// Protocol to return class/ type name
public protocol ClassNameDescription {
    var className: String {get}
}

// WeakRef: Wrapper of weak object
public struct WeakRef<T: AnyObject> {
    weak var ref: T?
}

// WeakObject: Wrapper of week NSObject
public struct WeakObject: Equatable {
    weak var ref: NSObject?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ref == rhs.ref
    }
}

// Extension: NSObject conforming ClassNameDescription
extension NSObject: ClassNameDescription {
    public var className: String {
        return String(describing: type(of: self))
    }
    
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var newUUID: String {
        return UUID().uuidString
    }
}

extension Date {
    var day: String {
        let formatter: DateFormatter = DateFormatter();
        formatter.setLocalizedDateFormatFromTemplate("dd MMM YYYY")
        formatter.locale = NSLocale.current
        return formatter.string(from: self)
    }
}

extension String {
    func appendingPathComponent(_ aStr: String) -> String {
        return (self as NSString).appendingPathComponent(aStr)
    }
    
    static func spaces(count: Int) -> String {
        var str = ""
        if count > 0 {
            for _ in 0...count {
                str.append(" ")
            }
        }
        return str
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var length: Int {
        return self.count
    }
    
    func date(format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from:self)
    }
    
    var data: Data {
        return self.data(using: .utf8) ?? Data()
    }
}

extension DispatchQueue {
    func setTimeout(timeInSec: Double, _ execute: @escaping () -> Swift.Void) {
        self.asyncAfter(deadline: .now() + timeInSec) { 
            execute()
        }
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}


public func setTimeout(time: Double,_ callback: @escaping () -> Void) {
    DispatchQueue.main.setTimeout(timeInSec: time, callback)
}


extension Data {
    static func json(_ json: [String: Any]) -> Data? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return data
        }
        catch let excp {
            ErrorLog("JSONSerialization: Data Creation Exception: \(excp) ")
        }

        return nil
    }
    
    var json: Any? {
        do {
            let json: Any = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            return json
            
        } catch let excp {
            ErrorLog("JSONSerialization: Parsing Exception: \(excp)")
            return nil
        }
    }
    
    var image: UIImage? {
        return self.uiImage()
    }
    
    func uiImage(_ scale:CGFloat = 1.0) -> UIImage? {
        return UIImage(data: self, scale: scale)
    }
    
    var string: String {
        return String(data: self, encoding: .utf8) ?? "<>"
    }
}

extension Date {
    var nsDate: NSDate {
        return NSDate(timeIntervalSince1970: self.timeIntervalSince1970)
    }
    var millisecondSince1970: TimeInterval {
        return floor(self.timeIntervalSince1970 * 1000.0)
    }
    
    var millisecondSince1970Str: String {
        let time = Int(self.millisecondSince1970)
        return "\(time)"
    }
    
    func string(for format: DateFormat) -> String {
        let formatter: DateFormatter = Utility.shareUtility.dateFormatter(format: format)
        return formatter.string(from: self)
    }
    
    func string(format: String) -> String {
        let df: DateFormatter = DateFormatter();
        df.dateFormat = format
        df.locale = NSLocale.current
        return df.string(from: self)
    }
}

extension Date {
    static var oneDay: TimeInterval {
        return 60.0 * 60.0 * 24.0
    }
    
    static var oneWeek: TimeInterval {
        return 60.0 * 60.0 * 24.0 * 7
    }
    static var oneMonth: TimeInterval {
        return 60.0 * 60.0 * 24.0 * 30
    }
    
    func oneWeekBefore() -> Date {
        return self.addingTimeInterval(-Date.oneWeek)
    }
    func oneMonthBefore() -> Date {
        return self.addingTimeInterval(-Date.oneMonth)
    }

    
    func oneDayBefore() -> Date {
        return self.addingTimeInterval(-Date.oneDay)
    }
    
    func tomorrow() -> Date {
        return self.addingTimeInterval(Date.oneDay)
    }
}

extension NSDate {
    var swiftDate: Date {
        return Date(timeIntervalSince1970: self.timeIntervalSince1970)
    }
    var millisecondSince1970: TimeInterval {
        return floor(self.timeIntervalSince1970 * 1000.0)
    }
    
    var millisecondSince1970Str: String {
        let time = Int(self.millisecondSince1970)
        return "\(time)"
    }
}

extension String {
    func stringByAppendingPathComponent1(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}



extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    func urlEncodedString() -> String {
        let nsSt = self as NSString
        return nsSt.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
    func caseInsensitiveMembership(_ list: [String]) -> Bool {
        if let _ = list.firstIndex(of: self) {
            return true
        }
        else if let _ = list.firstIndex(of: self.lowercased()) {
            return true
        } else {
            for item in list {
                if self.caseInsensitiveCompare(item) == .orderedSame {
                    return true
                }
            }
            return false
        }
    }
    
    func convertDateStringTo(of format: String, to formatTo: String) -> String {
        if let date = self.date(format: format) {
            return date.string(format: formatTo)
        }
        return ""
    }
    
    func fileData() -> Data? {
        // Check file exists at self path
        if !FileManager.default.fileExists(atPath: self) {
            return nil
        }
        let url: URL = URL(fileURLWithPath: self)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch  {
           return nil
        }
    }
}

extension String {

    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"

        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
    
    func camelCaseToSentence() -> String {
        let pattern = "([a-z0-9])([A-Z])"

        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        let value: String = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1 $2") ?? self
        return value.capitalized
    }
}


typealias ReturnViewAction = (_ info: Any?) -> UIView?

struct DataSection: CustomStringConvertible {
    var title: String = ""
    var items: [Any] = [Any]()
    var headerViewAction: ReturnViewAction? = nil
    var footerViewAction: ReturnViewAction? = nil
    
    var description: String {
        return "title: \(title), items: \(self.items.count)"
    }
    
    var showFooter: Bool = false
    
    func item(at index: IndexPath) -> Any? {
        if self.items.count > index.row {
            return items[index.row]
        }
        return nil
    }
}

class Utility: NSObject {
    
    static var shareUtility: Utility = {
        return Utility()
    }()
    
    func randomSequence(_ length: Int) ->  String {
        let allchars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result: String = ""
        for _ in  0...(length - 1) {
            let len: Int = Int(allchars.count)
            let index: UInt32 = arc4random_uniform(UInt32(len))
            let strIndex = allchars.index(allchars.startIndex, offsetBy: Int(index))
            let chStr = allchars[strIndex]
            result = result + String(chStr)
        }
        //print("Length : \(result.count)")
        
        let string : String = String(result)
        let data: NSData = string.data(using: String.Encoding.utf8)! as NSData
        let dataStr: String = data.base64EncodedString(options: .lineLength64Characters)
        let endIndex: String.Index = dataStr.index(dataStr.startIndex, offsetBy: (length - 1))
        return String(dataStr[dataStr.startIndex...endIndex])
    }
    
    var randonSequnce20: String {
        return randomSequence(20)
    }
    
    func random(_ range: Range<Int>) -> Int {
        let random: UInt32  = arc4random_uniform(UInt32(range.count)) + UInt32(range.lowerBound)
        return Int(random)
    }
    
    
    func dateFormatter(format: DateFormat) -> DateFormatter {
        let df: DateFormatter = DateFormatter();
        df.dateFormat = format.rawValue
        df.locale = NSLocale.current
        return df
    }
    
    func detailDateLabel(date: Date) -> String {
        let formatter: DateFormatter = self.dateFormatter(format: .detail)
        return formatter.string(from: date)
    }
    
    
    // Create Array of items where each DataSection is collection of items based on date associated
    func dataSection(data: [AssociatedDate]) -> [DataSection] {
        
        // Local Vars
        var dict: [String : [Any]] = [String: [Any]]()
        var dateArray: [Date] = [Date]()
        
        // Deviding each item based on their day and storing individual day in array
        for item in data {
            let date = item.date
            let day = date.day
            //DebugLog("Day: \(day)")
            if var items:[Any] = dict[day]  {
                //DebugLog("\(day) items : \(items.count)")
                items.append(item)
                dict[day] = items
            } else {
                //DebugLog("Creating array for day")
                var items: [Any] = [Any]()
                items.append(item)
                dict[day] = items
                dateArray.append(date)
            }
        }
        
        // Sorting days
        dateArray.sort()
        dateArray.reverse()
        
        // Creating section for each day
        let result: [DataSection] = dateArray.map { (date) -> DataSection in
            var section = DataSection()
            let day = date.day
            section.title = day
            if let items: [Any] = dict[day] {
                section.items = items
            } else {
                section.items = []
            }
            return section
        }
        
        
        return result
    }
}

extension Error {
    var userInfo: [String: Any] {
        return (self as NSError).userInfo
    }
    var code: Int {
        return (self as NSError).code
    }
    
    var message: String {
        return self.userInfo["message"] as? String ?? self.localizedDescription
    }
}

extension Array {
    var midIndex: Int {
        if self.count > 0 {
            return Int(self.count/2)
        }
        return 0
    }
}

public func SelectorStr(_ selector: Selector) -> String {
    return NSStringFromSelector(selector) as String
}

extension Dictionary  {
    func removeItem(_ k: Key) -> Dictionary<Dictionary.Key, Dictionary.Value> {
        var newDict = self
        newDict.removeValue(forKey: k)
        return newDict
    }
    
    func merge(_ other: Dictionary<Dictionary.Key, Dictionary.Value>) -> Dictionary<Dictionary.Key, Dictionary.Value> {
        return self.merging(other) { (_, new) in new }
    }
}

extension Array {
    func merge(_ other: Array<Array.Element>) -> Array<Array.Element> {
        return self + other
    }
}

struct DictValue<K: Hashable, V, T> {
    var dict: [K:V]
    init(_ d: [K: V]) {
        dict = d
    }
    
    subscript (index: K) -> T? {
        return dict[index] as? T
    }
}



extension JSONEncoder {
    class var appEncoder: JSONEncoder {
        let coder: JSONEncoder = JSONEncoder()
        coder.outputFormatting = .prettyPrinted
        return coder
    }
}

func Property(_ sel: Selector) -> String {
    return SelectorStr(sel)
}
