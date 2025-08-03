//
//  Gloabl.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 4/28/25.
//
import Foundation


let N_A="N/A"
public class Global{
    
    public static let isSwiftUIPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
// MARK: Methods
extension Global{
    public static func logThreadType(function:String = #function, tag:String){
        let threadName = Thread.isMainThread ? "Main Thread":"Background Thread"
        print("logThreadType : [\(tag)] : \(function) : thread :\(threadName)")
        
    }
    
    public static func isExecutingOnMainThread() -> Bool {
        return Thread.isMainThread
    }
}
