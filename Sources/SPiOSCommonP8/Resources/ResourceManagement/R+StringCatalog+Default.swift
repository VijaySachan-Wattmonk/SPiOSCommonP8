//
//  R+StringCatalog+Default.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//
extension R.StringCatalog.FW{
        public actor Default{
            public static let shared = Default()
            public let catalog:R.StringCatalog
            private init(){
                catalog = .init(table: "Localizable", bundle: .module)
            }
            public func localized(key:Key)->String{
                return catalog.localizedStr(key: key.rawValue)
           }
            public enum Key: String, CaseIterable {
                case appName
            }
        }
    }


