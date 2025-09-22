//
//  R.String_+FW.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 22/09/25.
//

extension R.Str.FW{
        public static func common(_ key:R.StringCatalog.Common.Key)->String{
            return R.StringCatalog.Common.shared.catalog.localizedStr(key: key.rawValue, defaultValue: key.defaultValue)
        }
    
    
}
