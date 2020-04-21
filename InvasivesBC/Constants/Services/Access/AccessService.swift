//
//  AccessService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-20.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Reachability

class AccessService {
    // Inspect Officer
    public static let AccessRoleID = 5
    // Inspect Admin
    public static let AccessRoleID_Inspect_ADM = 6
    // System Admin
    public static let AccessRoleID_ADM = 1
    // Singleton
    public static let shared = AccessService()
    
    // Prop: Status to store access
    public var hasAppAccess: Bool = false
    
    // Network reachability
    private let reachability =  try! Reachability()
    
    private init() {
        beginReachabilityNotification()
        setAccess()
    }
    
    // Add listener for when recahbility status changes
    private func beginReachabilityNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    // Handle recahbility status change
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {return}
        switch reachability.connection {
        case .wifi:
            setAccess()
        case .cellular:
            setAccess()
        case .none:
            return
        case .unavailable:
            return
        }
    }
    
    private func setAccess() {
//        APIService.post(endpoint: <#T##URL#>, params: <#T##[String : Any]#>, completion: <#T##(Any?) -> Void#>)
    }

    public func hasAccess(completion: @escaping(Bool) -> Void) {
        if reachability.connection == .unavailable {
//            return completion(Settings.shared.userHasAppAccess())
        }
//        APIService.get(endpoint: <#T##URL#>, completion: <#T##(Any?) -> Void#>)
    }
    
    public func sendAccessRequest(completion: ((Bool)->Void)? = nil) {
//        APIService.post(endpoint: <#T##URL#>, params: <#T##[String : Any]#>, completion: <#T##(Any?) -> Void#>)
    }
    
}
