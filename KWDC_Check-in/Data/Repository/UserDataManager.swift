//
//  ValidUserInfo.swift
//  KWDC_Check-in
//
//  Created by mac on 9/4/24.
//

import Foundation

final class UserDataManager {
    static let shared: UserDataManager = UserDataManager()
    
    private init() {  }
    
    private var userName: String?
    private var bookingNumber: Int?
    
    func updateValidUserInfo(name: String, bookingNumber: Int) {
        self.userName = name
        self.bookingNumber = bookingNumber
    }
    
    func refresh() {
        self.userName = nil
        self.bookingNumber = nil
    }
    
    func bringUserName() -> String? {
        return self.userName
    }
    
    func bringBookingNumber() -> Int? {
        return self.bookingNumber
    }
}
