//
//  PassRepository.swift
//  KWDC_Check-in
//
//  Created by mac on 9/11/24.
//

import Foundation

final class PassRepository {
    private let storage: CoreDataStorage
    
    init(storage: CoreDataStorage = .shared) {
        self.storage = storage
    }
    
    func saveTicket(_ data: Data, userName: String, qrUrl: String, bookingNumber: Int) {
        storage.saveTicket(data, userName: userName, qrUrl: qrUrl, bookigNumber: Int64(bookingNumber))
    }
    
    func bringTiketData() -> TicketInfo? {
        storage.fetchTicket()
    }
    
    func bringUserName() -> String {
        storage.bringUserName()
    }
}
