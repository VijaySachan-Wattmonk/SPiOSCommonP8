//
//  FWLoggerDelegate.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 4/25/25.
//

public protocol FWLoggerDelegate{
    var tag:String { get}
    func mLog(_ funcName:String,msg:String)
}
extension FWLoggerDelegate{
    public var tag:String { "\(Self.self)" }
    public func mLog(_ funcName:String=#function,msg:String){
        let tag:String = self.tag
        FWLogger.shared.info(tag:tag,message: funcName+" :: "+msg)
    }
}
