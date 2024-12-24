//
//  Router.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
import Alamofire

protocol Router {
    var baseURL: URL { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var task: RequestTask { get }
}

extension Router {
    func asURLRequest() throws -> URLRequest {
        var url = self.baseURL.appendingPathComponent(self.path)
        
        if let queryItem = self.query {
            url.append(queryItems: queryItem)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.headers = HTTPHeaders(self.headers ?? [:])
        
        switch self.task {
        case .requestParameters(let parameters, let encoding):
            do {
                request = try encoding.encode(request, with: parameters)
            } catch {
                throw error
            }
            
        case .requestJSONEncodable(let encodable):
            request.httpBody = encodable.toJSON()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 
        default:
            break
        }
        
        return request
    }
}

enum RequestTask {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    case requestQueries(parameters: [String: Any])
}
