//
//  TicketManager.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation

final class CheckinManager {
    let repository: TicketRepository
    
    init(repository: TicketRepository = TicketRepository()) {
        self.repository = repository
    }
    
    func isValidUser(name: String, bookingNumber: Int) async -> Result<UserValidity, UserError> {
        let result = await repository.checkUserValidity(name: name, bookingNumber: bookingNumber)
        
        return result
    }
    
    func downloadPass(name: String, bookingNumber: Int) async -> Result<TicketDownloadResult, UserError> {
        let result = await self.repository.generateWalletPass(name: name, bookingNumber: bookingNumber)
        
        return result
    }
}
