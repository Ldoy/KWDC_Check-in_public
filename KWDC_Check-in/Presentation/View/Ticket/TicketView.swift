//
//  TicketView.swift
//  KWDC_Check-in
//
//  Created by mac on 9/5/24.
//

import SwiftUI
import PassKit

struct TicketView: View {
    @State private var ticketViewModel: TicketViewModel
    private let passDataManager: PassDataManager
    private let ticketStartOffset: CGFloat = 18
    private let ticketTextPadding: CGFloat = 8
    
    private(set) var delegate: PassDelegatable = AddPassDelegate()
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabNavigator: TabNavigator
    
    init(viewModel: TicketViewModel, passDataManager: PassDataManager) {
        self.passDataManager = passDataManager
        self.ticketViewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("title_text_label",
                     tableName: LocalizationFileName.ticketView)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.mainText)
                Spacer()
            }
            .onAppear {
                if !ticketViewModel.hasValidTicket {
                    ticketViewModel.checkValidTicket()
                }
            }
            
            switch self.ticketViewModel.hasValidTicket {
            case true:
                if self.ticketViewModel.tiketFetchState == .inFetching {
                    VStack {
                        ProgressView()
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("EVENT")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.white)
                            .padding(.top, 26)

                        Text("KWDC24")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 14)
                        
                        Text("DATE")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.white)
                        
                        Text("conference_date_text_label", tableName: LocalizationFileName.ticketView)
                            .font(.system(size: 18, weight: .medium))
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Image(uiImage: (self.ticketViewModel.qrImage ?? UIImage(named: "mainLogo_light")) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                            Spacer()
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, ticketStartOffset)
                    .frame(maxWidth: .infinity, maxHeight: 500)
                    .background(
                        Image("Ticket-card-bg")
                            .resizable()
                            .clipShape(.rect(cornerRadius: 15))
                            .foregroundStyle(.ticketPlaceHolder)
                            .accessibilityHidden(true)
                    )
                    .ignoresSafeArea()
                    .accessibilityElement(children: .combine)
                    .accessibilityHint(Text("ticket_accessibility_hint", tableName: LocalizationFileName.ticketView))
                    .padding(.bottom, 20)
                    
                    AddPassToWalletButton {
                        Task {
                            ticketViewModel.addPassToWallet()
                        }
                    }
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                    .accessibilityHint(Text("walletAddButton_accessibility_hint", tableName: LocalizationFileName.ticketView))
                    .addPassToWalletButtonStyle(
                        colorScheme == .light ?
                            .black : .blackOutline)
                    .containerRelativeFrame(.vertical) { length, _ in
                        length / 13
                    }
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 10 * 8.3
                    }
                }
                
            case false:
                PlaceHolderView()
                    .containerRelativeFrame(.vertical) { length, _ in
                        length / 3
                    }
                    .accessibilityValue(Text("palceHolder_accessibility_value", tableName: LocalizationFileName.ticketView))
            }
            Spacer()
        }
        .sheet(isPresented: $ticketViewModel.isAddPassViewOpened) {
            AddPassesViewController(
                pass: ticketViewModel.newPass,
                delegate: delegate
            )
        }

        .padding(.top, 20)
        .padding(.horizontal, 16)
    }
}

extension TicketView {
    private func PlaceHolderView() -> ZStack<TupleView<(some View, Button<Text>)>> {
        return ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.ticketPlaceHolder)
            Button(action: {
                tabNavigator.changeTab(.checkIn)
            }, label: {
                Text("emptyView_subtitle_text_label",
                     tableName: LocalizationFileName.ticketView)
                .font(.headline)
                .foregroundColor(.mainText)
            })
        }
    }
}

#Preview {
    TicketView(viewModel: TicketViewModel(), passDataManager: PassDataManager())
}
