//
//  AppContentView.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 30/07/25.
//
import SwiftUI
public struct AppContentView<Content: View>: View {
    @StateObject private var themeManager: FWThemeManager
    @StateObject private var viewModel: AppContentViewVM
    
    public let content: Content
    public init(@ViewBuilder content: () -> Content) {
        let themeManager: FWThemeManager=FWThemeManager()
        _themeManager=StateObject(wrappedValue: themeManager)
        _viewModel = StateObject(wrappedValue: AppContentViewVM(themeManager: themeManager))
        self.content = content()
    }
    
    
    public var body: some View {
        AppView(viewModel: viewModel){
            content
        }.environmentObject(themeManager)
        
    }
}

private class AppContentViewVM: AppViewModel {
    private let themeManager: FWThemeManager
    
    init(themeManager: FWThemeManager) {
        self.themeManager = themeManager
        super.init()
    }
    
    override func onColorSchemeChange(_ scheme: ColorScheme) {
        super.onColorSchemeChange(scheme)
        themeManager.updateColorScheme(scheme)
    }
}

//#Preview {
//    AppContentView()
//}
