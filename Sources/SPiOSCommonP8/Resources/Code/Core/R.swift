//
//  R.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 19/09/25.
//

import Foundation
public struct R{
   public struct FW{
       public static func strCommon(key:R.StringCatalog.Common.Key) -> String {
           return R.StringCatalog.Common.shared.catalog.localizedStr(key: key.rawValue, defaultValue: key.defaultValue)
       }
       
    }
}

