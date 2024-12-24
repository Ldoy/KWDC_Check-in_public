//
//  OSLog +.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
import OSLog

extension Logger {
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    // 네트워크 관련 로그
    static let networking = Logger(
        subsystem: subsystem,
        category: "networking"
    )
}
