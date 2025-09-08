//
//  FWPopupManager.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 08/09/25.
//
import Foundation
@MainActor
public final class FWPopupManager: ObservableObject {
    static let shared = FWPopupManager()
    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var buttons: [PopupButton] = []
    @Published var allowOutsideTapToDismiss: Bool = true

    private init() {}

    // Core presenter
    func show(title: String, description: String, allowOutsideTapToDismiss: Bool = true, buttons: [PopupButton]) {
        DispatchQueue.main.async {
            self.title = title
            self.description = description
            self.allowOutsideTapToDismiss = allowOutsideTapToDismiss
            self.buttons = Array(buttons.prefix(3))
            self.isPresented = true
        }
    }

    // Convenience presenters: 1, 2, 3 buttons
    func showOne(title: String, description: String, allowOutsideTapToDismiss: Bool = false, _ first: PopupButton) {
        show(title: title, description: description, allowOutsideTapToDismiss: allowOutsideTapToDismiss, buttons: [first])
    }

    func showTwo(title: String, description: String, allowOutsideTapToDismiss: Bool = false, _ first: PopupButton, _ second: PopupButton) {
        show(title: title, description: description, allowOutsideTapToDismiss: allowOutsideTapToDismiss, buttons: [first, second])
    }

    func showThree(title: String, description: String, allowOutsideTapToDismiss: Bool = false, _ first: PopupButton, _ second: PopupButton, _ third: PopupButton) {
        show(title: title, description: description, allowOutsideTapToDismiss: allowOutsideTapToDismiss, buttons: [first, second, third])
    }

    func hide() {
        DispatchQueue.main.async {
            self.isPresented = false
        }
    }
}
