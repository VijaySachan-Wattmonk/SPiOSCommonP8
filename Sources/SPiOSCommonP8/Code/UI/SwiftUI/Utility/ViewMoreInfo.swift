//
//  ViewMoreInfo.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 02/09/25.
//

import SwiftUI
/// A reusable panel that appears like a full-screen pop-up from the **right corner**.
/// - Features:
///   - Slide-in from the trailing edge (right) with fade.
///   - Close button in the top-right of the panel.
///   - Scrollable text content passed as a `String`.
///   - Works on iPhone and iPad (sizes itself with safe margins).
public struct ViewMoreInfo: View {
    let message: String
    let title: String
    let onClose: () -> Void
    
    // Tunables
    private let cornerRadius: CGFloat = 20
    private let panelHMargin: CGFloat = 12      // horizontal safe margin
    private let panelVMargin: CGFloat = 12      // vertical safe margin
    
    public var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
//            Color.black.opacity(0.25)
//                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
                HStack(alignment: .center) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 25, weight: .semibold))
                            .padding(25).foregroundStyle(Color.blue)
//                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }
                .padding(16)
                Divider()
                // Scrollable text content
                ScrollView{
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.background(Color.white)
            

        }
//            .cornerRadius(cornerRadius)
            .padding(.horizontal, panelHMargin)
            .padding(.vertical, panelVMargin)
    }
}
//
//
//struct InfoFullScreenCover: View {
//    @Environment(\.dismiss) private var dismiss
//    let message: String
//    let title: String
//
//    var body: some View {
//        ZStack {
//            // Dimmed backdrop that dismisses on tap
//            Color.black.opacity(0.28)
//                .ignoresSafeArea()
//                .onTapGesture { dismiss() }
//
//            // The right-corner panel; its close button also dismisses
//            ViewMoreInfo(message: message, title: title) {
//                dismiss()
//            }
//        }
//    }
//}

// MARK: - Example usage
public struct ViewMoreInfoDemo: View {
    @State private var showInfo = false
    private let sampleText = {
        Array(repeating: "This is a reusable right-corner pop-up. Pass any long text to make it scrollable.", count: 20)
            .joined(separator: "\n\n")
    }()
public init() {}
    public var body: some View {
        VStack(spacing: 16) {
            Button("Show Info") {
                self.showInfo.toggle()
            }
        }
        .fullScreenCover(isPresented: $showInfo) {
            ViewMoreInfo(message: sampleText, title: "What’s New") {
               
            }
        }
    }
}
#Preview{
    ViewMoreInfoDemo()
}
