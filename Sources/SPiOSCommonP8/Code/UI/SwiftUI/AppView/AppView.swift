//
//  AppView.swift
//  iOS
//
//  Created by Vijay Sachan on 26/08/23.
//

import Foundation
import SwiftUI

/// A SwiftUI container that manages lifecycle events, logs view hierarchy,
/// and integrates with `AppViewModel` for consistent view behavior and tracking.
public struct AppView<Content: View>:View,FWLoggerDelegate{
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme

    @ViewBuilder let contentView: Content

    private var hierarchy: HierarchyTrackable?

    @ObservedObject private var viewModel: AppViewModel

    nonisolated public var tagOfThisView:String="tagOfThisView"

    nonisolated public var tag: String {
            return tagOfThisView
    }

    /// Sets up the content view and assigns the associated view model and hierarchy.
    /// Also computes the tag for tracking/logging the view’s identity.
    init(_ hierarchy: HierarchyTrackable?=nil,viewModel: AppViewModel,@ViewBuilder contentView: () -> Content) {
        self.contentView=contentView()
        self.viewModel=viewModel
        self.hierarchy=hierarchy
//        viewModel.tagVM=getTag()
        tagOfThisView=getTag()
    }

    private func getTag() -> String {
        return hierarchy?.name ?? N_A
    }

    public var body: some View {
        contentView.onAppear{
            viewModel.onAppear()
            logHierarchy()
        }
        .onDisappear{
            viewModel.onDisappear()
            
        }
        .onChange(of: scenePhase) { (phase) in
            viewModel.onChange(scenePhase: phase)
        }
        .onChange(of: colorScheme) { newScheme in
            viewModel.onColorSchemeChange(newScheme)
        }
    }

    private func logHierarchy() {
        mLog(msg: (hierarchy?.fullPath ?? N_A))
    }
}
struct MyAppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(nil, viewModel: AppViewModel()){
            Text("Hello app view")
        }
    }
}
