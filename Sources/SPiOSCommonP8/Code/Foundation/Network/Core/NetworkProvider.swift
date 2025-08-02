//
//  NetworkProvider.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 28/07/25.
//
import Foundation
public enum FWHttpMethod: String,Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
public protocol NetworkProvider{
    func performRequest<T: Decodable>(
        url: URL,
        method: FWHttpMethod,
        headers: [String: String]?,
        body: Data?,
        responseType: T.Type
    ) async -> Result<T, NetworkErrorLog>
}


public struct NetworkErrorLog: Error,FWLoggerDelegate {
    let url: String
    let method: FWHttpMethod
    let headers: [String: String]?
    let body: Data?
    let responseData: Data?
    let statusCode: Int?
    let errorDescription: String?
    
    init(
        url: String,
        method: FWHttpMethod,
        headers: [String: String]?,
        body: Data?,
        responseData: Data?,
        statusCode: Int?,
        errorDescription: String?
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.responseData = responseData
        self.statusCode = statusCode
        self.errorDescription = errorDescription
    }
    
    var requestBodyString: String {
        guard let body = body else { return "nil" }
        return String(data: body, encoding: .utf8) ?? "Non-UTF8 Data"
    }
    
    var responsePreviewString: String {
        guard let data = responseData else { return "nil" }
        return String(data: data.prefix(1000), encoding: .utf8) ?? "Non-UTF8 Data"
    }
    
    var headersString: String {
        headers?.map { "\($0.key): \($0.value)" }.joined(separator: ", ") ?? "nil"
    }
    
    func log() {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        mLog(msg: "🕒 Timestamp: \(timestamp)")
        mLog(msg: "🌐 URL: \(url)")
        mLog(msg: "📤 Method: \(method.rawValue)")
        
        if let statusCode = statusCode {
            mLog(msg: "📶 Status Code: \(statusCode)")
        }
        
        mLog(msg: "🧾 Headers: \(headersString)")
        mLog(msg: "📤 Request Body: \(requestBodyString)")
        mLog(msg: "📥 Response (preview): \(responsePreviewString)")
        
        if let errorDescription = errorDescription {
            mLog(msg: "❌ Error: \(errorDescription)")
        }
        
        mLog(msg: "✅ Request completed\n------------------------------")
    }
}
