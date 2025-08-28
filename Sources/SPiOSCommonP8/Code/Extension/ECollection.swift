//
//  ECollection.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 28/08/25.
//

/// Extension to add safe element retrieval to all collections.
extension Collection {
    /// Safely retrieves an element at the specified index.
    ///
    /// - Parameter index: The index of the element to retrieve.
    /// - Returns: The element at the given index if it exists, otherwise `nil`.
    func ext_GetIfIndexExists(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/// Extension to add safe element setting to mutable collections that support range replacement.
extension MutableCollection where Self: RangeReplaceableCollection {
    /// Safely sets an element at the specified index.
    ///
    /// - Parameters:
    ///   - element: The element to set.
    ///   - index: The index at which to set the element.
    /// - Returns: `true` if the element was set successfully, `false` if the index was out of bounds.
    mutating func ext_SetIfIndexExists(_ element: Element, at index: Index) -> Bool {
        if indices.contains(index) {
            self[index] = element
            return true
        }
        return false
    }
}
