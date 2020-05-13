//
//  AppRemoteAPIConst.swift
//  FoodAnytime
//
//  Created by Pushan Mitra on 21/09/18.
//  Copyright © 2018 Pushan Mitra. All rights reserved.
//

import Foundation

/**
  * Remote/Local URL
 */
let LOCAL_URL: String = "http://localhost/api"
let DEV_URL: String = "https://api-dev-invasivesbc.pathfinder.gov.bc.ca/api"
let TEST_URL: String = "https://api-test-invasivesbc.pathfinder.gov.bc.ca/api"
let PROD_URL: String = "https://api-invasivesbc.pathfinder.gov.bc.ca/api"

/**
  * KeyCloak URL
 */
let KC_DEV_URL: String = "https://sso-dev.pathfinder.gov.bc.ca"
let KC_TEST_URL: String = "https://sso-test.pathfinder.gov.bc.ca"
let KC_PROD_URL: String = "https://sso.pathfinder.gov.bc.ca"

enum RemoteEnv: String {
    case local, dev, test, prod
    
    var remoteURL: String {
        switch self {
        case .local:
            return LOCAL_URL
        case .dev:
            return DEV_URL
        case .test:
            return TEST_URL
        case .prod:
            return PROD_URL
        }
    }
    
    var keyCloakURL: String {
        switch self {
        case .local,.dev:
            return KC_DEV_URL
        case .test:
            return KC_TEST_URL
        case .prod:
            return KC_PROD_URL
        }
    }
}

class RemoteURLManager {
    var env: RemoteEnv = .dev
    static var `default` = {
        // Here We Can use Target Flag to customize
        // Switch Env 
        return RemoteURLManager(.dev)
    }()
    
    init(_ env: RemoteEnv) {
        self.env = env
    }
    
    var remoteURL: String {
        return self.env.remoteURL
    }
    
    var keyCloakURL: URL {
        return URL(string: self.env.keyCloakURL)!
    }
    
}

/**
  * Diffirent EndPoints
 */
enum EndPoints: String {
    case none = ""
    case accessRequest = "/request-access"
    case user = "/account/me"
    case codeTables = "/codes"
}

/**
 * API
 */
struct APIURL {
    static var baseURL: String = RemoteURLManager.default.remoteURL
    static let user: String = {
        return Self.baseURL + EndPoints.user.rawValue
    }()
    
    static let assessRequest: String = {
        return Self.baseURL + EndPoints.accessRequest.rawValue
    }()
    
    static let codeTables: String = {
        return Self.baseURL + EndPoints.codeTables.rawValue
    }()
}


let TestToken: String = """
eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJRMFJ5N2UxUmhmRkxMTWFsS0trdmg4dGJqdTZyemJzNTliZVhLWUlzUkxvIn0.eyJqdGkiOiIzZDQxMDRlOC1lMjRiLTRlZDQtYmNjMS1kZjk5MjFiMDI0MWMiLCJleHAiOjE1ODE2MjA3MTYsIm5iZiI6MCwiaWF0IjoxNTgxNjIwNDE2LCJpc3MiOiJodHRwczovL3Nzby1kZXYucGF0aGZpbmRlci5nb3YuYmMuY2EvYXV0aC9yZWFsbXMvZGZtbGNnN3oiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiOTMxZjYyNWItMjU3MS00NGQ0LWI5ZDEtOTM0ODgwNzQ4OGU4IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoibHVjeSIsIm5vbmNlIjoiNGI3OGRmZTUtMTM1MS00NzNkLWE3OGMtMDdhMzAyNWY2MWMwIiwiYXV0aF90aW1lIjoxNTgxNjIwNDE1LCJzZXNzaW9uX3N0YXRlIjoiYTI5YzA3M2YtYTc5NS00NTIwLWI0ZDQtMTdmNDg2Y2Y3NDRlIiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiIiLCJuYW1lIjoiSW52YXNpdmUgU3BlY2llcyBUZXN0IDUiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJpc3Rlc3Q1QGlkaXIiLCJnaXZlbl9uYW1lIjoiSW52YXNpdmUgU3BlY2llcyIsImZhbWlseV9uYW1lIjoiVGVzdCA1IiwiZW1haWwiOiJpc3Rlc3Q1QGdvdi5iYy5jYSJ9.Fb4NwpT49j9eapABbDuHpCIOnMJ4trBw3bC5Lkj8w8-igbGan-yyxUuNUXgcTGLKoGLSAamC4RgjhBmd9gJHua9UMf9W2w5c21SWs44cnFPQgaWGi6RJk_o8Nio7kuItaowi9JK-pylaFz6XIUDbN8OpnpfAZ-hLYRwIkkJxTUZIBuVEcrwYzx9-jdgg0tYpeFUBLRhXz0B8Nw2XyKeP3IyLZ30XbIddzyQK514uRQC80tHJ5zrvCwSVW6kyZ_3AB4ggE8tNwhSOzt0JW4MPVehgoiczs4n4oDibbFFSFI5Lvcxz7jcBQO3upNXGx7BLJWqUAHP9koKhOo54vZx_4w
"""
