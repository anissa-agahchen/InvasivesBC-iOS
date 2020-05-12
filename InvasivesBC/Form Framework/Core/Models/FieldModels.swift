//
//  ItemConfig.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit


// Standard Cell width
let kStandardCellHeight: CGFloat = 70.0
let kTitleCellHeight: CGFloat = 30.0

// Different fields type
enum FieldType {
    case Dropdown
    case Text
    case Int
    case Double
    case Date
    case Switch
    case TextArea
    case RadioSwitch
    case ViewField
    case RadioBoolean
    case Time
    case Stepper
    case Spacer
    case Title
    case Blank
}

// Various Field Width Size Class
enum FieldWidthClass {
    case Full
    case Half
    case Third
    case Forth
    case Fill
}

// ViewConfig: Visual Config of field cell
protocol FieldConfig: NSCopying {
    var width: FieldWidthClass { set get }
    var height: CGFloat { set get }
    var header: String { set get }
    var key: String { set get }
    var editable: Bool { get set }
    var type: FieldType { get }
    var isValid: ValidationResult { get }
    
    static func estimateContentHeight(for fields: [FieldConfig]) -> CGFloat
}

extension FieldConfig {
    static func estimateContentHeight(for fields: [FieldConfig]) -> CGFloat {
        let assumedCellSpacing: CGFloat = 10
        var rowHeights: [CGFloat] = []
        var widthCounter: CGFloat = 0
        var tempMaxRowItemHeight: CGFloat = 0
        for (index, item) in fields.enumerated()  {
            
            var itemWidth: CGFloat = 0
            // Get Width in terms of screen %
            switch item.width {
            case .Full:
                itemWidth = 100
            case .Half:
                itemWidth = 50
            case .Third:
                itemWidth = 33
            case .Forth:
                itemWidth = 25
            case .Fill:
                itemWidth = 100 - widthCounter
            }
            // If the new row width + current row width exceeds 100, item will be in the next row
            if (widthCounter + itemWidth) > 100 {
                // Store previous row's max height
                rowHeights.append(tempMaxRowItemHeight + assumedCellSpacing)
                tempMaxRowItemHeight = 0
                widthCounter = 0
            }
            
            // TODO: handle height for items with dependency where dependency is not satisfied
           
            
            // If current item's height is greater than the max item height for row
            // set max item hight for row
            if tempMaxRowItemHeight < item.height {
                tempMaxRowItemHeight = item.height
            }
            // increase width counter
            widthCounter = widthCounter + itemWidth
            
            // if its the last item, add row-height
            if index == (fields.count - 1) {
                rowHeights.append(tempMaxRowItemHeight)
            }
        }
        
        var computedHeight: CGFloat = 0
        for rowHeight in rowHeights {
            computedHeight = computedHeight + rowHeight
        }
        return computedHeight
    }
}

struct FieldDependency {
    enum Condition {
        case showOn
    }
    typealias ConditionValue = (condition: Condition, values: [Any])
    var field: Field
    var conditions: [ConditionValue] = []
}

protocol Field: FieldConfig {
    var fieldValue: Any? { set get }
    var dependencies: [FieldDependency] { set get }
    var dependents: [FieldDependency]  { set get }
    var ignore: Bool { set get }
    func add(observer: NSObject, callback: @escaping (Field) -> Void)
    func remove(observer: NSObject)
    func removeAllObserver()
    func updateDependents()
}

extension Field {
    var valid: Bool {
        return self.isValid.success
    }
}


// General Field View Model Class
class FieldViewModel<T>: Field  {
    
    // FieldConfig
    var width: FieldWidthClass = .Fill
    var height: CGFloat = kStandardCellHeight
    var header: String = ""
    var key: String = ""
    var editable: Bool = false
    var ignore: Bool = false
    
    var dependencies: [FieldDependency] = []
    var dependents: [FieldDependency] = []
    
    // Observer
    private var _observers: [WeakObject] = []
    
    var validators: [BaseValidator<T>] = [BaseValidator<T>]()
    
    // Validation
    var isValid: ValidationResult {
        let result = (true, "")
        for validator in validators {
            let validationResult = validator.validate(data: self.value)
            if !validationResult.success {
                return validationResult
            }
        }
        return result
    }
    
    // Field
    var fieldValue: Any? {
        set {
            if let input: T = newValue as? T {
                self.value = input
            }
        }
        
        get {
            return self.value
        }
    }
    
    
    // Data
    var data: DynamicValue<T>
    
    // Constructor
    init(header: String, key: String, editable: Bool, width: FieldWidthClass = .Fill, data: T) {
        self.data = DynamicValue<T>(data)
        self.header = header
        self.key = key
        self.editable = editable
        self.width = width
    }
    
    var value: T {
        set {
            self.data.value = newValue
        }
        get {
            return self.data.value
        }
    }
    
   var type: FieldType {
        if T.self == Int.self || T.self == Int?.self {
            return .Int
        } else if T.self == Double.self || T.self == Double?.self {
            return .Double
        } else if T.self == Date?.self || T.self == Date.self {
            return .Date
        } else if T.self == Bool.self || T.self == Bool?.self {
            return .Switch
        } else {
            return .Text
        }
    }
    
    // NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        let newObject: FieldViewModel<T> = FieldViewModel<T>(header: self.header, key: self.key, editable: self.editable, data: self.data.value)
        return newObject
    }
    
    // Observer
    func add(observer: NSObject, callback: @escaping (Field) -> Void) {
        if self._observers.lastIndex(where: { $0.ref == observer }) == nil {
            self._observers.append(WeakObject(ref: observer))
            self.data.addObserver(observer) { change in
                callback(self)
            }
        }
    }
    
    // Remove Observer
    func remove(observer: NSObject) {
        if let weakRefIndex = self._observers.lastIndex(where: { $0.ref == observer }) {
            self.data.remove(observer: observer)
            self._observers.remove(at: weakRefIndex)
        }
    }
    
    // Remove all observer
    func removeAllObserver() {
        self.data.removeAllObservers()
        self._observers = []
    }
    
    
    // Update Dependent FieldModel Objects
    func updateDependents() {}
    
    // MARK: Destroy
    deinit {
        self.data.removeAllObservers()
        self._observers = []
        DebugLog("\(self)")
    }
}

class VoidField: FieldViewModel<Void> {}

// ReadOnlyFieldViewModel: Read
class ReadOnlyFieldViewModel: FieldViewModel<String> {}

// TextInput
class TextFieldViewModel: FieldViewModel<String> {}

// TextAreaInput
class TextAreaFieldViewModel: FieldViewModel<String> {
    override var type: FieldType {
        return .TextArea
    }
}

// Switch: Boolean Field
class SwitchFieldViewModel: FieldViewModel<Bool> {}

// Date
class DateFieldViewModel: FieldViewModel<Date?> {}

// Double
class DoubleFieldViewModel: FieldViewModel<Double> {}

// Integer
class IntFieldViewModel: FieldViewModel<Int> {}

// Blank Field
class BlankField: FieldViewModel<Void> {
    
    override var type: FieldType {
        return .Blank
    }
}

// Title: Display Section or Group Title
class TitleFieldViewModel: FieldViewModel<String> {
    init(title: String, width: FieldWidthClass = .Fill) {
        super.init(header: "", key: UUID().uuidString, editable: false, width: width, data: title)
    }
    
    override var type: FieldType {
        return .Title
    }
}

// Spacer: Space Element
class SpacerFieldViewModel: FieldViewModel<Void> {
    init(width: FieldWidthClass = .Fill, height: CGFloat = kStandardCellHeight) {
        super.init(header: "", key: UUID().uuidString, editable: false, width: width, data: Void())
        self.height = height
    }
    
    override var type: FieldType {
        return .Spacer
    }
}


// DropDown Model
class DropDownViewModel: FieldViewModel<Int> {
    
}
