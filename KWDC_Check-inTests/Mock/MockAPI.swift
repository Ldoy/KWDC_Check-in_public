//
//  MockAPI.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/27/24.
//

import Foundation
@testable import KWDC_Check_in
import Alamofire

enum MockAPI {
    case checkUserValidity(resevationInfo: UserReservationInfo)
    case requestWalletPass(resevationInfo: UserReservationInfo)
}

extension MockAPI: Router {
    var baseURL: URL {
        return URL(string: KWDCEnvironment.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkUserValidity:
            return "/valid"
            
        case .requestWalletPass:
            return "/pass"
        }
    }
    
    var query: [URLQueryItem]? {
        return nil
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkUserValidity:
            return .post
            
        case .requestWalletPass:
            return .post
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "Bearer \(KWDCEnvironment.token)"]
    }
    
    var task: RequestTask {
        switch self {
        case .checkUserValidity(let info):
            return .requestJSONEncodable(info)
            
        case .requestWalletPass(let info):
            return .requestJSONEncodable(info)
        }
    }
}
