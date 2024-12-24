//
//  MockDataTask.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/28/24.
//

import Foundation
@testable import KWDC_Check_in

protocol UrlSessionable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

final class MockUrlSession: UrlSessionable {
    
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        switch request.httpMethod {
        case "POST":
            return try await postRequest(for: request)
        default:
            return (Data(), URLResponse())
        }
    }
    
    private func postRequest(for request: URLRequest) async throws -> (Data, URLResponse) {
        let isPassRequest = request.url?.pathComponents.contains(where: { path in
            return path == "pass"
        })
        
        guard let data = request.httpBody else {
            throw NetworkError.uploadFailed
        }
        
        if let isPassRequest = isPassRequest, isPassRequest {
            return try mockPassReponse(data, request)
        } else {
            return try mockValidCheckResponse(data, request)
        }
    }
    
    
    private func mockPassReponse(_ data: Data, _ request: URLRequest) throws -> (Data, URLResponse) {
        do {
            let requestData = try JSONDecoder().decode(UserReservationInfo.self, from: data)
            let user = try isValidUser(requestData)
            
            if let user = user {
                if user.left > .zero, let response = generateResponse(url: request.url!, code: 200) {
                    return (generatePassDownloadResponseString(state: .valid, mockUser: user).data(using: .utf8)!, response)
                } else if user.left == .zero, let response = generateResponse(url: request.url!, code: 200) {
                    return ((generatePassDownloadResponseString(state: .valid, mockUser: user).data(using: .utf8)!, response))
                } else if let response = generateResponse(url: request.url!, code: 210) {
                    return ((generatePassDownloadResponseString(state: .valid, mockUser: user)).data(using: .utf8)!, response)
                }
            }
        } catch {
            throw NetworkError.decodingFailed
        }
        
        return (Data(), URLResponse())
    }
    
    private func mockValidCheckResponse(_ data: Data, _ request: URLRequest) throws -> (Data, URLResponse) {
        do {
            let requestData = try JSONDecoder().decode(UserReservationInfo.self, from: data)
            let user = try isValidUser(requestData)
            
            if let user = user {
                if user.left > .zero, let response = generateResponse(url: request.url!, code: 200) {
                    return (generateResponseString(state: .valid, user.left).data(using: .utf8)!, response)
                } else if user.left == .zero, let response = generateResponse(url: request.url!, code: 200) {
                    return (generateResponseString(state: .noLeft, user.left).data(using: .utf8)!, response)
                } else if let response = generateResponse(url: request.url!, code: 210) {
                    return (generateResponseString(state: .invalid, -1).data(using: .utf8)!, response)
                }
            }
            
            //사용자가 존재하지 않는 경우
            else if let response = generateResponse(url: request.url!, code: 210) {
                return (generateResponseString(state: .invalid, -1).data(using: .utf8)!, response)
            }
        } catch {
            throw NetworkError.decodingFailed
        }
        
        return (Data(), URLResponse())
    }
    
    private func isValidUser(_ requestUserInfo: UserReservationInfo) throws -> MockDataBase? {
        var user: MockDataBase?
        do {
            let decodedMock = try JSONDecoder().decode([MockDataBase].self, from: mockData)
            decodedMock.map({ db in
                if db.bookingNumber == requestUserInfo.bookingNumber &&
                    db.userName == requestUserInfo.name {
                    user = db
                }
            })
            return user
            
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    private func generateResponse(url: URL, code: Int) -> HTTPURLResponse? {
        let httpUrlResponse =  HTTPURLResponse(
            url: url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )
        
        return httpUrlResponse
    }
    
    enum State {
        case valid
        case invalid
        case noLeft
    }
    
    private func generateResponseString(state: State, _ left: Int) -> String {
        switch state {
        case .valid:
            let validUserRsponseString = """
                                {
                                    "isValid": true,
                                    "message": "티켓 생성 가능합니다",
                                    "left": \(left)
                                }
                                """
            return validUserRsponseString
        case .invalid:
            let inValidUserRsponseString = """
                                {
                                    "isValid": false,
                                    "message": "티켓을 확인할 수 없습니다. 예약자와 예약번호를 확인해주세요",
                                }
                                """
            return inValidUserRsponseString
        case .noLeft:
            let noLeftUserRsponseString = """
                                {
                                    "isValid": false,
                                    "message": "티켓을 모두 생성하였습니다.",
                                    "left": \(left)
                                }
                                """
            return noLeftUserRsponseString
        }
    }
    
    private func generatePassDownloadResponseString(state: State, mockUser: MockDataBase) -> String {
        switch state {
        case .valid:
            let validUserRsponseString = """
            {
                "data": "data",
                "userName": "Sheila",
                "message": "티켓 생성에 성공했습니다.",
                "left": \(mockUser.left - 1)
            }
            """
            
            return validUserRsponseString
        default:
            let unkownError = """
            {
                "data": "data",
                "userName": "Sheila",
                "message": "티켓 생성에 실패했습니다. 1:1 채널로 문의해주세요.",
                "left": \(mockUser.left)
            }
            """
            return unkownError
        }
    }
}
