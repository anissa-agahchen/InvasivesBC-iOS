//
//  FieldGroupModels.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-13.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// ViewModel for FieldGroup
class FieldGroupModel: NSObject {
    // MARK: Properties
    var fields: [Field] = [] {
        willSet {
            stopObserving()
        }
        didSet {
            observeFields()
        }
    }
    
    var output: [Field] {
        return fields.filter { $0.ignore == false }
    }
    
    internal var fieldMap: [String: Field] = [:]
    
    // MARK: Methods
    // Change: Receiver method to get changes in field value
    public func change(in field: Field, with index: Int) {}
    
    // Dict Convert
    public func toDict() -> [String : Any?] {
        return fieldMap.mapValues { $0.fieldValue }
    }
    
    // MARK: Private methods
    // Adding observer to fields
    private func observeFields() {
        for index in 0...fields.count {
            let field = fields[index]
            field.add(observer: self) {[weak self] field in
                self?.change(in: field, with: index)
                self?.handleDependencies()
            }
            fieldMap[field.key] = field
            handleDependencies()
        }
    }
    
    // Removing Observer
    private func stopObserving() {
        for field in fields {
            field.remove(observer: self)
        }
    }
    
    // Handle dependencies
    private func handleDependencies() {
        for field in fields {
            // Ignoring incase of field without dependent or field value is not valid
            if field.dependents.count == 0 || !field.valid { continue }
            field.updateDependents()
        }
    }
    
    
    // MARK: Destroy
    deinit {
        stopObserving()
    }
}

class MultipleFieldGroupModel: NSObject {
    
    
}
