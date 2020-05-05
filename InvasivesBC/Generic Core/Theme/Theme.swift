//
//  Theme.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-10-28.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit
import Extended

protocol Theme {}
extension Theme {
    
    // MARK: Fonts
    public func getSubHeaderFont() -> UIFont {
        return Fonts.getPrimaryBold(size: 17)
    }
    
    public func getInputFieldFont() -> UIFont {
        return Fonts.getPrimary(size: 15)
    }
    
    public func getSwitcherFont() -> UIFont {
        return Fonts.getPrimaryBold(size: 17)
    }
    
    // MARK: Label Text
    // App Title
    public func setAppTitle(label: UILabel, darkBackground: Bool? = false) {
        label.text = StringConstants.appTitle
        styleAppTitle(label: label, darkBackground: darkBackground ?? false)
    }
    
    public func styleAppTitle(label: UILabel, darkBackground:Bool? = false) {
        label.textColor = darkBackground ?? false ? UIColor.white : Colors.primary
        label.font = Fonts.getPrimaryBold(size: 30)
    }
    
    // Body
    public func styleBody(label: UILabel, darkBackground: Bool? = false) {
        label.textColor = darkBackground ?? false ? UIColor.white : Colors.bodyText
        label.font = Fonts.getPrimary(size: 15)
    }
    
    // Sub-header
    public func styleSubHeader(label: UILabel, darkBackground: Bool? = false) {
        label.textColor = darkBackground ?? false ? UIColor.white : Colors.bodyText
        label.font = getSubHeaderFont()
        label.change(kernValue: -0.52)
        label.adjustsFontSizeToFitWidth = true
    }
    
    // Input field header
    public func styleFieldHeader(label: UILabel) {
        label.textColor = Colors.inputHeaderText
        label.font = Fonts.getPrimaryBold(size: 14)
        label.adjustsFontSizeToFitWidth = true
    }
    
    // Input field content
    private func styleFieldInput(textField: UITextField) {
        textField.textColor = Colors.inputText
        textField.backgroundColor = Colors.inputBackground
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 3
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = Colors.inputBackground.cgColor
    }
    
    private func styleFieldInputReadOnly(textField: UITextField) {
        textField.textColor = Colors.inputText
        textField.backgroundColor = .clear
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 0
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func styleInput(field: UITextField, header: UILabel, editable: Bool) {
        if editable {
            styleFieldInput(textField: field)
            styleFieldHeader(label: header)
        } else {
            styleFieldHeader(label: header)
            styleFieldInputReadOnly(textField: field)
        }
        
    }
    
    // Input field content
    public func styleFieldInput(textField: UITextView) {
        textField.textColor = Colors.inputText
        textField.backgroundColor = Colors.inputBackground
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = Colors.inputBackground.cgColor
    }
    
    // Form Section title
    public func styleSectionTitle(label: UILabel) {
        label.textColor = Colors.primary
        label.font = Fonts.getPrimaryBold(size: 22)
    }
    
    // MARK: Buttons
    public func styleHollowButton(button: UIButton) {
        styleButton(button: button, bg: UIColor.white, borderColor: Colors.primary.cgColor, titleColor:Colors.primary)
        button.tintColor = Colors.primary
    }
    
    public func styleDisable(button: UIButton) {
        styleButton(button: button, bg: UIColor.white, borderColor: UIColor.gray.cgColor, titleColor: UIColor.gray)
    }
    
    public func styleFillButton(button: UIButton) {
        styleButton(button: button, bg: Colors.primary, borderColor: Colors.primary.cgColor, titleColor: UIColor.white)
        if let label = button.titleLabel {
            label.font = Fonts.getPrimary(size: 17)
        }
    }
    
    private func styleButton(button: UIButton, bg: UIColor, borderColor: CGColor, titleColor: UIColor) {
        button.layer.cornerRadius = 5
        button.backgroundColor = bg
        button.layer.borderWidth = 1
        button.tintColor = titleColor
        button.layer.borderColor = borderColor
        button.setTitleColor(titleColor, for: .normal)
    }
    
    // MARK: Colors
    // Gradiant UIView
    public func setGradiantBackground(view: UIView) {
        setGradientBackground(view: view, colorOne: UIColor(hex: "#0053A4"), colorTwo: UIColor(hex:"#002C71"));
    }
    
    // Gradiant Navbar
    public func setGradiantBackground(navigationBar: UINavigationBar) {
         navigationBar.setGradientBackground(colors: [UIColor(hex:"#002C71"), UIColor(hex: "#0053A4")], startPoint: .bottomRight, endPoint: .bottomLeft)
     }
    
    // Gradiant UIView with custom colors
    public func setGradientBackground(view: UIView, colorOne: UIColor, colorTwo: UIColor) {
        view.insertHorizontalGradient(colorTwo, colorOne)
    }
    
    public func addShadow(to layer: CALayer, opacity: Float, height: Int, radius: CGFloat? = 10) {
        layer.borderColor = UIColor(red:0.14, green:0.25, blue:0.46, alpha:0.2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowColor = UIColor(red:0.14, green:0.25, blue:0.46, alpha:0.2).cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = 10
    }
    
    // MARK: Circle
    // Circular view
    public func makeCircle(view: UIView) {
        view.layer.cornerRadius = view.frame.size.height/2
    }
    
    // Circular button
    public func makeCircle(button: UIButton) {
        makeCircle(layer: button.layer, height: button.bounds.height)
    }
    
    // Circular layer
    public func makeCircle(layer: CALayer, height: CGFloat) {
        layer.cornerRadius = height/2
    }
    
    // MARK: Contraints
    // Add Contraints to view to equal another
    public func addEqualSizeContraints(to toView: UIView, from fromView: UIView) {
        toView.translatesAutoresizingMaskIntoConstraints = false
        toView.heightAnchor.constraint(equalTo: fromView.heightAnchor, constant: 0).isActive = true
        toView.widthAnchor.constraint(equalTo: fromView.widthAnchor, constant: 0).isActive = true
        toView.leadingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: 0).isActive = true
        toView.trailingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: 0).isActive = true
    }
    
    // MARK: View & Layer
    public func roundCorners(layer: CALayer) {
        layer.cornerRadius = 8
    }
    
    public func styleCard(layer: CALayer) {
        roundCorners(layer: layer)
        addShadow(to: layer, opacity: 08, height: 2)
    }
    
    public func styleDivider(view: UIView) {
        view.backgroundColor = Colors.secondary
    }
    public func styleDividerGrey(view: UIView) {
        view.backgroundColor = Colors.Status.LightGray
    }
    
    // MARK: ANIMATIONS
    public func fadeLabelMessage(label: UILabel, tempText: String, delay: Double? = 3) {
        let defaultDelay: Double = 3
        let visibleAlpha: CGFloat = 1
        let invisibleAlpha: CGFloat = 0
        let originalText: String = label.text ?? ""
        let originalTextColor: UIColor = label.textColor
        // fade out current text
        UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
            label.alpha = invisibleAlpha
            label.layoutIfNeeded()
        }) { (done) in
            // change text
            label.text = tempText
            // fade in warning text
            UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
                label.textColor = Colors.accent.red
                label.alpha = visibleAlpha
                label.layoutIfNeeded()
            }, completion: { (done) in
                // revert after 3 seconds
                UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, delay: delay ?? defaultDelay, animations: {
                    // fade out text
                    label.alpha = invisibleAlpha
                    label.layoutIfNeeded()
                }, completion: { (done) in
                    // change text
                    label.text = originalText
                    // fade in text
                    UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
                        label.textColor = originalTextColor
                        label.alpha = visibleAlpha
                        label.layoutIfNeeded()
                    })
                })
            })
        }
    }
}
