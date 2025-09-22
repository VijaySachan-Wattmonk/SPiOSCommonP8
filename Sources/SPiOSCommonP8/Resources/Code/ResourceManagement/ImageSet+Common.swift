//
//  R.Color_.FW.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//

import UIKit

extension R.ImageSet {
    public struct Common:Sendable{
       public static let shared = Common()
         let imageSet:R.ImageSet
        private init(){
            imageSet=R.ImageSet(bundle:.module)
        }
        public enum Key: String {
            case sample
        }
    }
}
