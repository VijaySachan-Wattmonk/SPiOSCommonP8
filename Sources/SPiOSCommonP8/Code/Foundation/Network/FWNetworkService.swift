//
//  FWNetworkService.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 28/07/25.
//

import Foundation

public final class FWNetworkService: BaseNetworkService,FWLoggerDelegate{
    private let provider: NetworkProvider
    public init(provider: NetworkProvider){
        self.provider = provider
    }
    public func requestWithQuery<T: Decodable>(
        method: FWHttpMethod,
        url: String,
        params: [String: Encodable] = [:],
        additionalHeaders: [String: String]? = nil,
        responseType: T.Type
    ) async -> Result<T, NetworkErrorLog> {
        Global.logThreadType(tag: tag)
        if Global.isExecutingOnMainThread(){
            fatalError(FWNetworkConstants.pleaseCallFromBackground)
        }
        
        let mergedHeaders = finalHeaders(adding: additionalHeaders)
        guard let requestURL = URL(string: url) else {
            return .failure(NetworkErrorLog(url: url, method: method, headers: mergedHeaders, body: nil, responseData: nil, statusCode: nil, errorDescription: FWNetworkConstants.invalidURL))
        }
        let finalURL = appendQueryParameters(to: requestURL, params: params)

        return await provider.performRequest(
            url: finalURL,
            method: method,
            headers: mergedHeaders,
            body: nil,
            responseType: responseType
        )
    }
    public func requestWithJSONBody<T: Decodable>(
        method: FWHttpMethod,
        url: String,
        body: Encodable,
        additionalHeaders: [String: String]? = nil,
        responseType: T.Type
    ) async -> Result<T, NetworkErrorLog> {
        Global.logThreadType(tag: tag)
        if Global.isExecutingOnMainThread(){
            fatalError(FWNetworkConstants.pleaseCallFromBackground)
        }

        let mergedHeaders = finalHeaders(adding: additionalHeaders)
        guard let requestURL = URL(string: url) else {
            return .failure(NetworkErrorLog(
                url: url,
                method: method,
                headers: mergedHeaders,
                body: nil,
                responseData: nil,
                statusCode: nil,
                errorDescription: FWNetworkConstants.invalidURL
            ))
        }
        let encodedBody: Data
        do {
            encodedBody = try JSONEncoder().encode(AnyEncodable(body))
        } catch {
            return .failure(NetworkErrorLog(
                url: requestURL.absoluteString,
                method: method,
                headers: mergedHeaders,
                body: nil,
                responseData: nil,
                statusCode: nil,
                errorDescription: FWNetworkConstants.encodingError + error.localizedDescription
            ))
        }
        
        return await provider.performRequest(
            url: requestURL,
            method: method,
            headers: mergedHeaders,
            body: encodedBody,
            responseType: responseType
        )
    }
}
