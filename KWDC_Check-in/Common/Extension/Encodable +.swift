//
//  Encodable +.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
extension Encodable {
    func toDictionary()
    -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            
            guard let dictionary = try JSONSerialization.jsonObject(
                    with: data,
                    options: .fragmentsAllowed) as? [String: Any] else {
                return .init()
            }
            
            return dictionary
        } catch {
            
            return .init()
        }
    }
    
    func toJSON() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
