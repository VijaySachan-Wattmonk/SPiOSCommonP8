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
private struct ViewMoreInfo: View {
    @Environment(\.dismiss) private var dismiss
    let message: String
    let title: String
    let onClose: () -> Void
    
    // Tunables
    private let cornerRadius: CGFloat = 20
    private let panelHMargin: CGFloat = 20      // horizontal safe margin
    private let panelVMargin: CGFloat = 20      // vertical safe margin
    
     var body: some View {
        ZStack{
//            Color.red.ignoresSafeArea()
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
            ZStack{
                VStack(spacing: 0){
                    // Header
                    HStack(alignment: .center) {
                        Text(title)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Button(action:{
                            onClose()
                            dismiss()
                        }){
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
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding()
            }
          .background(Color.white)
//          .cornerRadius(cornerRadius)
//                .padding(.horizontal, panelHMargin)
//                .padding(.vertical, panelVMargin)
                
            
            
        }
        
    }
}
private struct ViewMoreInfoModifier: ViewModifier {
    
    @Binding var showInfo: Bool
    var message: String
    var title: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
//                .fullScreenCover(isPresented: $showInfo) {
//                    ViewMoreInfo(message: message, title: title) {
//                        
//                    }
//                }
                .sheet(isPresented: $showInfo, onDismiss: {}){
                    ViewMoreInfo(message: message, title: title) {
                    
                                        }
                }
        }
    }
}
extension View {
    public func modifier_ViewMoreInfo(showInfo: Binding<Bool>, message: String, title: String) -> some View {
        modifier(ViewMoreInfoModifier(showInfo: showInfo, message: message, title: title))
    }
}

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
        }.modifier_ViewMoreInfo(showInfo:$showInfo, message: sampleText, title:"What’s New")
    }
}
#Preview{
    ViewMoreInfoDemo()
}
