//
//  MockRepository.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/27/24.
//

import Foundation
@testable import KWDC_Check_in
import Alamofire

final class MockRepository {
    private let provider = MockNetworkProvider(session: MockUrlSession())
    
    func checkUserValidity(name: String, bookingNumber: Int) async -> Result<UserValidity, UserError> {
        do {
            let user = UserReservationInfo(name: name, bookingNumber: bookingNumber)
            let request = try MockAPI.checkUserValidity(resevationInfo: user).asURLRequest()
            let result: UserValidity = try await provider.run(request)
            return .success(result)
            
        } catch(let error) {
            switch error {
            case let error as NetworkError:
                if error == .invalidServerResponse {
                    return .failure(.networkError)
                } else if error == .decodingFailed {
                    return .failure(.decodingError)
                }
                return .failure(.unknowned)
            case let error as UserError:
                return .failure(error)
            default:
                return .failure(.unknowned)
            }
        }
    }
    
    func downloadPass(name: String, bookingNumber: Int) async -> Result<TicketDownloadMockResponse, UserError> {
        do {
            let user = UserReservationInfo(name: name, bookingNumber: bookingNumber)
            let request = try MockAPI.requestWalletPass(resevationInfo: user).asURLRequest()
            let result: TicketDownloadMockResponse = try await provider.run(request)
            return .success(result)
            
        } catch(let error) {
            switch error {
            case let error as NetworkError:
                if error == .invalidServerResponse {
                    return .failure(.networkError)
                } else if error == .decodingFailed {
                    return .failure(.decodingError)
                }
                return .failure(.unknowned)
            case let error as UserError:
                return .failure(error)
            default:
                return .failure(.unknowned)
            }
        }
    }
}
