//
//  BaseViewController.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-10-29.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit
import DatePicker
class BaseViewController: UIViewController, Theme {
    
    // MARK: Constants
    let visibleAlpha: CGFloat = 1
    let invisibleAlpha: CGFloat = 0
    
    // MARK: Variables
    var currentPopOver: UIViewController?
    
    // MARK: ViewController Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Event handlers
    func whenLandscape() {}
    func whenPortrait() {}
    func orientationChanged() {}
    
    // MARK: Utilities
    public func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    public func setNavigationBar(hidden: Bool, style: UIBarStyle) {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.isHidden = hidden
            navigationController.navigationBar.barStyle = style
            
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: Colors.primary]
            navigationController.navigationBar.tintColor = Colors.primary
        }
    }
    
    // MARK: Popover
    private func showPopOver(on view: UIView, popOverVC vc: UIViewController, height: Double, width: Double, arrowColor: UIColor? = nil, direction: UIPopoverArrowDirection? = .any) {
        self.view.endEditing(true)
        dismissPopOver()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: width, height: height)
        guard let popover = vc.popoverPresentationController else {return}
        popover.backgroundColor = arrowColor ?? UIColor.white
        popover.permittedArrowDirections = direction ?? .any
        popover.sourceView = view
        popover.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: 0, height: 0)
        self.currentPopOver = vc
        present(vc, animated: true, completion: nil)
    }
    
    // dismisses the last popover added
    public func dismissPopOver() {
        if let popOver = self.currentPopOver {
            popOver.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Options Popover
    public func showOptions(options: [OptionType], on button: UIButton, completion: @escaping (_ option: OptionType) -> Void) {
        let optionsObject = Options()
        let optionsViewController = optionsObject.getVC()
        let popoverSize = optionsViewController.setup(options: options, completion: completion)
        
        showPopOver(on: button, popOverVC: optionsViewController, height: popoverSize.height, width: popoverSize.width)
    }
    
    // MARK: Dropdown popover
    public func showDropdown(items: [DropdownModel], header: String? = "", on view: UIView, enableOtherOption: Bool? = false, completion: @escaping (_ result: DropdownModel?) -> Void) {
        let dropdownObject = Dropdown()
        let dropdownViewController = dropdownObject.getVC()
        let popoverSize = dropdownViewController.setup(objects: items, otherEnabled: enableOtherOption ?? false, completion: completion)
        showPopOver(on: view, popOverVC: dropdownViewController, height: popoverSize.height, width: popoverSize.width)
    }
    
    public func showDropdownMultiSelect(items: [DropdownModel], selectedItems: [DropdownModel], header: String? = "", on view: UIView, enableOtherOption: Bool? = false, completion: @escaping (_ done: Bool,_ result: [DropdownModel]?) -> Void) {
        let dropdownObject = Dropdown()
        let dropdownViewController = dropdownObject.getVC()
        let popoverSize = dropdownViewController.setupMultiSelect(header: header, selectedItems: selectedItems, items: items, otherEnabled: enableOtherOption ?? false, completion: completion)
        showPopOver(on: view, popOverVC: dropdownViewController, height: popoverSize.height, width: popoverSize.width)
    }
    
    public func showDropdownMultiSelectLive(items: [DropdownModel], selectedItems: [DropdownModel], header: String? = "", on view: UIView, enableOtherOption: Bool? = false, completion: @escaping (_ result: [DropdownModel]?) -> Void) {
        let dropdownObject = Dropdown()
        let dropdownViewController = dropdownObject.getVC()
        let popoverSize = dropdownViewController.setupMultiSelectLive(header: header, selectedItems: selectedItems, items: items, otherEnabled: enableOtherOption ?? false, completion: completion)
        showPopOver(on: view, popOverVC: dropdownViewController, height: popoverSize.height, width: popoverSize.width)
    }
    
    // MARK: Timepicker
    func showTimePicker(on view: UIView, initialTime: Time?, completion: @escaping (_ time: Time?) -> Void) {
        let timePicker = TimePicker()
        
        let pickerVC = timePicker.setup(beginWith: initialTime, onChange: completion)
        
        showPopOver(on: view, popOverVC: pickerVC, height: 200, width: 230)
    }
    
    // MARK: Datepicker Popover
    func showDatepicker(on view: UIView, initialDate: Date?, minDate: Date?, maxDate: Date?, completion: @escaping (Date?) -> Void) {
        let datepicker = DatePicker()
        if let min = minDate, let max = maxDate {
            datepicker.setup(beginWith: initialDate, min: min, max: max) { (done, selectedDate) in
                return completion(selectedDate)
            }
        } else {
            datepicker.setup(beginWith: initialDate) { (done, selectedDate) in
                return completion(selectedDate)
            }
        }
        datepicker.displayPopOver(on: view, in: self, completion: {})
    }
    
    // MARK: Delegates
    func showTimePickerDelegate(on view: UIView, initialTime: Time?, completion: @escaping (_ time: Time?) -> Void) {
        showTimePicker(on: view, initialTime: initialTime, completion: completion)
    }
    
    func showDropdownDelegate(items: [DropdownModel], on view: UIView, callback:  @escaping (_ selection: DropdownModel?) -> Void) {
        showDropdown(items: items, on: view, completion: callback)
    }
    
    func showDatepickerDelegate(on view: UIView, initialDate: Date?, minDate: Date?, maxDate: Date?, callback: @escaping (Date?) -> Void) {
        showDatepicker(on: view, initialDate: initialDate, minDate: minDate, maxDate: maxDate, completion: callback)
    }
    
    func showOptionsDelegate(options: [OptionType], on button: UIButton, completion: @escaping (OptionType) -> Void) {
        showOptions(options: options, on: button, completion: completion)
    }
    
    // MARK: Animations
    public func animateIt() {
        UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    public func animateFor(time: Double) {
        UIView.animate(withDuration: time, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: Custom messages
    public func fadeLabelMessage(label: UILabel, text: String, delay: Double? = 3) {
        let defaultDelay: Double = 3
        let originalText: String = label.text ?? ""
        let originalTextColor: UIColor = label.textColor
        // fade out current text
        UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
            label.alpha = self.invisibleAlpha
            self.view.layoutIfNeeded()
        }) { (done) in
            // change text
            label.text = text
            // fade in warning text
            UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
                label.textColor = Colors.accent.red
                label.alpha = self.visibleAlpha
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                // revert after 3 seconds
                UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, delay: delay ?? defaultDelay, animations: {
                    // fade out text
                    label.alpha = self.invisibleAlpha
                    self.view.layoutIfNeeded()
                }, completion: { (done) in
                    // change text
                    label.text = originalText
                    // fade in text
                    UIView.animate(withDuration: SettingsConstants.shortAnimationDuration, animations: {
                        label.textColor = originalTextColor
                        label.alpha = self.visibleAlpha
                        self.view.layoutIfNeeded()
                    })
                })
            })
        }
    }
    
    // MARK: Statusbar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Screen Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.dismissPopOver()
            self.notifyOrientationChange()
            if size.width > size.height {
                self.whenLandscape()
            } else {
                self.whenPortrait()
            }
        }
    }
    
    private func notifyOrientationChange() {
        orientationChanged()
        NotificationCenter.default.post(name: .ScreenOrientationChanged, object: nil)
    }
}

