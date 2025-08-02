//
//  ViewHierarchy.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 18/07/25.
//

import SwiftUI

// MARK: - Protocol
@MainActor
public protocol HierarchyTrackable {
    var parentHierarchy: HierarchyTrackable? { get }
     var name: String { get }
}

extension HierarchyTrackable {
    var fullPath: String {
        (parentHierarchy?.fullPath).map { "\($0) > \(name)" } ?? name
    }
}


// MARK: - Common View Protocol
public protocol HierarchyAwareView: View, HierarchyTrackable {}
extension HierarchyAwareView {
    public var name: String { "\(Self.self)" }
}


//// MARK: - View Modifier
//struct HierarchyLogger: ViewModifier,FWLoggerDelegate {
//    let hierarchy: HierarchyTrackable
//
//    func body(content: Content) -> some View {
//        content.onAppear {
//            mLog(msg:hierarchy.fullPath)
//        }
//    }
//}
//
//extension View {
//    public func logHierarchyPath(_ hierarchy: HierarchyTrackable) -> some View {
//        modifier(HierarchyLogger(hierarchy: hierarchy))
//    }
//}
