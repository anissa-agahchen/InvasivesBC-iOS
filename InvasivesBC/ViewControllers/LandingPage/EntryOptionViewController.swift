//
//  EntryOptionViewController.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-23.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

// Enum: EntryOption
//  Different Data Entry options
enum EntryOption: String, CaseIterable {
    case addObservation = "Add Observation"
    case addMechanicalTreatment = "Add Mechanical Treatment"
    case addChemicalTreatment = "Add Chemical Treatment"
    case addMechanicalMonitoring = "Add Mechanical Monitoring"
    case addChemicalMonitoring = "Add Chemical Monitoring"
}

// EntryOptionDelegate
// Delegate to send message of user entry option selection
protocol EntryOptionDelegate: NSObjectProtocol {
    func didSelect(entryOption: EntryOption) -> Void
}

// EntryOptionViewController
// ViewController to display entry options and manages user selection
class EntryOptionViewController: UIViewController {
    
    // MARK: Variables
    static var titles: [String] = {
        return [String](EntryOption.allCases.map({ $0.rawValue }))
    }()
    
    // MARK: Variables
    // Delegate:
    // Delegate to send user selection of entry option
    weak var delegate: EntryOptionDelegate?

    // MARK: Outlets
    @IBOutlet var optionButtons: [UIButton]!
    
    // MARK: IBAction
    // EntryOption selection action
    @IBAction func entryAction(_ sender: Any?) {
        // Getting selected options
        guard let button: UIButton = sender as? UIButton, let title: String = button.title(for: .normal), let index = EntryOptionViewController.titles.lastIndex(of: title), let option = EntryOption(rawValue: title) else {
            return
        }
        // Logging
        InfoLog("User selects Option => Index: \(index) => \(EntryOptionViewController.titles[index])")
        
        
        // Dismissing self and invoking delegate
        self.dismiss(animated: true) {
            self.delegate?.didSelect(entryOption: option)
        }
    }
    
    
    // MARK: Private methods
    // Set titles of different entry option buttons
    fileprivate func setTitles() {
        guard let buttons: [UIButton] = self.optionButtons else { return }
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            if i < EntryOptionViewController.titles.count {
                let title = EntryOptionViewController.titles[i]
                button.setTitleForAllState(title)
            }
        }
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Title of buttons
        self.setTitles()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
