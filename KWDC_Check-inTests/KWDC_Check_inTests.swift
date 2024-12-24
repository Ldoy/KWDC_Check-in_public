//
//  KWDC_Check_inTests.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/27/24.
//

import XCTest
@testable import KWDC_Check_in

final class KWDC_Check_inTests: XCTestCase {

    var requestUsecase: MockUsecase!
    
    override func setUp() {
        super.setUp()
        self.requestUsecase = MockUsecase(repository: MockRepository())
    }
    //MARK: - Tests for user validity
    func test_check_validUserInfo_return_validity_true_leftTicket_MoerThanZero() async {
        //given
        let userName = "Sheila"
        let bookingNumber = 136676804
      
        //when
        let result = await self.requestUsecase.isValidUser(name: userName, 
                                                           bookingNumber: bookingNumber)
        
        //then
        switch result {
        case .success(let result):
            print(result)
            XCTAssertEqual(result.isValid, true)
            //XCTAssertEqual(result.left! > .zero, true)

        case .failure(let error):
            print(error)
            break
        }
    }
    
    func test_check_inValidUserInfo_return_validity_false() async {
        //given
        let userName = "Sheila"
        let invalidBookingNumber = 136676803
      
        //when
        let result = await self.requestUsecase.isValidUser(name: userName, 
                                                           bookingNumber: invalidBookingNumber)
        
        //then
        switch result {
        case .success(let result):
            print(result)
            XCTAssertEqual(result.isValid, false)
            XCTAssertEqual(result.message, "티켓을 확인할 수 없습니다. 예약자와 예약번호를 확인해주세요")
        case .failure(let error):
            print(error)
            break
        }
    }
    
    func test_check_validUser_noLeft_return_validity_false() async {
        //given
        let userName = "Jasmine"
        let bookingNumber = 75047435
      
        //when
        let result = await self.requestUsecase.isValidUser(name: userName,
                                                           bookingNumber: bookingNumber)
        
        //then
        switch result {
        case .success(let result):
            XCTAssertEqual(result.isValid, false)
            XCTAssertEqual(result.left, 0)

        case .failure(let error):
            print(error)
            break
        }
    }
    
    func test_check_validUser_group_return_validity_true_leftTicket_MoerThanZero() async {
        //given
        let userName = "Linus"
        let bookingNumber = 111736916
      
        //when
        let result = await self.requestUsecase.isValidUser(name: userName,
                                                           bookingNumber: bookingNumber)
        
        //then
        switch result {
        case .success(let result):
            print(result)
            XCTAssertEqual(result.isValid, true)
            XCTAssertEqual(result.left, 3)
            
        case .failure(let error):
            print(error)
            break
        }
    }
    
    //MARK: - Download Pass
    func test_validUser_downloadPass_return_passData() async {
        //given
        let userName = "Sheila"
        let bookingNumber = 136676804
        
        //when
        let result = await requestUsecase.downloadPass(name: userName,
                                                           bookingNumber: bookingNumber)
        //then
        switch result {
        case .success(let result):
            print(result)
            XCTAssertEqual(result.data, "data")
            XCTAssertEqual(result.left, 0)

        case .failure(let error):
            print(error)
            break
        }
    }
}
