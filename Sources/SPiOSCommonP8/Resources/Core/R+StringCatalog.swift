//
//  R+StringCatalog.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//

import Foundation
extension R{
    public final class StringCatalog{
        public var table: String
        private  var bundle: Bundle
        public init(table: String,bundle: Bundle) {
            self.table = table
            self.bundle = bundle
        }
         public func localizedStr(key:String)->String{
            return String(localized:String.LocalizationValue(key), table: table, bundle:bundle)
        }
        public actor FW { }
        public actor App { }
    }
}

