//
//  MainTabBarViewModel.swift
//  KWDC_Check-in
//
//  Created by mac on 9/24/24.
//

import Foundation

@MainActor
class TabNavigator: ObservableObject {
    @Published var selectedTab: Tab = .checkIn
    
    func changeTab(_ tab: Tab) {
        self.selectedTab = tab
    }
    
    enum Tab {
        case checkIn
        case ticket
        case discover
        
        var index: Int {
            switch self {
            case .checkIn: 0
            case .ticket: 1
            case .discover: 2
            }
        }
    }
}
