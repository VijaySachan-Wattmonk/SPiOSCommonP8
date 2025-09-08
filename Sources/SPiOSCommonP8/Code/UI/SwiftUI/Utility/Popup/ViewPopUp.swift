//
//  ViewPopUp.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 08/09/25.
//

import SwiftUI

struct PopupButton: Identifiable {
    let id = UUID()
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?
    
    init(_ title: String, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.role = role
        self.action = action
    }
}
struct ViewPopUp: View {
    @Binding var isPresented: Bool
    let title: String
    let description: String
    let allowOutsideTapToDismiss: Bool
    let buttons: [PopupButton]

    init(isPresented: Binding<Bool>, title: String, description: String, allowOutsideTapToDismiss: Bool = true, buttons: [PopupButton] = []) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.allowOutsideTapToDismiss = allowOutsideTapToDismiss
        self.buttons = Array(buttons.prefix(3))
    }

    init(isPresented: Binding<Bool>, title: String, description: String, allowOutsideTapToDismiss: Bool = true, _ buttons: PopupButton...) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.allowOutsideTapToDismiss = allowOutsideTapToDismiss
        self.buttons = Array(buttons.prefix(3))
    }
    
    var body: some View {
        if isPresented {
            ZStack {
                // Dim background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if allowOutsideTapToDismiss { isPresented = false }
                    }
                
                // Card
                VStack(alignment: .center, spacing: 16) {
                    // Title
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Description
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    // Buttons (optional, up to 3) — native alert-like layout
                    if !buttons.isEmpty {
                        let clipped = Array(buttons.prefix(3))
                        VStack(spacing: 0) {
                            Divider()
                            if clipped.count == 2 {
                                HStack(spacing: 0) {
                                    ForEach(Array(clipped.enumerated()), id: \.element.id) { index, btn in
                                        Button(role: btn.role) {
                                            btn.action?()
                                            isPresented = false
                                        } label: {
                                            Text(btn.title)
                                                .fontWeight(btn.role == .cancel ? .regular : .semibold)
                                                .frame(maxWidth: .infinity, minHeight: 44)
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(btn.role == .destructive ? .red : .accentColor)

                                        if index == 0 {
                                            Divider()
                                                .frame(height: 44)
                                        }
                                    }
                                }
                            } else {
                                ForEach(Array(clipped.enumerated()), id: \.element.id) { index, btn in
                                    Button(role: btn.role) {
                                        btn.action?()
                                        isPresented = false
                                    } label: {
                                        Text(btn.title)
                                            .fontWeight(btn.role == .cancel ? .regular : .semibold)
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundStyle(btn.role == .destructive ? .red : .accentColor)

                                    if index < clipped.count - 1 { Divider() }
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 270)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: 20)
                .padding(.horizontal, 24)
            }
            .transition(.opacity.combined(with: .scale))
            .animation(.easeInOut(duration: 0.2), value: isPresented)
        }
    }
}

struct PopupHostModifier: ViewModifier {
    @StateObject private var manager = FWPopupManager.shared
    func body(content: Content) -> some View {
        ZStack {
            content
            ViewPopUp(
                isPresented: $manager.isPresented,
                title: manager.title,
                description: manager.description,
                allowOutsideTapToDismiss: manager.allowOutsideTapToDismiss,
                buttons: manager.buttons
            )
        }
    }
}

extension View {
    /// Attach once at the app root (e.g., ContentView) to enable global popup control via `PopupManager.shared`.
   public func modifier_ViewPopUp() -> some View { modifier(PopupHostModifier()) }
}

#Preview {
    struct DemoHost: View {
        @StateObject private var manager = FWPopupManager.shared
        var body: some View {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                VStack(spacing: 16) {
                    Button("Show 1-button (no outside dismiss)") {
                        FWPopupManager.shared.showOne(
                            title: "Heads up",
                            description: "This is a global popup managed by PopupManager.",
                            PopupButton("OK", role: .cancel, action: {})
                        )
                    }
                    Button("Show 2-buttons (no outside dismiss)") {
                        FWPopupManager.shared.showTwo(
                            title: "Replace file?",
                            description: "A file with the same name exists.",
                            allowOutsideTapToDismiss: false,
                            PopupButton("Cancel", role: .cancel, action: {}),
                            PopupButton("Replace", role: .destructive, action: {})
                        )
                    }
                    Button("Show 3-buttons (no outside dismiss)") {
                        FWPopupManager.shared.showThree(
                            title: "Choose option",
                            description: "Pick one of the actions below.",
                            PopupButton("One", action: {}),
                            PopupButton("Two", action: {}),
                            PopupButton("Three", action: {})
                        )
                    }
                }
            }
            .modifier_ViewPopUp()
        }
    }
    return DemoHost()
}
