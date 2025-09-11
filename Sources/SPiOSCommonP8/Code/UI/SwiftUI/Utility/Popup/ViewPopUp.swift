//
//  GlobalPopup.swift
//  YourModule
//
//  Created by You on 09/09/2025.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Popup Button Model

public struct PopupButton: Identifiable {
    public let id = UUID()
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?

    public init(_ title: String, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.role = role
        self.action = action
    }
}

// MARK: - Overlay Window Manager (ALWAYS ON TOP)

/// Owns a topmost UIWindow that hosts SwiftUI content above sheets/fullScreenCover.
@MainActor
final class OverlayWindowManager {
    static let shared = OverlayWindowManager()

    private var window: UIWindow?
    private var host: UIHostingController<AnyView>?
    private var isVisible = false

    private init() {}

    func show<Content: View>(
        ignoresSafeArea: Bool = true,
        animated: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        guard let scene = Self.activeForegroundWindowScene() else { return }

        let window = UIWindow(windowScene: scene)
        window.windowLevel = .alert + 1          // 👈 Above everything
        window.backgroundColor = .clear

        let root = AnyView(
            Group {
                if ignoresSafeArea {
                    content().ignoresSafeArea()
                } else {
                    content()
                }
            }
        )

        let host = UIHostingController(rootView: root)
        host.view.backgroundColor = .clear

        window.rootViewController = host
        window.isHidden = false
        window.isOpaque = false
        window.alpha = 0

        self.window = window
        self.host = host
        self.isVisible = true

        if animated {
            UIView.animate(withDuration: 0.2) { window.alpha = 1 }
        } else {
            window.alpha = 1
        }
    }

    func update<Content: View>(@ViewBuilder content: () -> Content) {
        guard isVisible, let host = host else { return }
        host.rootView = AnyView(content())
    }

    func hide(animated: Bool = true) {
        guard let window = window else { return }
        let dispose = { [weak self] in
            guard let self else { return }
            self.window?.isHidden = true
            self.window?.rootViewController = nil
            self.host = nil
            self.window = nil
            self.isVisible = false
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: { window.alpha = 0 }) { _ in dispose() }
        } else {
            dispose()
        }
    }

    private static func activeForegroundWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}
// MARK: - SwiftUI Popup Content (matches your old ViewPopUp styling)
 struct GlobalPopupOverlayView: View {
     @ObservedObject var manager: FWPopupManager
     @State private var animateIn: Bool = true   // for internal scale/opacity
     private let padding=20.0
     private let safeAreaInsets = UIApplication.ext_MainSafeAreaInsets
    var body: some View{
        GeometryReader { geo in
        ZStack {
            // Dim background (tap to dismiss if allowed)
            Color.black.opacity(0.4).ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    if manager.allowOutsideTapToDismiss {
                        manager.hide()
                    }
                }
            
                // Card
                VStack(alignment: .center, spacing: 16) {
                    // Title
                    Text(manager.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: .infinity, alignment: .center)
                    // Description
                    ScrollView {
                        Text(manager.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                        
                    }
                    // Buttons (up to 3) — same layout rules as your original
                    if !manager.buttons.isEmpty {
                        let clipped = Array(manager.buttons.prefix(3))
                        VStack(spacing: 0) {
                            Divider()
                            if clipped.count == 2 {
                                HStack(spacing: 0) {
                                    ForEach(Array(clipped.enumerated()), id: \.element.id) { index, btn in
                                        Button(role: btn.role) {
                                            btn.action?()
                                            manager.hide()
                                        } label: {
                                            Text(btn.title)
                                                .fontWeight(btn.role == .cancel ? .regular : .semibold)
                                                .frame(maxWidth: .infinity, minHeight: 44)
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(btn.role == .destructive ? .red : .accentColor)
                                        
                                        if index == 0 {
                                            Divider().frame(height: 44)
                                        }
                                    }
                                }
                            } else {
                                ForEach(Array(clipped.enumerated()), id: \.element.id) { index, btn in
                                    Button(role: btn.role) {
                                        btn.action?()
                                        manager.hide()
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
                .padding(padding)
//                .fixedSize(horizontal: false, vertical:true)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: 20)
                .scaleEffect(animateIn ? 1.0 : 0.9)              // mimic .transition(.scale)
                .opacity(animateIn ? 1.0 : 0.0)                  // mimic .transition(.opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.2)) { 
                        animateIn = true
                    }
                    print("onAppear width=\(geo.size.width), height=\(geo.size.height) leading=\(safeAreaInsets.left), trailing=\(safeAreaInsets.right), top=\(safeAreaInsets.top), bottom=\(safeAreaInsets.bottom)")
                    let screenWidth  = UIScreen.main.bounds.width
                    let screenHeight = UIScreen.main.bounds.height
                    print("screenWidth: \(screenWidth), screenHeight: \(screenHeight)")
                }.frame(maxWidth:geo.size.width-safeAreaInsets.left-safeAreaInsets.right-padding*2,maxHeight: geo.size.height-safeAreaInsets.top-safeAreaInsets.bottom-padding*2)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: manager.isPresented)
    }
}


/*
 USAGE:

 // 1) Show a single-button popup
 FWPopupManager.shared.showOne(
     title: "Heads up",
     description: "This is a global overlay popup.",
     PopupButton("OK", role: .cancel) {
         print("OK tapped")
     }
 )

 // 2) Show two buttons
 FWPopupManager.shared.showTwo(
     title: "Replace file?",
     description: "A file with the same name exists.",
     allowOutsideTapToDismiss: false,
     PopupButton("Cancel", role: .cancel) {
         FWPopupManager.shared.hide()
     },
     PopupButton("Replace", role: .destructive) {
         // your action…
         FWPopupManager.shared.hide()
     }
 )

 // 3) Update while visible (optional)
 FWPopupManager.shared.update(description: "Please wait…")

 // 4) Hide
 FWPopupManager.shared.hide()

 NOTES:
 - No need to attach any view modifier at your root.
 - The overlay is presented in a dedicated UIWindow at `.alert + 1` level,
   so it appears above sheets and fullScreenCover.
*/
import SwiftUI

public struct GlobalPopupDemoView: View {
    public init(){}
    public var body: some View {
        NavigationView {
            List {
                Section("Quick demos") {
                    Button("Show 1-button popup") {
                        FWPopupManager.shared.showOne(
                            title: "Heads up",
                            description: "Content goes here. " + String(repeating: "More content ", count: 300)+"-----",
                            PopupButton("OK", role: .cancel) {
                                print("OK tapped")
                            }
                        )
                    }
                    Button("Show 2-button popup (no outside dismiss)") {
                        FWPopupManager.shared.showTwo(
                            title: "Replace file?",
                            description: "A file with the same name exists.",
                            allowOutsideTapToDismiss: false,
                            PopupButton("Cancel", role: .cancel) {
                                FWPopupManager.shared.hide()
                            },
                            PopupButton("Replace", role: .destructive) {
                                print("Replace tapped")
                                FWPopupManager.shared.hide()
                            }
                        )
                    }

                    Button("Show 3-button popup") {
                        FWPopupManager.shared.showThree(
                            title: "Choose option",
                            description: "Pick one of the actions below."+String(repeating: "More content ", count: 300),
                            PopupButton("One") { print("One") },
                            PopupButton("Two") { print("Two") },
                            PopupButton("Three") { print("Three") }
                        )
                    }
                }

                Section("Update while visible") {
                    Button("Show ‘Working…’ then update to ‘Done’") {
                        FWPopupManager.shared.showOne(
                            title: "Working…",
                            description: "Please wait while we process your request.",
                            PopupButton("Cancel", role: .cancel) {
                                FWPopupManager.shared.hide()
                            }
                        )

                        // Simulate async work and update the same popup
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1s
                            FWPopupManager.shared.update(
                                title: "Almost there…",
                                description: "Finalizing the operation."
                            )
                            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s
                            FWPopupManager.shared.update(
                                title: "Done 🎉",
                                description: "Operation completed successfully.",
                                buttons: [
                                    PopupButton("Close", role: .cancel) {
                                        FWPopupManager.shared.hide()
                                    }
                                ]
                            )
                        }
                    }
                }

                Section("Dismiss") {
                    Button("Hide popup") {
                        FWPopupManager.shared.hide()
                    }
                }
            }
            .navigationTitle("Global Popup Demo")
        }
    }
}

#Preview {
    GlobalPopupDemoView()
}
