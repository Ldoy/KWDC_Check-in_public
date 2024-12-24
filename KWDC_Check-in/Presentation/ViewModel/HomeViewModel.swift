//
//  HomeViewModel.swift
//  KWDC_Check-in
//
//  Created by mac on 8/29/24.
//

import Foundation
import SwiftUI
import Combine

@Observable final class HomeViewModel {
    @ObservationIgnored let naverBookingWebLink: URL = URL(string: "https://www.naver.com")!
    
    var colorScheme: ColorScheme = .light
    var isPresented: Bool = false
    
    func tapCheckinButton() {
        self.isPresented = true
    }
}

