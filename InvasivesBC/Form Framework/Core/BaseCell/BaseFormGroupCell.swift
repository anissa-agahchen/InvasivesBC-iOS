//
//  BaseFormGroupCell.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-09.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

// MARK: BaseFormGroupCell
/// Base Cell for all form Group
class BaseFormGroupCell: UICollectionViewCell {
    /// FieldGropView
    var fieldGroupView: FieldGroupView?
    
    /// UI Outlets
    @IBOutlet public var headerLabel: UILabel?
    @IBOutlet public var containerView: UIView?
    
    /// Setup Method
    public func setup(fields: [Field],with header: String, presenter: FieldAuxViewPresenterDelegate?) {
        guard let container: UIView = self.containerView else { return }
        let fieldGroupView: FieldGroupView = FieldGroupView(frame: CGRect.zero)
        fieldGroupView.presenter = presenter
        fieldGroupView.initialize(with: fields, in: container)
        self.headerLabel?.text = header
        self.fieldGroupView = fieldGroupView
    }
}
