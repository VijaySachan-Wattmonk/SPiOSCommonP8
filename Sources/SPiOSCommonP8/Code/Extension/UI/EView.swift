//
//  EView.swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 20/08/25.
//

import SwiftUI

extension View {
    @ViewBuilder public func ext_If<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
