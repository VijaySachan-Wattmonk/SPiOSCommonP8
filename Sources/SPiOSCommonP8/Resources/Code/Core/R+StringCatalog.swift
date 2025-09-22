//
//  R+StringCatalog.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//

import Foundation

extension R{
    public struct StringCatalog:Sendable{
        public var table: String
        private  var bundle: Bundle
        public init(table: String,bundle: Bundle) {
            self.table = table
            self.bundle = bundle
        }
         public func localizedStr(key:String,defaultValue:String)->String{
             let value=String(localized:String.LocalizationValue(key), table: table, bundle:bundle)
             return value == key ? defaultValue : value
        }
        public struct FW{
        }
        public struct App{
        }
    }
}

