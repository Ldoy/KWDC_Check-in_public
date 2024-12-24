//
//  ExploreView.swift
//  KWDC_Check-in
//
//  Created by mac on 9/5/24.
//

import SwiftUI

struct DiscoverView: View {
    private let kwdcHomepageButtonText = String(localized: "start_section_subtitle_text_label",
                                                table: LocalizationFileName.discoverView)
    private let inqueryButtonText = String(localized: "contact_section_title_text_label",
                                           table: LocalizationFileName.discoverView)
    private let checkTicketNumberButtonText = String(localized: "check_ticketNumber_label",
                                                     table: LocalizationFileName.discoverView)
    private let kwdcActButtonText = String(localized: "kwdc_act_label",
                                           table: LocalizationFileName.discoverView)
    private let kwdcDiscordButtonText = String(localized: "kwdcDiscord_label",
                                               table: LocalizationFileName.discoverView)
    private let onsiteCheckinButtonText = String(localized: "onsite_checkin_label",
                                                 table: LocalizationFileName.discoverView)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("explore_title_text_label", tableName: LocalizationFileName.discoverView)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.mainText)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 18)
                    Spacer()
                }
                
                SectionView(items: [
                    (kwdcHomepageButtonText, URL(string: "https://kwdc.dev/"), iconImageName: "kwdc_hompage"),
                    (inqueryButtonText, URL(string: "https://forms.gle/HVcT2KJo48Fnxoic9"), iconImageName: "kwdc_inquery"),
                    (checkTicketNumberButtonText, Constant.naverBookingPageUrl, iconImageName: "bookingNubmer_check"),
                    (kwdcActButtonText, URL(string: "https://elfin-cicada-c15.notion.site/KWDC24-0d72e6e294a04f2e9b1373cd04e5ad0a?pvs=4"), iconImageName: "kwdc_act"),
                    (kwdcDiscordButtonText, URL(string: "https://discord.gg/bBnefGaURd"), iconImageName: colorScheme == .light ? "discord_logo" : "discord_logo_green"),
                    (onsiteCheckinButtonText, URL(string: "https://elfin-cicada-c15.notion.site/KWDC24-3b1840e4434d40cca851d18d51f170be?pvs=4"), iconImageName: "onsite_checkin"),
                ])
            }
            .padding(.top, 20)
        }
    }
}

struct SectionView: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let items: [(subTitle: String, link: URL?, iconImageName: String)]
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(alignment: .center) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.subTitle) { item in
                    Button {
                        openURL(item.link!)
                    } label: {
                        VStack(alignment: .leading) {
                            Image(item.iconImageName)
                                .padding(.bottom, 5)
                            Text(item.subTitle)
                                .foregroundStyle(.exploreTitle)
                                .font(.callout)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .dynamicTypeSize(.xSmall ... .accessibility5)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.bottom, 25)
                        .frame(minWidth: 100, idealWidth: 180,
                               maxWidth: 180, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    DiscoverView()
}
