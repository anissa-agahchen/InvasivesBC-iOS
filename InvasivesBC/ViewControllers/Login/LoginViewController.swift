//
//  LoginViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-20.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    var webURL: URL?
    
    // MARK: Outlets
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var loginWithIdirButton: UIButton!
    @IBOutlet weak var loginWithBCeIDButton: UIButton!
    @IBOutlet weak var loginContainer: UIView!
    
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    // MARK: Outlet Actions
    @IBAction func loginWithIdirAction(_ sender: UIButton) {
        AuthenticationService.refreshEnvironmentConstants(withIdpHint: "idir")
        SettingsService.shared.setAuth(type: .Idir)
        AuthenticationService.authenticate { (success) in
            if (!success) {
                AuthenticationService.logout()
                return
            }
            self.afterLogin()
        }
    }
    
    @IBAction func loginWithBCeIDAction(_ sender: UIButton) {
        AuthenticationService.refreshEnvironmentConstants(withIdpHint: "bceid")
        SettingsService.shared.setAuth(type: .BCeID)
        AuthenticationService.authenticate { (success) in
            if (!success) {
                AuthenticationService.logout()
                return
            }
            self.afterLogin()
        }
    }
    
    private func afterLogin() {
        SettingsService.shared.setUserAuthId()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Style
    private func style() {
        setAppTitle(label: appTitle, darkBackground: false)
        styleFillButton(button: loginWithIdirButton)
        styleFillButton(button: loginWithBCeIDButton)
        styleCard(layer: loginContainer.layer)
    }
}
