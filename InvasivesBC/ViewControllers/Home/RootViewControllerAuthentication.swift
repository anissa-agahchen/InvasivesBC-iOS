//
//  HomeViewControllerAuthentication.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-21.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Reachability

extension RootViewController {
    
    /// Show Login - Do not use directly.
    /// Should be only used by showHomePage() after verification
    internal func segueToLoginPage() {
        performSegue(withIdentifier: "performLogin", sender: nil)
    }
    
    /// Determines  if login or home page should be presented
    internal func presentNext() {
        self.containerView.isHidden = true
        if (!isAuthenticated()) {
            segueToLoginPage()
            return
        }
        
        AccessService.shared.hasAccess { [weak self] (hasAccess) in
            guard let strongSelf = self else {return}
            if hasAccess {
                strongSelf.showHomePage()
            } else {
                strongSelf.showPendingAccess()
            }
        }
    }
    
    /// Show Access Pending view
    private func showPendingAccess() {
        let awaitingAccessResponseView: AwaitingAccessResponse = UIView.fromNib()
        awaitingAccessResponseView.show(in: self.view, onRefresh: { [weak self] in
            guard let _self = self else {return}
            awaitingAccessResponseView.removeFromSuperview()
            _self.presentNext()
        })
    }
    
    /// Show Home page & perform initial sync if necessary
    /// If initial sync is necessary and is failed,
    /// onFailedLogin() will be called
    private func showHomePage() {
        if !SyncService.shared.shouldPerformInitialSync() {
            self.containerView.isHidden = false
            return
        }
        SyncService.shared.performInitialSync { [weak self] (success) in
            guard let _self = self else {return}
            if !success {
                _self.onFailedLogin()
            } else {
                _self.containerView.isHidden = false
            }
        }
    }
    
    /// Handle Authentication failure
    private func onFailedLogin() {
        Alert.show(title: "Can't continue", message: "On your first login, we need to download some information.\nMake sure you have a stable connection")
        AuthenticationService.logout()
    }
    
    /// Check if user is Authenticated
    ///  A user is NOT authenticated if
    ///  1- has never loggged in  before
    ///  2- We have not store the user's Authentication id in app settings
    ///  Otherwise a user is Authenticated if
    ///  1- Device is offline (3.1)
    ///   OR
    ///  2- User's token is not expeired (3.2)
    /// - Returns: Boolean indicating if user is Authenticated
    internal func isAuthenticated() -> Bool {
        // 1) User has logged in
        if !AuthenticationService.isLoggedIn() {
            return false
        }
        
        // 2) We have stored user's Id
        guard let storedUserId = SettingsService.shared.getUserAuthId() else {
            AuthenticationService.logout()
            return false
        }
        
        if storedUserId.isEmpty {
            AuthenticationService.logout()
            return false
        }
        
        // 3) Connection
        do {
            let reacahbility = try Reachability()
            
            if (reacahbility.connection == .unavailable) {
                // 3.1) User is offline
                return SettingsService.shared.userHasAppAccess()
            } else {
                // 3.2) User is Online and User's token is not expired
                return AuthenticationService.isAuthenticated()
            }
        } catch  let error as NSError {
            print("** Reachability ERROR")
            print(error)
            return false
        }
    }
}
