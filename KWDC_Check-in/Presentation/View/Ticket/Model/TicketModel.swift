//
//  KWDC_Check-in.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation

struct UserReservationInfo: Codable {
    let name: String
    let bookingNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "user_name"
        case bookingNumber = "booking_number"
    }
}

struct UserValidity: Decodable {
    let isValid: Bool
    let message: String
    let left: Int
    let isGroup: Bool
}

struct TicketDownloadResult: Decodable {
    let data: String
    let userName: String
    let message: String
    let left: Int
    let qrCodeUrl: String
}
