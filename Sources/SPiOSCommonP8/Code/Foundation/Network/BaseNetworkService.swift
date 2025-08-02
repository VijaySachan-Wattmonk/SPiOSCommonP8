//
//  BaseNetworkService.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 29/07/25.
//

import Foundation
 enum FWNetworkConstants {
    static let contentType = "Content-Type"
    static let accept = "Accept"
    static let applicationJSON = "application/json"
    static let pleaseCallFromBackground = "Please call this method from background thread."
    static let encodingError = "Encoding Error: "
    static let invalidURL = "Invalid URL"
}
public class BaseNetworkService {
    public private(set) var commonHeaders: [String: String] = [
        FWNetworkConstants.contentType: FWNetworkConstants.applicationJSON,
        FWNetworkConstants.accept: FWNetworkConstants.applicationJSON
    ]
    
    public func setCommonHeaders(_ headers: [String: String]) {
        self.commonHeaders = headers
    }
    public func appendCommonHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            commonHeaders[key] = value
        }
    }
    func finalHeaders(adding: [String: String]?) -> [String: String] {
        return commonHeaders.merging(adding ?? [:]) { _, new in new }
    }
    
    func addPercentEncoding(value: String) -> String? {
        var allowedCharacterSet = CharacterSet.urlPathAllowed
        allowedCharacterSet.remove(charactersIn: "/+&?=#")
        return value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
    
    func appendQueryParameters(to url: URL, params: [String: Encodable]) -> URL {
        guard !params.isEmpty else { return url }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { key, value in
            let encodedValue = addPercentEncoding(value: "\(value)") ?? "\(value)"
            return URLQueryItem(name: key, value: encodedValue)
        }
        return components?.url ?? url
    }
}
struct AnyEncodable: Encodable {
    let value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
    
    
    
    
