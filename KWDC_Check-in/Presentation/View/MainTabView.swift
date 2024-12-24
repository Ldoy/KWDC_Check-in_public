//
//  MainTabView.swift
//  KWDC_Check-in
//
//  Created by mac on 9/3/24.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @ScaledMetric(relativeTo: .caption) var caption = 13
    @EnvironmentObject var tabNavigator: TabNavigator
    
    //MARK: - Internal
    private let homeViewModel = HomeViewModel()
    private let ticketViewModel = TicketViewModel()
    private let passDataManager = PassDataManager()

    var body: some View {
        VStack {
            TabView(selection: $tabNavigator.selectedTab) {
                HomeView(viewModel: homeViewModel,
                         passDataManager: passDataManager)
                    .tabItem {
                        VStack(alignment: .center) {
                            if tabNavigator.selectedTab.index == 0 {
                                TabBarItemView(tabNavigator.selectedTab.index)
                            } else {
                                TabBarItemView(0)
                            }
                            Text("checkin_text_label", tableName: LocalizationFileName.mainTab)
                                .bold()
                                .foregroundStyle(.gray)
                        }
                    }
                    .tag(TabNavigator.Tab.checkIn)
                
                TicketView(viewModel: ticketViewModel,
                           passDataManager: passDataManager)
                    .tabItem {
                        VStack(alignment: .center) {
                            if tabNavigator.selectedTab.index == 1 {
                                TabBarItemView(tabNavigator.selectedTab.index)
                            } else {
                                TabBarItemView(1)
                            }
                            Text("ticket_text_label", tableName: LocalizationFileName.mainTab)
                                .bold()
                                .foregroundStyle(.gray)
                        }
                    }
                    .tag(TabNavigator.Tab.ticket)

                DiscoverView()
                    .tabItem {
                        VStack(alignment: .center) {
                            if tabNavigator.selectedTab.index == 2 {
                                TabBarItemView(tabNavigator.selectedTab.index)
                            } else {
                                TabBarItemView(2)
                            }
                            Text("explore_text_label", tableName: LocalizationFileName.mainTab)
                                .bold()
                        }
                    }
                    .tag(TabNavigator.Tab.discover)
            }
            .tint(.mainText)
        }
    }
    
    
    private func TabBarItemView(_ selectedTab: Int) -> some View {
        let systemIconName = getSystemIconName(for: selectedTab)
        return drawTabItem(systemIconName)
    }

    private func getSystemIconName(for selectedTab: Int) -> String {
        switch selectedTab {
        case 0:
            return "checkmark.circle.fill"
        case 1:
            return "wallet.pass"
        case 2:
            return "safari.fill"
        default:
            return ""
        }
    }

    private func drawTabItem(_ iconName: String) -> some View {
        Image(systemName: iconName)
            .symbolRenderingMode(.hierarchical)
    }
}

#Preview {
    MainTabView()
}
