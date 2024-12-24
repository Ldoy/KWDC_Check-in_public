//
//  SavePassDataManater.swift
//  KWDC_Check-in
//
//  Created by mac on 9/11/24.
//

import Foundation

final class PassDataManager {
    let repository: PassRepository
    
    init(repository: PassRepository = PassRepository()) {
        self.repository = repository
    }
    
    func saveTicketData(_ data: Data, userName: String, qrUrl: String, bookingNumber: Int) {
        repository.saveTicket(data, userName: userName, qrUrl: qrUrl,
                              bookingNumber: bookingNumber)
    }
    
    func fetchTiket() -> TicketInfo? {
        repository.bringTiketData()
    }
    
    func bringUserName() -> String {
        self.repository.bringUserName()
    }
    
    func hasPassData(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            if self.fetchTiket() != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
