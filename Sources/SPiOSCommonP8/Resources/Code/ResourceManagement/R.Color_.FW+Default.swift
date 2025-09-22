//
//  R.Color_.FW.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//

import UIKit

extension R.Color_ {
//    public static let shared = Default()
    public struct Common:Sendable{
       public static let shared = Common()
         let color_:R.Color_
        private init(){
            color_=R.Color_(bundle:.module)
        }
        public func color(key:Key) -> UIColor{
            return color_.uiColor(key: key.rawValue)
        }
        public enum Key: String {
            case fw_black
        }
    }
}
