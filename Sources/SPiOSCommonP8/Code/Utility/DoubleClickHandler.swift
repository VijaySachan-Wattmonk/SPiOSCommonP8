//
//  DoubleClickHandler.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 14/10/25.
//
import Foundation
@MainActor
public final class DoubleClickHandler {
    public static let shared=DoubleClickHandler()
    private init(){}
    /// Maximum time interval between two clicks to be considered a double click.
    let minDelay: TimeInterval=0.75
    private var isExecuting=false
    
    public func handleClick(_ closure: @escaping () -> Void){
        DispatchQueue.main.async {
            if !self.isExecuting{
                self.isExecuting=true
                closure()
                DispatchQueue.main.asyncAfter(deadline: .now() + self.minDelay) {
                    self.isExecuting=false
                }
            }
        }
        
    }

    
}
