//
//  NSObjectPropertyListExtension.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// MARK: Property Type
enum PropertyType: String, CaseIterable {
    case string, `int`, double, object, unknown, bool
}

// MARK: Property Descriptor
struct PropertyDescriptor: Equatable, Hashable {
    var typeName: String = ""
    var type: PropertyType = .unknown
    var name: String = ""
    
    static func == (lhs: PropertyDescriptor, rhs: PropertyDescriptor) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.typeName == rhs.typeName
    }
    
}
//  API to obtain property info of sub class of NSObject
extension NSObject {
    
    // -- Get property
    class func getPropertyList() -> [PropertyDescriptor] {
        // Return list
        var list: [PropertyDescriptor] = []
        // Count holder
        var count = UInt32()
        // Getting class object
        let classToInspect: AnyClass? = self
        // Getting property info
        guard let properties : UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(classToInspect, &count) else {
            return []
        }
        let intCount = Int(count)
        // Iterating properties
        for index in 0 ..< intCount {
            // ObjC property info struct
            let prop: objc_property_t = properties[index]
            // Getting name
            let name: String =  NSString(utf8String: property_getName(prop)) as String? ?? "NA"
            guard let cStr = property_getAttributes(prop) else {
                continue
            }
            
            // Getting property attribute string
            let attributeString = "\(NSString(utf8String: cStr) ?? "NAA")"
            // Attribute list
            let attributes: [String] = attributeString.components(separatedBy: ",")
            let mainAttribute: String = attributes[0]
            // Type
            let type: String = mainAttribute[1]
            var descriptor: PropertyDescriptor = PropertyDescriptor()
            descriptor.name = name
            if type == "@" { // Object type
                descriptor.type = .object
                // Getting type name
                let formatted = mainAttribute.replacingLastOccurrenceOfString("\\", with: "")
                do {
                    // Searching pattern
                    let regex: NSRegularExpression =  try NSRegularExpression(pattern: "\"[a-zA-Z0-9]+\"", options: .caseInsensitive)
                    if let match = regex.firstMatch(in: formatted, options: .reportCompletion, range: NSRange(formatted.startIndex..., in: formatted)), let range = Range(match.range) {
                        let typeName: String = formatted[range]
                        // Handling NSString
                        if typeName.contains("NSString") {
                            descriptor.typeName = "String"
                            descriptor.type = .string
                        } else {
                            descriptor.typeName = typeName
                        }
                    }
                    
                } catch let err {
                    debugPrint("\(err)")
                }
            } else if type == "q" { // Int Type
                descriptor.type = .int
            } else if type == "d" { // Double type
                descriptor.type = .double
            }
            list.append(descriptor)
        }
        
        return Array(Set<PropertyDescriptor>(list))
    }
}
