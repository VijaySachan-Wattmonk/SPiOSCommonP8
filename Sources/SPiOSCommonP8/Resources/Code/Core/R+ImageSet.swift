//
//  R+ImageSet.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//
import Foundation
import UIKit
extension R{
    public struct ImageSet:Sendable{
        private  var bundle: Bundle
        public init(bundle: Bundle) {
            self.bundle = bundle
        }
        public func uiImage(key:String)->UIImage?{
            return UIImage(named: key, in: bundle, compatibleWith: nil)
        }
        public struct FW{
        }
        public struct App{
        }
    }
}

