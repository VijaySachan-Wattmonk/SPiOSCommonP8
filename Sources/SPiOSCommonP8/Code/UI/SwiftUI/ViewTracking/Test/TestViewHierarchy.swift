//
//  TestViewHierarchy.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 21/07/25.
//

// MARK: - Example Views
import SwiftUI
public struct TestViewHierarchy: HierarchyAwareView {
    public let parentHierarchy: HierarchyTrackable? = nil
    public init(){}
    public var body: some View {
        AppView(self, viewModel: AppViewModel()){
            VStack {
                NavigationLink("Go to View1") {
                    View1(parentHierarchy: self)
                }
                NavigationLink("Go to View2") {
                    View2(parentHierarchy: self)
                }
            }}
//        }
        
    }
}

struct View1: HierarchyAwareView {
    let parentHierarchy: HierarchyTrackable?

    var body: some View {
        AppView(self, viewModel: AppViewModel()){VStack {
            Text("This is View1")
            NavigationLink("Go to ChildView") {
                ChildView(parentHierarchy: self)
            }
        }}
        
    }
}

struct View2: HierarchyAwareView {
    let parentHierarchy: HierarchyTrackable?

    var body: some View {
        AppView(self, viewModel: AppViewModel()){
            Text("This is View2")
        }
    }
}

struct ChildView: HierarchyAwareView {
    let parentHierarchy: HierarchyTrackable?

    var body: some View {
        AppView(self, viewModel: AppViewModel()){Text("This is ChildView")
        }
    }
}
