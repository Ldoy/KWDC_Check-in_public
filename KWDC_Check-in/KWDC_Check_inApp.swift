//
//  KWDC_Check_inApp.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import SwiftUI

@main
struct KWDC_Check_inApp: App {
    
    @StateObject var tabNavigator: TabNavigator = TabNavigator()
    @StateObject var device: DeviceType =  DeviceType()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(tabNavigator)
                .environmentObject(device)
        }
    }
}
