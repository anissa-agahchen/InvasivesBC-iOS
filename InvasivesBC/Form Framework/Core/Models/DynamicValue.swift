//
//  DynamicValue.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-07.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// Dynamic Value Class holds generic dynamic value and notify observer if values change
class DynamicValue<T> {
    
    // Type: Closure Action to notify
    typealias ValueAction = ((_ value: T) -> Void)

    // Property: Value
    var value : T {
        didSet {
            self.notify()
        }
    }

    // Dicr: Observers
    private var observers = [String: ValueAction]()
    
    // Sender of value
    private weak var _sender: NSObject?

    // Constructor
    init(_ value: T) {
        self.value = value
    }
    
    // Setting value with sender
    /*
     * @param value T : Incoming changes
     * @param sender NSObject : Sender of changes
     */
    public func set(value: T, sender: NSObject) {
        _sender = sender
        self.value = value
    }

    // Adding obsever with complition handle
    public func addObserver(_ observer: NSObject, completionHandler: @escaping ValueAction) {
        observers[observer.description] = completionHandler
    }

    // Adding observer with immediate notification
    public func addAndNotify(observer: NSObject, completionHandler: @escaping ValueAction) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    // Remove observer
    @discardableResult
    public func remove(observer: NSObject) -> Any? {
        return self.observers.removeItem(observer.description)
    }

    // Notifying changes 
    private func notify() {
        if let sender: NSObject = _sender {
            let filteredObserver = observers.filter { (key, _) -> Bool in
                return key != sender.description
            }
            filteredObserver.forEach({ $0.value(self.value) })
            
        } else {
            observers.forEach({ $0.value(self.value) })
        }
    }
    
    // Clear
    public func removeAllObservers() {
        observers.removeAll()
    }

    // Destructor
    deinit {
        observers.removeAll()
    }
}
