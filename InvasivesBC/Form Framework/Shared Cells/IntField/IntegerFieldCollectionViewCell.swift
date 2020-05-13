//
//  IntegerInputCollectionViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2019-11-07.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

/// UICollectionView Cell to represent Integer Value
class IntegerFieldCollectionViewCell:  BaseFieldCell<Int, IntFieldViewModel>, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let stringValue = textField.text, let number = Int(stringValue) {
            self.value = number
        } else {
            self.value = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let current = textField.text else {
            return false
        }
        let finalText = "\(current)\(string)"
        return Int(finalText) != nil
    }
    
    // MARK: BaseFieldCell
    override func update(value: Int) {
        self.textField?.text = "\(value)"
    }
    
    override var header: UILabel? {
        return self.headerLabel
    }
    
    
    
    func style() {
        styleInput(field: textField, header: headerLabel, editable: model?.editable ?? false)
    }
    
}
