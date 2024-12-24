//
//  MockProvider.swift
//  KWDC_Check-inTests
//
//  Created by mac on 8/28/24.
//

import Foundation
@testable import KWDC_Check_in
import OSLog

extension URLSession: UrlSessionable {
    
}

final class MockNetworkProvider: NSObject, Provider {
    var session: UrlSessionable
    
    init(session: UrlSessionable = URLSession.shared) {
        self.session = session
    }
    
    func run<T: Decodable>(_ request: URLRequest) async throws -> T {
        var responseStatusCode: Int?
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpReponse = response as? HTTPURLResponse,
                  httpReponse.statusCode < 300, httpReponse.statusCode >= 200 else {
                responseStatusCode = (response as? HTTPURLResponse)?.statusCode
                throw NetworkError.invalidServerResponse
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch {
            logError(responseStatusCode, request, error)
            throw error
        }
    }
    
}

extension MockNetworkProvider: URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge) async
    -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        return (
            .useCredential,
            URLCredential(trust: challenge.protectionSpace.serverTrust!)
        )
    }
    
    private func logError(
        _ responseStatusCode: Int?,
        _ request: URLRequest,
        _ error: Error) {
            Logger.networking.error("""
        🛑 [Error]
        \(responseStatusCode ?? 0)
        \(request.httpMethod ?? "")
        \(request, privacy: .private)
        Error Type:
        \(error.localizedDescription)
        \(error)
        """
            )
        }
}
