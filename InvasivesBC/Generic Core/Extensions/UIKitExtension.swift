//
//  UIKitExtension.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-23.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIButton
// Adding some utility method to UIButton class
extension UIButton {
    
    // --
    // @method setTitleForAllState Setting title of button for all state
    // @param title String Title to set
    // @returns Void
    // --
    func setTitleForAllState(_ title: String)  {
        
        // Arrange states
        let states: [UIControl.State] = [.normal, .selected, .highlighted, .disabled]
        
        // Setting title for arranged states
        for state in states {
            self.setTitle(title, for: state)
        }
    }
}

// MARK: UIStoryboardSegue
// Extending functionality of UIStoryboardSegue
extension UIStoryboardSegue {
    // Converting segue identifier string to StoryboardSegueIdentifier
    // Returns StoryboardSegueIdentifier
    var appSegueIdentifier: StoryboardSegueIdentifier {
        if let id: String = self.identifier {
            return StoryboardSegueIdentifier(rawValue: id) ?? .none
        }
        return .none
    }
}

// MARK: UIStoryboard
// Extending UIStoryboard
extension UIStoryboard {
    class func viewController(_ controller: StoryBoardIdentifier, _ storyBoard: AppStoryBoard?) -> UIViewController {
        let sb: AppStoryBoard = storyBoard ?? .main
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: sb.rawValue, bundle: nil)
        
        return storyBoard.instantiateViewController(withIdentifier: controller.rawValue)
    }
}
