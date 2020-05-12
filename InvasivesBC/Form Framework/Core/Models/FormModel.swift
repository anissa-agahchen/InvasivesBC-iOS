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

/// MARK: GroupLayoutDataSource
/// - This is custom data source delegation to get custom layout information of group
protocol GroupLayoutDataSource {
    /// Get content height of the group
    func groupContentHeight(for fields: [Field]) -> CGFloat
    
    /// Get FormGroupCell type
    func customCellType() -> FormGroupCellType
}

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
        
        /// DataSource for Custom Group design
        var dataSource: GroupLayoutDataSource?
    }
    var groups: [Group] = []
}



// MARK: FormModel
/// --
/// - The View Model Class for Form. Here Form is attached to model class defined by T
class FormModel<T: BaseObject>: NSObject {
    
    struct FieldGroup {
        /// Header text
        var header: String = ""
        
        /// Field data to represent
        var fields: [Field] = []
        
        /// DataSource for CustomGroupDevelopment
        var dataSource: GroupLayoutDataSource?
        
        /// Cell type to display
        var cellType: FormGroupCellType {
            if let layoutDataSource = self.dataSource {
                // CellType as per data source
                return layoutDataSource.customCellType()
            } else {
                // General Cell Type
                return .BasicFormGroupCell
            }
        }
        
        /// Content width
        var contentHeight: CGFloat {
            if let layoutDataSource = self.dataSource {
                // Custom content height as per data source
                return layoutDataSource.groupContentHeight(for: self.fields)
            } else {
                // Generic content height based on fields
                return VoidField.estimateContentHeight(for: self.fields)
            }
        }
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
    /// This method will return a list of property name which is ignored due to form creation.
    /// Subclass can override
    /// @returns [String]
    class func ignoredProperties() -> [String] {
        return [
            SelectorStr(#selector(getter: BaseObject.localId)),
            SelectorStr(#selector(getter: BaseObject.remoteId)),
            SelectorStr(#selector(getter: BaseObject.displayLabel)),
            SelectorStr(#selector(getter: BaseObject.sync))
        ]
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
            // Check field is ignored or not
            if Self.ignoredProperties().contains(prop.name) {
                continue
            }
            // Value Handling
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
            // Header
            fieldGroup.header = group.header
            // Creating Fields
            for fieldInfo in group.fields {
                guard let field: Field = self.fieldsMap[fieldInfo.fieldName] else { continue }
                field.width = fieldInfo.fieldWidth
                fieldGroup.fields.append(field)
                handledField[fieldInfo.fieldName] = true
            }
            
            // Datasource
            fieldGroup.dataSource = group.dataSource
            
            // Adding group to form
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
