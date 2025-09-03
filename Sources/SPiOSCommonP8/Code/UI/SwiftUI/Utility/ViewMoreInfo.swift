//
//  ViewMoreInfo.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 02/09/25.
//
import SwiftUI
public struct ViewInfoIconButton: View{
    @Environment(\.dismiss) private var dismiss
    @State private var showInfo: Bool=false
    let title: String
    let message: String
    let onClose: () -> Void
    let iconSize=25.0
    public var body: some View{
        Button(action:{
            showInfo=true
        }, label:{
            Image(systemName: "info.circle")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: iconSize, height: iconSize)
                .scaledToFit()
                .padding(25)/*.background(Color.red)*/
        }).modifier_ViewMoreInfo(showInfo:$showInfo, message: message, title:title,onClose:onClose)
    }
}

public struct ViewMoreInfo: View {
    @Environment(\.dismiss) private var dismiss
    let message: String
    let title: String
    // Tunables
    private let cornerRadius: CGFloat = 20
    private let panelHMargin: CGFloat = 20      // horizontal safe margin
    private let panelVMargin: CGFloat = 20      // vertical safe margin
    
     public var body: some View {
        ZStack{
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
                            dismiss()
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 25, weight: .semibold))
                                .padding(25).foregroundStyle(Color.blue)
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
    let onClose: () -> Void
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
                .sheet(isPresented: $showInfo, onDismiss: {
                    onClose()
                }){
                    ViewMoreInfo(message: message, title: title)
                }
        }
    }
}
extension View{
     func modifier_ViewMoreInfo(showInfo: Binding<Bool>, message: String, title: String,onClose: @escaping () -> Void) -> some View{
        modifier(ViewMoreInfoModifier(onClose: onClose, showInfo: showInfo, message: message, title: title))
    }
}
// MARK: - Example usage
public struct ViewMoreInfoDemo: View {
    private let sampleText = {
        Array(repeating: "This is a reusable right-corner pop-up. Pass any long text to make it scrollable.", count: 20)
            .joined(separator: "\n\n")
    }()
    public init() { }
    public var body: some View {
        ViewInfoIconButton(title: "What’s New", message: sampleText, onClose: {
            print("On Close")
        })
    }
}
#Preview{
    ViewMoreInfoDemo()
}
