//
//  AddPassView.swift
//  KWDC_Check-in
//
//  Created by mac on 9/3/24.
//

import SwiftUI
import PassKit

struct ValidationSuccessView: View {
    @FocusState private var isFocused: Bool
    @State var viewModel: ValidationSuccessViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss

    @ScaledMetric(relativeTo: .largeTitle) var largeTitle = 34
    @ScaledMetric(relativeTo: .caption) var caption = 16

    private(set) var delegate: PassDelegatable = AddPassDelegate()
    
    private let leftPadding: CGFloat = 22
    private let passAlertSheetMessage = ""
    private let passAlertSheetTitle = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .center) {
                Text(String(localized: "hello_text_label", table: LocalizationFileName.validation) +
                     String(" \(viewModel.bringValidUserName())") +
                     String(localized: "sir_text_label", table: LocalizationFileName.validation))
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.mainText)
                .multilineTextAlignment(.center)
                .padding(.bottom, 21)
                .titleViewModifier()
                
                Text("greeting_text_label", tableName: LocalizationFileName.validation)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.mainText)
                    .captionViewModifier()
                
                Spacer()
                Image(Constant.homeMainImage)
                Spacer()
            }
            
            Spacer()
            
            AddPassToWalletButton {
                Task {
                    await viewModel.addPassToWallet()
                }
            }
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white, lineWidth: 0.5)
            )
            .accessibilityLabel("")
            .addPassToWalletButtonStyle(
                colorScheme == .light ?
                    .black : .blackOutline)
            .containerRelativeFrame(.horizontal) { length, _ in
                length / 10 * 8.3
            }
            .containerRelativeFrame(.vertical) { height, _ in
                height / 14
            }
            
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(Text("addButton_accessibility_hint", tableName: LocalizationFileName.validation))
        .padding(.vertical, 50)
        .padding(.horizontal, leftPadding)
        .sheet(isPresented: $viewModel.isAddPassViewOpen) {
            AddPassesViewController(
                pass: viewModel.newPass,
                delegate: delegate
            )
        }
        .onChange(of: delegate.isFinished) { oldValue, newValue in
            if newValue == true {
                self.dismiss()
                // 티켓탭의 월렛추가 버튼 비활성화
            }
        }
    }
}

#Preview {
    ValidationSuccessView(viewModel: ValidationSuccessViewModel(passDataManger: PassDataManager()))
}
