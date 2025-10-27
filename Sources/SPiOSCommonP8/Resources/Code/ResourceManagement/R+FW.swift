//
//  R+FW.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 22/09/25.
//
import Foundation
import UIKit

// MARK: String
extension R.StringCatalog.FW{
    public static func common(_ key:R.StringCatalog.FW.Common.Key)->String{
        return R.StringCatalog.FW.Common.shared.catalog.localizedStr(key: key.rawValue, defaultValue: key.defaultValue)
        }
}
// MARK: Colour
extension R.ColorSet.FW{
    public static func common(_ key:R.ColorSet.FW.Common.Key)->UIColor?{
        return R.ColorSet.FW.Common.shared.colorSet.uiColor(key: key.rawValue)
    }
}
// MARK: Image
extension R.ImageSet.FW{
    public static func common(_ key:R.ImageSet.FW.Common.Key)->UIImage?{
        return R.ImageSet.FW.Common.shared.imageSet.uiImage(key: key.rawValue)
    }
}
