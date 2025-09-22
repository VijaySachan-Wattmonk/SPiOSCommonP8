//
//  R+StringCatalog+Common.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 21/09/25.
//
extension R.StringCatalog.FW{
    public struct Common:Sendable{
        public static let shared = Common()
        let catalog:R.StringCatalog
        private init(){
            catalog = .init(table: "Common", bundle: .module)
        }
        public enum Key: String, CaseIterable{
            case appName
            case ok
            public var defaultValue: String{
                let defVal=N_A
                switch self{
                case .appName: return "MyApp"
                case .ok: return defVal
                    
                }
            }
        }
    }
}
