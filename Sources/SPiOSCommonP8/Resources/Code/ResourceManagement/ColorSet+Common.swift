//
//  R.Color_.FW.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 21/09/25.
//

import UIKit

extension R.ColorSet.FW {
//    public static let shared = Default()
    public struct Common:Sendable{
       public static let shared = Common()
         let colorSet:R.ColorSet
        private init(){
            colorSet=R.ColorSet(bundle:.module)
        }
        public enum Key: String {
            case fw_black
        }
    }
}
