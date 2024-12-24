//
//  MockUsecase.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/27/24.
//

import Foundation
@testable import KWDC_Check_in

final class MockUsecase {
    let repository: MockRepository
    
    init(repository: MockRepository) {
        self.repository = repository
    }
    
    func isValidUser(name: String, bookingNumber: Int) async -> Result<UserValidity, UserError> {
        let result = await repository.checkUserValidity(name: name, bookingNumber: bookingNumber)
        
       return result
    }
    
    func downloadPass(name: String, bookingNumber: Int) async -> Result<TicketDownloadMockResponse, UserError> {
        let result = await repository.downloadPass(name: name, bookingNumber: bookingNumber)
        
       return result
    }
}
