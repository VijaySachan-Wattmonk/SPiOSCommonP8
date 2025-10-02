//
//  FWNavigationManager.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 02/10/25.
//
import Foundation
import SwiftUI
// NavigationRouter removed in favor of generic NavigationManager<Route>
// MARK: - NavigationManager for generic navigation handling
public class FWNavigationManager: ObservableObject,FWLoggerDelegate {
    @Published public var path = NavigationPath()
    // Maintain a typed mirror of the navigation stack for value-based operations like popTo.
    private var routesId: [Int] = []
    public func push<T: Hashable & Codable>(id: Int, _ route: T) {
          routesId.append(id)
          path.append(route)
        self.mLog(msg: "Pushed:\(id) , RoutesId: \(routesId.count), Path: \(path.count)")
      }
    public func pop(_ count: Int = 1) {
        self.mLog(msg: "pop(requested: \(count))")
        guard count > 0 else {
            self.mLog(msg: "pop: no-op because count <= 0")
            return
        }
        let n = min(count, routesId.count)
        guard n > 0 else {
            self.mLog(msg: "pop: no-op because stack is empty")
            return
        }
        self.mLog(msg: "pop: will remove last \(n) item(s). Before -> routesId: \(routesId), pathCount: \(path.count)")
        routesId.removeLast(n)
        path.removeLast(n)
        self.mLog(msg: "pop: removed \(n) item(s). After -> routesIdCount: \(routesId.count), pathCount: \(path.count)")
    }
    
    public func popToRoot() {
        self.mLog(msg: "popToRoot() called. Before -> routesId: \(routesId), pathCount: \(path.count)")
        guard !routesId.isEmpty || path.count > 0 else {
            self.mLog(msg: "popToRoot: no-op, already at root")
            return
        }
        routesId.removeAll()
        path.removeLast(path.count)
        self.mLog(msg: "popToRoot: After -> routesIdCount: \(routesId.count), pathCount: \(path.count)")
    }
    
    
    @discardableResult
    public func popTo(id: Int) -> Bool {
        self.mLog(msg: "popTo(id: \(id)) called. Current routesId: \(routesId)")
        guard let idx = routesId.lastIndex(where: { $0 == id }) else {
            self.mLog(msg: "popTo: id \(id) not found in stack")
            return false
        }
        let popCount = routesId.count - idx - 1
        guard popCount > 0 else {
            self.mLog(msg: "popTo: id \(id) is already at the top. No pop needed.")
            return false
        }
        self.mLog(msg: "popTo: will pop \(popCount) item(s) to reach id \(id)")
        pop(popCount)
        self.mLog(msg: "popTo: success. Now routesId: \(routesId), pathCount: \(path.count)")
        return true
    }
    
    public func replaceStack<T: Hashable & Codable>(with newRoutes: [(Int, T)]) {
        self.mLog(msg: "replaceStack() called. Before -> routesId: \(routesId), pathCount: \(path.count)")
        self.routesId = newRoutes.map { $0.0 }
        var newPath = NavigationPath()
        for (_, route) in newRoutes {
            newPath.append(route)
        }
        self.path = newPath
        self.mLog(msg: "replaceStack() completed. After -> routesId: \(routesId), pathCount: \(path.count)")
    }
}
