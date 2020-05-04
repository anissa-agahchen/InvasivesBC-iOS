//
//  Auth.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-10-28.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import Foundation
import SingleSignOn

class AuthenticationService {
    
    private static var authServices: AuthServices = {
        return AuthServices(baseUrl: SSO.baseUrl, redirectUri: SSO.redirectUri,
                            clientId: SSO.clientId, realm: SSO.realmName,
                            idpHint: SSO.idpHint)
    }()
    
    public static func refreshEnvironmentConstants(withIdpHint: String?) {
        var idpHint = getIdpHint()
        
        if let injectedHint = withIdpHint {
            idpHint = injectedHint
        }
        
        self.authServices = AuthServices(baseUrl: SSO.baseUrl, redirectUri: SSO.redirectUri,
                                         clientId: SSO.clientId, realm: SSO.realmName,
                                         idpHint: idpHint)
    }
    
    private static func getIdpHint() -> String {
        return SSO.idpHint;
    }
    
    public static func authenticate(completion: @escaping(_ success: Bool) -> Void) {
        if isAuthenticated() {
            refreshCredentials(completion: completion)
        } else {
            signIn(completion: completion)
        }
    }
    
    /**
    Check if user is Logged in but doesnt check if token has expired
    */
    public static func isLoggedIn() -> Bool {
        return authServices.credentials != nil
    }
    
    /**
     Check if user is logged in and has a valid token
     */
    public static func isAuthenticated() -> Bool {
        return authServices.isAuthenticated()
    }
    
    public static func getUserFirstName() -> String {
        guard let token = getAccessToken() else {return ""}
        let decoded = JWTDecoder.decode(jwtToken: token)
        return decoded["given_name"] as? String ?? ""
    }
    
    public static func getUserLastName() -> String {
        guard let token = getAccessToken() else {return ""}
        let decoded = JWTDecoder.decode(jwtToken: token)
        return decoded["family_name"] as? String ?? ""
    }
    
    public static func getUserID() -> String {
        guard let token = getAccessToken() else {return ""}
        let decoded = JWTDecoder.decode(jwtToken: token)
        return decoded["preferred_username"] as? String ?? ""
    }
    
    public static func refreshCredentials(completion: @escaping(_ success: Bool) -> Void) {
        authServices.refreshCredientials(completion: { (credentials: Credentials?, error: Error?) in
            if let error = error as? AuthenticationError, case .expired = error {
                let vc = authServices.viewController() { (credentials, error) in
                    
                    if let _ = credentials, error == nil {
                        return completion(true)
                    } else {
                        let title = "Authentication"
                        let message = "Authentication didn't work. Please try again."
                        
                        Alert.show(title: title, message: message)
                        return completion(false)
                    }
                }
                guard let presenter = getCurrentViewController() else {
                    print("Could not find a VC to present AuthServices on.")
                    return
                }
                presenter.present(vc, animated: true, completion: nil)
            } else {
                return completion(true)
            }
        })
    }
    
    public static func signIn(completion: @escaping(_ success: Bool) -> Void) {
        let vc = authServices.viewController() { (credentials, error) in
            
            if let _ = credentials, error == nil {
                return completion(true)
            } else {
                let title = "Authentication"
                let message = "Authentication didn't work. Please try again."
                Alert.show(title: title, message: message)
                return completion(false)
            }
        }
        guard let presenter = getCurrentViewController() else {
            print("Could not find a VC to present AuthServices on.")
            return
        }
        presenter.present(vc, animated: true, completion: nil)
    }
    
    public static func logout() {
        authServices.logout()
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    public static func hasCredentials() -> Bool {
        return authServices.credentials != nil
    }
    
    public static func getAccessToken() -> String? {
        if let creds = authServices.credentials {
            return creds.accessToken
        } else {
            return nil
        }
    }
    
    public static func isAuthTokenExpired() -> Bool {
        if let creds = authServices.credentials {
            return creds.isAuthTokenExpired()
        } else {
            return true
        }
    }
    
    public static func isRefreshExpired() -> Bool {
        if let creds = authServices.credentials {
            return creds.isRefreshTokenExpired()
        } else {
            return true
        }
    }
    
    private static func getCurrentViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return nil}
        if var topController = window.rootViewController {
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            return topController
        } else {
            return nil
        }
    }
}
