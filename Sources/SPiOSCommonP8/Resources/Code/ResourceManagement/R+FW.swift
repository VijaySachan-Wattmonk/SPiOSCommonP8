//
//  R.String_+FW.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 22/09/25.
//
import Foundation
import UIKit

// MARK: String
extension R.StringCatalog.FW{
        public static func common(_ key:R.StringCatalog.Common.Key)->String{
            return R.StringCatalog.Common.shared.catalog.localizedStr(key: key.rawValue, defaultValue: key.defaultValue)
        }
}
// MARK: Colour
extension R.ColorSet.FW{
    public static func common(_ key:R.ColorSet.Common.Key)->UIColor?{
        return R.ColorSet.Common.shared.colorSet.uiColor(key: key.rawValue)
    }
}
// MARK: Image
extension R.ImageSet.FW{
    public static func common(_ key:R.ImageSet.Common.Key)->UIImage?{
        return R.ImageSet.Common.shared.imageSet.uiImage(key: key.rawValue)
    }
}
