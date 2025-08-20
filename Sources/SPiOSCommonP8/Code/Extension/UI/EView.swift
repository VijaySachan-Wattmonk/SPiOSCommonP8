//
//  EView.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 20/08/25.
//

import SwiftUICore

extension View {
    @ViewBuilder public func ex_If<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
