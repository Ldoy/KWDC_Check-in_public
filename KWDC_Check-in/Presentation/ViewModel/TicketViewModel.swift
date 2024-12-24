//
//  TicketViewModel.swift
//  KWDC_Check-in
//
//  Created by mac on 9/5/24.
//

import Foundation
import PassKit
import CoreImage.CIFilterBuiltins

@Observable final class TicketViewModel {
    enum FetchState {
        case done
        case inFetching
        case notStarted
    }
    
    var hasValidTicket: Bool
    var isAddPassViewOpened: Bool
    var qrImage: UIImage?
    var newPass: PKPass?
    var tiketFetchState: FetchState = .notStarted
    
    private let dataManager: PassDataManager
    
    init(dataManager: PassDataManager = PassDataManager()) {
        self.dataManager = dataManager
        self.hasValidTicket = false
        self.isAddPassViewOpened = false
    }
    
    private func changeFetchState(_ state: FetchState) {
        self.tiketFetchState = state
    }
    
    func addPassToWallet() {
        if hasValidTicket {
            self.assignPass()
            self.isAddPassViewOpened = true
        } else {
            self.isAddPassViewOpened = false
        }
    }
    
    private func isTicketAddToWallet() -> Bool {
        let library = PKPassLibrary()
        
        if library.containsPass(self.newPass ?? PKPass()) {
            return true
        } else {
            return false
        }
    }
    
    func checkValidTicket() {
        self.changeFetchState(.inFetching)
        dataManager.hasPassData(completion: { [weak self] hasPass in
            if hasPass {
                self?.hasValidTicket = true
                self?.assignPass()
                self?.generateQRCode()
            } else {
                self?.hasValidTicket = false
                self?.changeFetchState(.done)
            }
        })
    }

    private func assignPass() {
        if self.hasValidTicket {
            guard let data = dataManager.fetchTiket()?.data,
                  let pass = try? PKPass(data: data) else {
                self.isAddPassViewOpened = false
                return
            }
            self.newPass = pass
        }
    }
    
    func generateQRCode() {
        if self.hasValidTicket {
            let qrUrlString = dataManager.fetchTiket()?.qrUrlString
            guard let qrData = qrUrlString?.data(using: .utf8) else { return }
            print(qrUrlString)
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            
            filter.message = qrData
            
            if let outputImage = filter.outputImage {
                //MARK: Handle Resolution
                let scaleX: CGFloat = 10.0
                let scaleY: CGFloat = 10.0
                let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                
                DispatchQueue.global().async {
                    if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
                        self.qrImage = UIImage(cgImage: cgImage)
                        self.changeFetchState(.done)
                    }
                }
            }
        }
    }
}
