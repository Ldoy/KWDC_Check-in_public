//
//  ContentView.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import SwiftUI

struct HomeView: View {
    //MARK: Accessiblity properties for dynamic font
    @ScaledMetric(relativeTo: .caption) var caption = 13
    @ScaledMetric(relativeTo: .body) var fontBody = 15
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var device: DeviceType
    @State var viewModel: HomeViewModel
    private var spacerMinimum: CGFloat {
        return (device.info == .largeScreen) ? 30 : 0
    }
    
    //MARK: Inner life cycle
    private let ticketRequestButtonTitle = "KWDC24 Check-in"
    private let localizableFileName = "HomeViewLocalization"
    private let passDataManager: PassDataManager
    
    init(viewModel: HomeViewModel ,passDataManager: PassDataManager) {
        self.viewModel = viewModel
        self.passDataManager = passDataManager
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                VStack {
                    Text("KWDC로의 도약", tableName: localizableFileName)
                        .foregroundStyle(.mainText)
                        .font(.largeTitle)
                        .bold()
                        .titleViewModifier()
                        .padding()
                    
                    Text("네이버 예약을 하셨다면, 예약 번호로 \n 바로 체크인 하실 수 있습니다.",
                         tableName: localizableFileName)
                    .padding([.bottom, .leading, .trailing])
                    .font(.footnote)
                    .captionViewModifier()
                    .multilineTextAlignment(.center)
                }
                .accessibilityElement(children: .combine)
                
                VStack {
                    Text("체크인은 예약 번호당 한 번만 가능합니다.",
                         tableName: localizableFileName)
                    .font(.footnote)
                    .captionViewModifier()
                    .multilineTextAlignment(.center)
                    
                    Link(destination: Constant.naverBookingPageUrl) {
                        Text("네이버 예약 번호 확인하기", tableName: localizableFileName)
                            .foregroundStyle(.linkText)
                            .underline()
                            .font(.footnote)
                            .captionViewModifier()
                            .multilineTextAlignment(.center)
                    }
                    .accessibilityAddTraits(.isLink)
                }
                
                Spacer(minLength: spacerMinimum)
                MainImageView()
                Spacer(minLength: spacerMinimum)
                
                CheckInButtonView()
                Spacer()
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.isPresented, content: {
            CheckInView(viewModel: CheckinViewModel(),
                        passDataManager: passDataManager)
        })
    }
}

extension HomeView {
    private func MainImageView() -> ModifiedContent<Image, AccessibilityAttachmentModifier> {
        return Image(Constant.homeMainImage)
            .accessibilityLabel(String(localized: "mainImage_accessibility_value", table: LocalizationFileName.homeView))
            .accessibilityHint(String(localized: "mainImage_accessibility_hint", table: LocalizationFileName.homeView))
    }
    
    private func CheckInButtonView() -> ModifiedContent<Button<some View>, AccessibilityAttachmentModifier> {
        return Button {
            viewModel.tapCheckinButton()
        } label: {
            Text("ticketRequest_button_text_label",
                 tableName: LocalizationFileName.homeView)
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.homViewButtonText)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.buttonBackground))
            .cornerRadius(15)
            .captionViewModifier()
        }
        .accessibilityHint(String(localized: "checkin_button_accessibility_hint", table: LocalizationFileName.homeView))
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(),
             passDataManager: PassDataManager())
}


