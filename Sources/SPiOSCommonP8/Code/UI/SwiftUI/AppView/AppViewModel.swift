//
//  AppViewModel.swift
//  iOS
//
//  Created by Vijay Sachan on 26/08/23.
//

import Foundation
import SwiftUI

@MainActor
public class AppViewModel: ObservableObject, FWLoggerDelegate {
    private var isWorking = false
    public let tag:String
    init(){
        self.tag = "\(Self.self)"
    }
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active: active()
        case .background: background()
        case .inactive: inactive()
        @unknown default: mLog(msg: "ScenePhase: unexpected state")
        }
    }
    
    private func startWork() {
        guard !isWorking else { return }
        isWorking = true; mLog(msg: "startWork"); onStartWork()
    }
    
    private func endWork() {
        guard isWorking else { return }
        isWorking = false; mLog(msg: "endWork"); onEndWork()
    }
    
    
    private func performLifecycleEvent(_ eventName: String, action: (() -> Void)? = nil) {
        mLog(msg: eventName)
        action?()
    }
    
    //}
    
    // MARK: - Overridable Hooks
    //extension AppViewModel {
    public func onAppear() {
        performLifecycleEvent("onAppear") { self.startWork() }
    }
    
    public func onDisappear() {
        performLifecycleEvent("onDisappear") { self.endWork() }
    }
    
    public func active() {
        performLifecycleEvent("active") { self.startWork() }
    }
    
    public func background() {
        performLifecycleEvent("background") { self.endWork() }
    }
    
    public func inactive() {
        performLifecycleEvent("inactive")
    }
    public func onStartWork() {
        // Override in subclass for custom start logic
    }
    
    public func onEndWork() {
        // Override in subclass for custom end logic
    }
    
    public func onColorSchemeChange(_ scheme: ColorScheme) {
        mLog(msg: "ColorScheme changed to: \(scheme == .dark ? "Dark" : "Light")")
        // You can override this in subclass for theme-specific logic
    }
    
    
    private func todo() {
        let _="""
            1. Add method onDismiss which will be invoked, When View is dismissed manually or sliding right
            """
    }
}
