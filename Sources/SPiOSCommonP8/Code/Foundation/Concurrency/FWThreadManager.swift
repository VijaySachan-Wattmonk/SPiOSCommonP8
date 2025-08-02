//
//  FWThreadManager..swift
//  SPiOSCommonP8
//
//  Created by Vijay Sachan on 22/07/25.
//

import Foundation
public final class FWThreadManager:Sendable{
    private init(){}
    public static let shared=FWThreadManager()
    public let lockQueue=DispatchQueue(label: "FWThreadManager.lockQueue")
    private let serialQueue = DispatchQueue(label: "FWThreadManager.queue.serial")

    public func executeSequentially(_ task: @Sendable @escaping () -> Void) {
        serialQueue.async {
            task()
        }
    }
}
