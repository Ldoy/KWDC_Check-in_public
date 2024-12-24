//
//  TicketAPI.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
import Alamofire

enum TicketAPI {
    case checkUserValidity(resevationInfo: UserReservationInfo)
    case requestWalletPass(resevationInfo: UserReservationInfo)
}

extension TicketAPI: Router {
    var baseURL: URL {
        return URL(string: "https://\(KWDCEnvironment.baseURL)")!
    }
    
    var path: String {
        switch self {
        case .checkUserValidity:
            return "/valid"
            
        case .requestWalletPass:
            return "/generate_pass"
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
