//
//  PassAddViewModel.swift
//  KWDC_Check-in
//
//  Created by mac on 9/3/24.
//

import SwiftUI

@Observable final class CheckinViewModel {
    @ObservationIgnored let checkInManager: CheckinManager
    @ObservationIgnored let passDataManager: PassDataManager
    
    @ObservationIgnored let emptyString = ""
    @ObservationIgnored let warningBottomPadding: CGFloat = 11
    @ObservationIgnored let defaultBottomPadding: CGFloat = 17
    @ObservationIgnored var previousCount: Int = 0
    
    @ObservationIgnored var localizationFileName = "AlertLocalization"
    @ObservationIgnored var ticketAlertTitle = ""
    @ObservationIgnored var ticketAlertMessage = ""
    
    private(set)var colorScheme: ColorScheme = .light
    private(set)var dividerBottomPadding: CGFloat = 17
    private(set)var passData: Data?
    
    //MARK: - User Input
    var bookingNumber: String = ""
    var userName: String = ""
    
    //MARK: - For insert warning Text view
    var isBookingNumberInserted: Bool?
    
    //MARK: - Check Validity and Pass Download
    var submitedUserInfoState: SubmitedUserInfoState = .unchecked
    var isFinishedChecking: Bool = false
    var isPassDownloadSuccessed: Bool = false
    var downloadState: PassDownloadState = .none
    
    enum SubmitedUserInfoState {
        case unchecked
        case invalidInput
        
        case validUser
        case validGroupUser
        
        case invalidUser
        case groupUserNoLeftTicket
        case noLeftTicket
    }
    
    enum PassDownloadState {
        case none
        case start
        case finished
        case failed
    }
    
    //MARK: Internal LifeCycle
    init(userValidCheckUseCase: CheckinManager = CheckinManager(),
         passDataManager: PassDataManager = PassDataManager()) {
        self.checkInManager = userValidCheckUseCase
        self.passDataManager = passDataManager
    }
    
    //MARK: - Relate to user input
    func insertSpace(_ previousValue: String,
                     _ currentValue: String) {
        self.previousCount = previousValue.count
        let space: String = " "
        
        let numbers = currentValue.filter { cha in
            cha != " "
        }
        
        if previousValue.count < currentValue.count {
            if (numbers.count == 3 && currentValue.count == 3) || (numbers.count == 6 && currentValue.count == 7) {
                self.bookingNumber.append(space)
            }
        }
    }
    
    func adjustDividerPadding() {
        if self.bookingNumber != emptyString,
            self.userName != emptyString {
            isBookingNumberInserted = true
            dividerBottomPadding = defaultBottomPadding
        } else {
            isBookingNumberInserted = false
            dividerBottomPadding = .zero
        }
    }
    
    private func convertedBookingNumber() -> Int? {
        guard let number = Int(self.bookingNumber.filter({ $0 != " "})) else {
            return nil
        }
        
        guard String(number).count == 9 else {
            return nil
        }
        
        return number
    }
    
    private func isValidUserNameStyle() -> Bool {
        let name = self.userName.filter({ $0 != " " })
        
        guard name.count > .zero, name.count < 15 else {
            return false
        }
        
        return true
    }

    //MARK: - Check User input validity
    func checkUserValidity() async {
        guard !isTextfieldsEmpty() else {
            return
        }
        
        //TODO: refactroing
        guard let number = convertedBookingNumber(),
                isValidUserNameStyle() else {
            informInvalidInput()
            return
        }
        
        let result = await checkInManager.isValidUser(name: self.userName, bookingNumber: number)
        
        switch result {
        case .success(let result):
            await handleValidityCheckResult(result)
            
        case .failure(let error):
            handleServiceError(error)
        }
    }
    
    private func isTextfieldsEmpty() -> Bool {
        let name = self.userName.filter({ $0 != " " })
        let bookingNumber = self.bookingNumber.filter({ $0 != " " })
        
        if name != "", bookingNumber != "" {
            return false
        } else {
            return true
        }
    }
    
    private func informInvalidInput() {
        generateInvalidInputAlert()
        changeSubmitUserInfo(state: .invalidInput)
        informValidityCheckFinished()
    }
    
    private func generateInvalidInputAlert() {
        let invalidAlertTitle = String(localized: "invalidInput_text_label" , table: localizationFileName)
        let invalidAlertMessage = String(localized: "예약 번호를 다시 확인해주세요.", table: localizationFileName)
        generateAlert(title: invalidAlertTitle, message: invalidAlertMessage)
    } 
    
    private func changeSubmitUserInfo(state: SubmitedUserInfoState) {
        self.submitedUserInfoState = state
    }

    private func generateAlert(title: String, message: String) {
        self.ticketAlertTitle = title
        self.ticketAlertMessage = message
    }
   
    private func handleValidityCheckResult(_ result: UserValidity) async {
        if result.isValid {
            if let convertedNumber = convertedBookingNumber() {
                UserDataManager.shared.updateValidUserInfo(name: self.userName,
                                                         bookingNumber: convertedNumber)
                print("valid check가 끝난 유저의 정보가 저장되었습니다.")
            }
            
            changeSubmitUserInfo(state: .validUser)
            
            if result.isGroup {
                let grouptTitle = String(localized: "단체 구매 티켓", table: localizationFileName)
                let groupMessage = String(result.left) + String(localized: "left_ticket_text", table: localizationFileName)
                generateAlert(title: grouptTitle, message: groupMessage)
            } else {
                let soloUserTitle = String(localized: "티켓 생성", table: localizationFileName)
                let soloUserMessage = String(localized: "한 번 생성된 티켓은 재발급이 어려워요.", table: localizationFileName)
                generateAlert(title: soloUserTitle, message: soloUserMessage)
            }
            
        } else {
            if result.left == .zero {
                if result.isGroup {
                    changeSubmitUserInfo(state: .groupUserNoLeftTicket)

                    let noLeftGroupTitle = String(localized: "groupUserNoLeft_alert_title_text_label", table: localizationFileName)
                    let noLeftGroupMessage = String(localized: "exceed_ticket_title_text_label", table: localizationFileName)
                    
                    generateAlert(title: noLeftGroupTitle, message: noLeftGroupMessage)

                } else {
                    changeSubmitUserInfo(state: .noLeftTicket)

                    let noLeftSoloTitle = String(localized: "티켓이 만들어진 예약번호", table: localizationFileName)
                    let noLeftSoloMessage =  String(localized: "alread_ticket_text_label", table: localizationFileName)
                    
                    generateAlert(title: noLeftSoloTitle, message: noLeftSoloMessage)

                }
                
            } else if result.left == -1 {
                changeSubmitUserInfo(state: .invalidUser)
                let nonUserInfoTitle = String(localized: "일치하지 않는 예약번호" , table: localizationFileName)
                let nonUserInfoMessage = String(localized: "예약 번호를 다시 확인해주세요.", table: localizationFileName)
                
                generateAlert(title: nonUserInfoTitle, message: nonUserInfoMessage)
            }
        }
        
        informValidityCheckFinished()
    }
    
    private func handleServiceError(_ error: Error) {
        informValidityCheckFinished()
    }
    
    private func informValidityCheckFinished() {
        self.isFinishedChecking = true
    }

    //MARK: - Download Pass
    func downloadPass() async {
        guard let number = convertedBookingNumber(),
                let userName = UserDataManager.shared.bringUserName() else {
            return
        }
        
        let result = await checkInManager.downloadPass(name: userName, bookingNumber: number)
        
        switch result {
        case .success(let result):
            handleSuccessPassDownload(result)
            finishDownloading()
            
        case .failure(let error):
            handleDownloadFail(error)
        }
    }
    
    private func handleSuccessPassDownload(_ result: TicketDownloadResult) {
        let dataString = result.data
        
        if let data = convert(encodedData: dataString) {
            self.passData = data
            //TODO: Booking number 받아오기 
            passDataManager.saveTicketData(self.passData!, userName: result.userName,
                                           qrUrl: result.qrCodeUrl, bookingNumber: 10)
            print(result.qrCodeUrl)
        } else {
            handleDataConvertFail()
        }
    }

    func startDownloading() {
        self.downloadState = .start
    }
    
    private func finishDownloading() {
        self.downloadState = .finished
        self.isPassDownloadSuccessed = true
        self.refreshTextField()
    }
    
    private func convert(encodedData: String) -> Data? {
        if let data = Data(base64Encoded: encodedData) {
            return data
        } else {
            return nil
        }
    }
    
    private func handleDownloadFail(_ error: Error) {
        self.isPassDownloadSuccessed = false
        self.downloadState = .failed
    }
    
    private func handleDataConvertFail() {
        
    }
    
    //MARK: - When Dismiss the view
    func refreshUserInfo() {
        refreshTextField()
        refreshValidUserData()
    }
    
    private func refreshTextField() {
        self.userName = ""
        self.bookingNumber = ""
    }
    
    private func refreshValidUserData() {
        UserDataManager.shared.refresh()
    }
}
