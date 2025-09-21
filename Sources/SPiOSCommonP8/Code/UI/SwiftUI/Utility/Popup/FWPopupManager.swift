import SwiftUI
// MARK: - Manager API (unchanged surface, now drives overlay window)
@MainActor
public final class FWPopupManager: ObservableObject{
    public static let shared = FWPopupManager()
    @Published public var isPresented: Bool = false
    @Published public var title: String = ""
    @Published public var description: String = ""
    @Published public var buttons: [PopupButton] = []
    @Published public var allowOutsideTapToDismiss: Bool = true
    private init() {}
    // Core presenter
    func show(title: String,
              description: String,
              allowOutsideTapToDismiss: Bool = true,
              buttons: [PopupButton]) {
        // Update state
        self.title = title
        self.description = description
        self.allowOutsideTapToDismiss = allowOutsideTapToDismiss
        self.buttons = Array(buttons.prefix(3))
        self.isPresented = true

        // Show overlay window above everything
        OverlayWindowManager.shared.show {
            GlobalPopupOverlayView(manager: self)
        }
    }

    // Convenience presenters: 1, 2, 3 buttons
    public func showOne(title: String,
                        description: String,
                        allowOutsideTapToDismiss: Bool = false,
                        _ first: PopupButton) {
        show(title: title,
             description: description,
             allowOutsideTapToDismiss: allowOutsideTapToDismiss,
             buttons: [first])
    }

    public func showTwo(title: String,
                        description: String,
                        allowOutsideTapToDismiss: Bool = false,
                        _ first: PopupButton,
                        _ second: PopupButton) {
        show(title: title,
             description: description,
             allowOutsideTapToDismiss: allowOutsideTapToDismiss,
             buttons: [first, second])
    }

    public func showThree(title: String,
                          description: String,
                          allowOutsideTapToDismiss: Bool = false,
                          _ first: PopupButton,
                          _ second: PopupButton,
                          _ third: PopupButton) {
        show(title: title,
             description: description,
             allowOutsideTapToDismiss: allowOutsideTapToDismiss,
             buttons: [first, second, third])
    }

    public func hide() {
        self.isPresented = false
        OverlayWindowManager.shared.hide()
    }

    // Optional: live updates while shown
    public func update(title: String? = nil,
                       description: String? = nil,
                       buttons: [PopupButton]? = nil,
                       allowOutsideTapToDismiss: Bool? = nil) {
        if let title { self.title = title }
        if let description { self.description = description }
        if let buttons { self.buttons = Array(buttons.prefix(3)) }
        if let allowOutsideTapToDismiss { self.allowOutsideTapToDismiss = allowOutsideTapToDismiss }

        // If overlay is visible, refresh content without flicker
        OverlayWindowManager.shared.update {
            GlobalPopupOverlayView(manager: self)
        }
    }
}
