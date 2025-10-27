//
//  R.Color_.FW.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 21/09/25.
//

import UIKit

extension R.ImageSet.FW {
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
