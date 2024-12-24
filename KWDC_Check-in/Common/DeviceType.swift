//
//  DeviceType.swift
//  KWDC_Check-in
//
//  Created by mac on 10/17/24.
//

import Foundation
import UIKit

class DeviceType: ObservableObject {
    @Published var info: Device = .other
    
    init() {
        isProMaxDevice()
        print(self.info)
    }
    
    private func isProMaxDevice() {
        let screenSize = UIScreen.main.nativeBounds.size
        let minimumProWidth: CGFloat = 1242
        print(screenSize)
        if screenSize.width >= minimumProWidth {
            self.info = .largeScreen
        } else {
            self.info = .other
        }
    }
    
    enum Device {
        case largeScreen
        case other
    }
}
