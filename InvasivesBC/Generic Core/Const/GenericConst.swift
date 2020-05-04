//
//  GenericConst.swift
//  FoodAnytime
//
//  Created by Pushan Mitra on 31/08/18.
//  Copyright © 2018 Pushan Mitra. All rights reserved.
//

import Foundation

// MARK: Application Domain
var ApplicationDomain: String = {
    return "ca.bc.pathfinder.invasivesbc.invasivesBC"
}()

var AppFullName: String = "InvasivesBC"
public func SetAppName(_ name: String) {
    AppFullName = name
}

let DefaultDebugString: String = "NIL"

let AppGenErrorMessageViewTime: TimeInterval = 3.0
let ApplicationErrorInfoMessageKey: String = "message"


// MARK: StoryboardSegueIdentifier
//          This enum will show all different storyboard segue id
public enum StoryboardSegueIdentifier: String, CaseIterable {
    case showEntryOptions
    case none
}

// MARK: CellIdentifier
//          This enum will hold all reusable identifier of various table view cell
enum CellIdentifier: String {
    case placeHolder
}

// MARK: AppImageName
enum AppImageName: String {
    case placeHolder
}

// MARK: AppStoryBoard
//          Different story board of the app.
enum AppStoryBoard: String {
    // Main Story board
    case main = "Main"
    // Landing Page
    case landingPage = "LandingPage"
}

// MARK: StoryBoardIdentifier
//          Identifier for story board
enum StoryBoardIdentifier: String {
    case rootController
    case entryOptionController
}

// MARK: Model File Name
enum CoreDataConst: String {
    case model = "iosApp"
}

// MARK: DateFormat
enum DateFormat: String {
    case sectionHeader = "dd MMM YYYY"
    case detail = "dd MMM YYYY hh:mm"
    case apiDate = "yyyy.MM.dd"
    case apiTime = "hh:mm:ss a"
    case orderDate = "yyyy-MM-dd HH:mm:ss"
}

public func None() {}
public func Nil() -> Any? { return nil}
public func StrAny(_ item: Any?) -> String {
    if let val = item {
        return "\(val)"
    }
    return String(describing: item)
    
}
func StrProcessing(_ input: String) -> String {
    return input;
}


let AppGenericMessageTime: TimeInterval = 10.0
let AppActivityMessage: String = StrProcessing("Please wait...")

// SandBox Component
enum SandBoxType: String {
    case root, images, data
}
