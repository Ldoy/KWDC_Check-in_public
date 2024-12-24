//
//  PassAddView.swift
//  KWDC_Check-in
//
//  Created by mac on 8/29/24.
//

import SwiftUI
import AsyncButton

struct CheckInView: View {
    //MARK: - Accessiblity properties for dynamic font
    @ScaledMetric(relativeTo: .caption2) var caption2 = 11
    @EnvironmentObject var tabNavigator: TabNavigator
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    @State var viewModel: CheckinViewModel
    private let passDataManager: PassDataManager

    //MARK: - Inner life cycle
    private let leftPadding: CGFloat = 16
    
    init(viewModel: CheckinViewModel, passDataManager: PassDataManager) {
        self.viewModel = viewModel
        self.passDataManager = passDataManager
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                        viewModel.refreshUserInfo()
                    } label: {
                        Text(LocalizedStringKey("cancel_button_label"),
                             tableName: LocalizationFileName.checkInView)
                    }
                    .foregroundColor(.linkText)
                    
                    Spacer()
                    
                    AsyncButton("done_button_label", 
                                LocalizationFileName.checkInView) {
                        self.isFocused = false
                        self.viewModel.adjustDividerPadding()
                        await self.viewModel.checkUserValidity()
                    }
                    .foregroundColor(.linkText)
                }
                .padding(.bottom, 19)
                .padding(.top, 11)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey("title_label"), tableName: LocalizationFileName.checkInView)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 19)
                        .accessibilityValue(Text("checkin_title_accessibility_hint", tableName: LocalizationFileName.checkInView))
                    
                    HStack {
                        Text("user_name_label", tableName: LocalizationFileName.checkInView)
                            .font(.body)
                            .foregroundStyle(.grayText)
                        Spacer()
                        
                        TextField(text: $viewModel.userName) {
                            Text("user_name_textField_label",
                                 tableName: LocalizationFileName.checkInView)
                        }
                        .keyboardType(.default)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isFocused)
                        .accessibilityValue("\(viewModel.userName)")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityHint(Text("name_textField_accessibility_hint", tableName: LocalizationFileName.checkInView))
                    
                    Divider()
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("booking_number_label",
                             tableName: LocalizationFileName.checkInView)
                        .font(.body)
                        .foregroundStyle(.grayText)
                        .accessibilityLabel(Text("bookingNumber_accessiblity_labelName", tableName: LocalizationFileName.checkInView))
                        
                        Spacer()
                        
                        TextField(text: $viewModel.bookingNumber) {
                            Text("booking_number_textField",
                                 tableName: LocalizationFileName.checkInView)
                            .accessibilityValue("\(viewModel.bookingNumber)")
                        }
                        .keyboardType(.numberPad)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isFocused)
                        .onChange(of: viewModel.bookingNumber, { oldValue, newValue in
                            viewModel.insertSpace(oldValue, newValue)
                            dismissKeyboard(newValue)
                        })
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityHint(Text("number_textField_accessibility_hint", tableName: LocalizationFileName.checkInView))
                    
                    Divider()
                        .padding(.bottom, viewModel.dividerBottomPadding)
                    
                    if self.viewModel.isBookingNumberInserted == false {
                        Text("emptySubmit_warning_label",
                             tableName: LocalizationFileName.checkInView)
                        .foregroundStyle(.warningText)
                        .font(.caption2)
                        .padding(.bottom, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Link(destination: Constant.naverBookingPageUrl) {
                            Text("exit_naver_label",
                                 tableName: LocalizationFileName.checkInView)
                            .foregroundStyle(.linkText)
                            .font(.caption2)
                            .captionViewModifier()
                            .underline()
                            .padding(.bottom, 10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("bookingNumber_process_label", tableName: LocalizationFileName.checkInView)
                                .font(.caption2)
                                .foregroundStyle(.grayText)
                                .captionViewModifier()
                                .padding(.bottom, 10)
                            
                            Text("warningLabel", tableName: LocalizationFileName.checkInView)
                                .font(.caption2)
                                .foregroundStyle(.checkInHighlightText)
                                .captionViewModifier()
                        }
                        .accessibilityElement(children: .combine)

                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Link(destination: Constant.customerServiceChannel) {
                            Text("customer_surpport_label", tableName: LocalizationFileName.checkInView)
                                .underline(true, pattern: .solid, color: .grayText)
                                .font(.caption2)
                                .foregroundStyle(.grayText)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, leftPadding)
        .padding(.vertical, 20)
        .overlay(content: {
            switch  self.viewModel.downloadState {
            case .start:
                ProgressView()
                    .progressViewStyle(.circular)
            default:
                EmptyView()
            }
        })
        //MARK: - Handle user input info validity result
        .alert(viewModel.ticketAlertTitle,
               isPresented: $viewModel.isFinishedChecking,
               actions: {
            CustomAlertSecondaryButton()
            if viewModel.submitedUserInfoState == .validUser {
                Button {
                    self.viewModel.startDownloading()
                    Task {
                        await self.viewModel.downloadPass()
                    }
                } label: {
                    AlertCustomDefaultTextView()
                }
                .keyboardShortcut(.defaultAction)
            }
            
        }, message: {
            Text(viewModel.ticketAlertMessage)
        })
        //.alertButtonTint(color: .linkText)
        .alertButtonTintColor(.linkText)
        
        //MARK: - When user want to add the pass to Wallet
        .sheet(isPresented: $viewModel.isPassDownloadSuccessed,
               content: {
            ValidationSuccessView(viewModel: ValidationSuccessViewModel(passDataManger: passDataManager))
        })
        .onDisappear {
            self.viewModel.refreshUserInfo()
        }
    }
}

extension CheckInView {
    private func CustomAlertSecondaryButton() -> Button<some View> {
        switch viewModel.submitedUserInfoState {
        case .validUser, .invalidUser:
            return  Button {
                viewModel.refreshUserInfo()
            } label: {
                AlertCustomCancelTextView()
            }
            
        case .invalidInput:
            //TODO: 입력값 필터링 로직 추가 후 알림 메세지 추가하기
            return  Button {
                viewModel.refreshUserInfo()
            } label: {
                AlertCustomCancelTextView()
            }
            
        case .noLeftTicket, .groupUserNoLeftTicket:
            return  Button {
                viewModel.refreshUserInfo()
                self.dismiss()
                
                //TODO: 로직 개선하기
                tabNavigator.changeTab(.ticket)
            } label: {
                TicketCheckTextView()
            }
            
        default:
            return Button {
                viewModel.refreshUserInfo()
            } label: {
                AlertCustomCancelTextView()
            }
        }
    }
    
    private func dismissKeyboard(_ newValue: String) {
        if newValue.filter({ $0 != " "}).count >= 9 {
            isFocused = false
        }
    }
    
    private func AlertCustomDefaultTextView() -> Text {
        return Text("creat_alert_button_label",
                    tableName: LocalizationFileName.alert)
        .bold()
        .foregroundStyle(.linkText)
    }
    
    private func AlertCustomCancelTextView() -> Text {
        return Text("cancel_alert_button_label",
                    tableName: LocalizationFileName.alert)
        .foregroundStyle(.linkText)
    }
    
    private func TicketCheckTextView() -> Text {
        return Text("check_ticket_button_label",
                    tableName: LocalizationFileName.alert)
        .foregroundStyle(.linkText)
    }
    
    private func ReWriteTextView() -> Text {
        return Text("rewrite_alert_button_label",
                    tableName: LocalizationFileName.alert)
        .foregroundStyle(.linkText)
    }
}

#Preview {
    CheckInView(viewModel: CheckinViewModel(userValidCheckUseCase: CheckinManager(repository: TicketRepository())), passDataManager: PassDataManager())
}
