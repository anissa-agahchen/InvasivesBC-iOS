//
//  BaseFieldCell.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

// Presenting Auxiliary view on Field
@objc
protocol FieldAuxViewPresenterDelegate: NSObjectProtocol {
    func showDatePicker(on view: UIView,
                        initialDate: Date?,
                        maxDate: Date?,
                        minDate: Date?,
                        _ callback: @escaping (_ selectedDate: Date) -> Void
    )
}

class FieldCell: UICollectionViewCell, Theme {
    public func initialize(model: Any, presenter: FieldAuxViewPresenterDelegate? = nil) {}
}

class BaseFieldCell<T, Model: FieldViewModel<T>>: FieldCell {
    
    // Typealias
    typealias ModelType = Model
    
    // Header
    weak var header: UILabel? {
        return nil
    }
    
    weak var presenter: FieldAuxViewPresenterDelegate?
    
    // Model
    var model: Model? {
        didSet {
            // Task After model assignment
            // Removing observation from old value
            oldValue?.data.remove(observer: self)
            // Checking cell editable nature
            self.isUserInteractionEnabled = self.model?.editable ?? false
            // Registering observation of model change
            self.model?.data.addObserver(self, completionHandler: { [weak self] newValue in
                self?.update(value: newValue)
            })
            
            guard let value: T = self.model?.value else {
                return
            }
            self.update(value: value)
            self.header?.text = self.model?.header ?? ""
        }
    }
    
    // Initialise: Override FieldCell
    override  public func initialize(model: Any, presenter: FieldAuxViewPresenterDelegate? = nil) {
        guard let modelData: ModelType = model as? ModelType else {
            return
        }
        self.initialize(model: modelData, presenter: presenter)
    }
    
    // Initialise: With Model and Aux view delegate
    internal func initialize(model: Model, presenter: FieldAuxViewPresenterDelegate? = nil) {
        self.model = model
        self.presenter = presenter
    }
    
    // Value
    internal var value: T? {
        set {
            guard let noNilNewValue: T = newValue else { return }
            // Update Model without notification  to self
            self.model?.data.set(value: noNilNewValue, sender: self)
        }
        
        get {
            return self.model?.value
        }
    }
    
    // Update Underlying UI
    public func update(value: T) {}
    
    // MARK: UICollectionViewCell
    // Layout attributes
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Specify you want _full width_
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
    
    // MARK: Destructor
    deinit {
        self.model?.data.remove(observer: self)
    }
}
