//
//  File.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 11/09/25.
//
import UIKit
extension UIApplication{
    public static var ext_MainSafeAreaInsets: UIEdgeInsets {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.safeAreaInsets ?? .zero
    }
}
