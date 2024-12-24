//
//  TicketRepository.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation

final class TicketRepository {
    private let provider = NetworkProvider()

    func checkUserValidity(name: String, bookingNumber: Int) async -> Result<UserValidity, UserError> {
        do {
            let user = UserReservationInfo(name: name, 
                                           bookingNumber: bookingNumber)
            let request = try TicketAPI.checkUserValidity(resevationInfo: user).asURLRequest()
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
    
    func generateWalletPass(name: String, bookingNumber: Int) async -> Result<TicketDownloadResult, UserError> {
        do {
            let user = UserReservationInfo(name: name,
                                           bookingNumber: bookingNumber)
            let request = try TicketAPI.requestWalletPass(resevationInfo: user).asURLRequest()
            let result: TicketDownloadResult = try await provider.run(request)
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
