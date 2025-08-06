//
//  FWError.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 5/5/25.
//
import Foundation
public struct FWError: LocalizedError {
    let message: String
    public init(message: String) {
        self.message = message
    }
    public var errorDescription: String? {
        return message
    }
}
