//
//  ValidationSuccessViewModel.swift
//  KWDC_Check-in
//
//  Created by mac on 9/4/24.
//

import Foundation
import SwiftUI
import PassKit

@Observable final class ValidationSuccessViewModel {
    var newPass: PKPass?
    var isAddPassViewOpen: Bool = false
    
    let passDataManger: PassDataManager
    
    init(passDataManger: PassDataManager) {
        self.passDataManger = passDataManger
    }
    
    func bringValidUserName() -> String {
        passDataManger.bringUserName()
    }
    
    func addPassToWallet() async {
        guard let fetchedPassData = passDataManger.fetchTiket()?.data else {
            isAddPassViewOpen = false
            return
        }
        
        await withCheckedContinuation { continuation in
            guard let pkPass = try? PKPass(data: fetchedPassData) else {
                continuation.resume()
                return
            }
            
            DispatchQueue.main.async {
                self.newPass = pkPass
                self.isAddPassViewOpen = true
                continuation.resume()
            }
        }
    }
}
