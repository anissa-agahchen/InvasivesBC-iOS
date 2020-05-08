//
//  FormModel.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// MARK: Const
let AllFieldsGroupHeader = "All Fields"
let UngroupedFieldsGroupHeader = "Other Fields"

// MARK: Layout
/// - Layout: Structure to store Form Layout
struct Layout {
    /// Store information of field width
    typealias FieldInfo = (fieldName: String, fieldWidth: FieldWidthClass)
    /// Structure stores grouping information of form fields
    struct Group {
        /// Group header
        var header: String = ""
        /// Fields with group
        var fields: [FieldInfo] = []
        /// Custom Group Cell type
        var customCellType: FormGroupCellType?
    }
    var groups: [Group] = []
}

// MARK: FormModel
/// --
/// - The View Model Class for Form. Here Form is attached to model class defined by T
class FormModel<T: BaseObject>: NSObject {
    
    struct FieldGroup {
        var header: String = ""
        var fields: [Field] = []
    }
    
    /// Data Model
    var data: T? {
        didSet {
            self.createFields()
        }
    }
    
    
    /// FieldGroup Arrangements
    fileprivate var _groups: [FieldGroup] = []
    
    /// API for group
    var groups: [FieldGroup] {
        return _groups
    }
    
    /// Property to check form is editable or not
    var editable: Bool = true
    
    /// Map to store property and corresponding field
    var fieldsMap: [String: Field] = [:]
    
    /// Layout: Field arrangement layout. Subclass should override
    var layout: Layout {
        return Layout()
    }
    
    ///  --
    ///  This method return a custom field structure for model property descriptor. Subclass  should override.
    ///  @param     property: PropertyDescriptor
    ///  @param     editable: Bool Field is editable or not
    ///  @returns    Field
    class func fieldForModel(property: PropertyDescriptor, editable: Bool = true) -> Field? {
        return nil
    }
    
    /// --
    /// Custom header for Model Property name. Subclass  should override.
    /// @param propertyName: String =>  Name of the model property
    /// @returns String
    class func headerForModel(propertyName: String) -> String? {
        return nil
    }
    
    // MARK: Methods
    /// Creating fields as per model data
    func createFields() {
        
        // Cleaning
        clear()
        
        // Creating Fields
        let propertyList = T.propertyList()
        for prop in propertyList {
            let value: Any? = self.data?.value(forKey: prop.name)
           // Get Field From config
           if let field: Field = Self.fieldForModel(property: prop, editable: self.editable) {
               field.fieldValue = value
               self.fieldsMap[prop.name] = field
           } else {
               // Create Default field
               let defaultField = self.defaultField(propertyDescriptor: prop)
               defaultField.fieldValue = value
               self.fieldsMap[prop.name] = defaultField
           }
        }
        
        // Applying layout
        applyLayout()
        
        // Add field observation
        observeFields()
    }
    
    /// Removing all observers of all the fields
    func clearFieldsObserver() {
        for field in self.fieldsMap.values {
            field.removeAllObserver()
        }
    }
    
    /// Clear Model
    func clear() {
        clearFieldsObserver()
        self.fieldsMap.removeAll()
    }
    
    // MARK: Operators
    subscript (key: String) -> Field? {
        return self.fieldsMap[key]
    }
    
    // MARK: Destroy
    deinit {
        DebugLog("\(self)")
        clear()
    }
}

extension FormModel {
    
    /// Return default field type as per property type
    private func defaultField(propertyDescriptor: PropertyDescriptor) -> Field {
        let header = Self.headerForModel(propertyName: propertyDescriptor.name) ?? propertyDescriptor.name.camelCaseToSentence()
        switch propertyDescriptor.type {
        case .string:
            return TextFieldViewModel(header: header, key: propertyDescriptor.name, editable: self.editable, data: "")
        case .double:
            return DoubleFieldViewModel(header: header, key: propertyDescriptor.name, editable: self.editable, data: 0.0)
        case .int:
            return IntFieldViewModel(header: header, key: propertyDescriptor.name, editable: self.editable, data: 0)
        case .bool:
            return SwitchFieldViewModel(header: header, key: propertyDescriptor.name, editable: self.editable, data: false)
        default:
            return BlankField(header: header, key: propertyDescriptor.name, editable: false, data: Void())
        }
    }
    
    
    
    /// Arranging fields as per layout
    private func applyLayout() {
        // Creating groups structure
        var result: [FieldGroup] = []
        var handledField: [String : Bool] = [:]
        for group in self.layout.groups {
            var fieldGroup = FieldGroup()
            fieldGroup.header = group.header
            for fieldInfo in group.fields {
                guard let field: Field = self.fieldsMap[fieldInfo.fieldName] else { continue }
                field.width = fieldInfo.fieldWidth
                fieldGroup.fields.append(field)
                handledField[fieldInfo.fieldName] = true
            }
            result.append(fieldGroup)
        }
        
        // Now Check for unhandled fields
        var notHandledGroup = FieldGroup()
        for (fieldName, field) in self.fieldsMap {
            if handledField[fieldName] == nil {
                field.width = .Half
                notHandledGroup.fields.append(field)
            }
        }
        if notHandledGroup.fields.count > 0 {
            if result.count > 0 {
                notHandledGroup.header = UngroupedFieldsGroupHeader
            } else {
                notHandledGroup.header = AllFieldsGroupHeader
            }
            result.append(notHandledGroup)
        }
        self._groups = result
    }
    
    /// Observe changes of the fields
    private func observeFields() {
        for (key, field) in self.fieldsMap {
            field.add(observer: self) {[weak self] (f: Field) in
                self?.data?.setValue(f.fieldValue, forKey: key)
            }
        }
    }
    
}
