//
//  KWDCEnvironment.swift
//  KWDC_Check-in
//
//  Created by mac on 9/18/24.
//

import Foundation

public enum KWDCEnvironment {
    enum Keys {
        static let token = "TOKEN"
        static let baseUrl = "BASE_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            return [:]
        }
        
        return dictionary
    }()
    
    static let baseURL: String = {
        guard let baseURLString = KWDCEnvironment.infoDictionary[Keys.baseUrl] as? String else {
            return "https://www.google.com"
        }
        
        return baseURLString
    }()
    
    static let token: String = {
        guard let token = KWDCEnvironment.infoDictionary[Keys.token] as? String else {
            return ""
        }
        
        return token
    }()
}
