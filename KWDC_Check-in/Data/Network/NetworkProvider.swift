//
//  NetworkProvider.swift
//  KWDC_Check-in
//
//  Created by mac on 8/27/24.
//

import Foundation
import OSLog

protocol Provider {
    func run<T: Decodable>(_ request: URLRequest) async throws -> T
}


final class NetworkProvider: NSObject, Provider {
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil)
    }()
    
    init(session: URLSession? = nil) {
        super.init()
        
        if let session = session {
            self.session = session
        }
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

extension NetworkProvider: URLSessionDelegate {
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

enum NetworkError: Error {
    case invalidServerResponse
    case invalidURL
    case decodingFailed
    case uploadFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "서버에서 잘못된 응답을 반환했습니다."
        case .invalidURL:
            return "URL 문자열의 형식이 잘못되었습니다."
        case .decodingFailed:
            return "디코딩에 실패함."
        case .uploadFailed:
            return "업로드 정보에 문제가 있습니다."
        }
    }
}
