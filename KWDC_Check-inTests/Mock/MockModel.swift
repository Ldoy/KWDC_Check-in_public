//
//  MockModel.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/27/24.
//

import Foundation

struct TicketDownloadMockResponse: Decodable {
    let data: String
    let userName: String
    let message: String
    let left: Int?
}

struct MockDataBase: Codable {
    let userName: String
    let bookingNumber: Int
    let left: Int
}
