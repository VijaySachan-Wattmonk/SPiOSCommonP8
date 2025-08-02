//
//  File.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 28/07/25.
//

import Foundation
final public class URLSessionNetworkProvider: BaseNetworkProvider, FWLoggerDelegate {
    private let session: URLSession
    
    public required init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
        super.init(configuration: configuration)
    }
    
    public required init() {
        self.session = URLSession(configuration: BaseNetworkProvider.defaultConfiguration())
        super .init()
    }
    public override func performRequest<T: Decodable>(
        url: URL,
        method: FWHttpMethod,
        headers: [String: String]?,
        body: Data?,
        responseType: T.Type
    ) async -> Result<T, NetworkErrorLog> {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        var responseData: Data? = nil
        var statusCode: Int? = nil
        var errorDescription: String? = nil
        defer {
            let log = NetworkErrorLog(
                url: url.absoluteString,
                method: method,
                headers: headers,
                body: body,
                responseData: responseData,
                statusCode: statusCode,
                errorDescription: errorDescription
            )
            log.log()
        }
        do {
            let (data, response) = try await session.data(for: request)
            responseData = data
            statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw FWError(message: "HTTP status code not in 200..<300 range")
            }
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            errorDescription = error.localizedDescription
            return .failure(NetworkErrorLog(
                url: url.absoluteString,
                method: method,
                headers: headers,
                body: body,
                responseData: responseData,
                statusCode: statusCode,
                errorDescription: error.localizedDescription
            ))
        }
    }
    
}
