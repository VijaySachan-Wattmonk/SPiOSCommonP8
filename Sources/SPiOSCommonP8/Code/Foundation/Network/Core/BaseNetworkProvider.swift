//
//  BaseNetworkProvider.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 29/07/25.
//

import Foundation


open class BaseNetworkProvider:NetworkProvider {
    public func performRequest<T>(url: URL, method: FWHttpMethod, headers: [String : String]?, body: Data?, responseType: T.Type) async -> Result<T, NetworkErrorLog> where T : Decodable {
        fatalError("Must override")
    }
    
    
    public required init(configuration: URLSessionConfiguration) {
       
    }

    public required init() {
        
    }
    static func defaultConfiguration() -> URLSessionConfiguration {
        let copy = URLSessionConfiguration.default
        return copy
    }
}
