//
//  UserError.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
enum UserError: String, Error {
    //MARK: - KWDC server error
    case networkError = "KWDC 서버 점검중입니다. 잠시 후 시도해주세요. 동일한 결과가 반복된다면, 상담창구로 문의주세요."
    case decodingError = "알 수 없는 문제가 생겼네요! 잠시 후 시도해주세요. 동일한 결과가 반복된다면, 상담창구로 문의주세요."
    
    //MARK: - KWDC 400~499 response
    case missMatch = "이름과 예약번호가 일치하지 않습니다."
    case invalidUser = "티켓 구매 정보가 없습니다."
    case unknowned = "알 수 없는 에러입니다. 체크인 담당자에게 문의해 주세요."
}

