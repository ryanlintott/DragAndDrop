//
//  Providable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-12.
//

import Foundation
import UniformTypeIdentifiers

protocol ProvidableItem: Codable {
    associatedtype Wrapper: Providable where Wrapper.Item == Self
    static var uti: UTType { get }
    static var name: String { get }
}

extension ProvidableItem {
    var provider: NSItemProvider {
        .init(object: Wrapper(self))
    }
    
    init(provider: NSItemProvider) async throws {
        self = try await withCheckedThrowingContinuation { continuation in
            if provider.canLoadObject(ofClass: Wrapper.self) {
                _ = provider.loadObject(ofClass: Wrapper.self) { wrapper, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let wrapper = wrapper as? Wrapper {
                        continuation.resume(returning: wrapper.item)
                    }
                }
            }
        }
    }
}

extension NSItemProvider {
    func loadItem<T: ProvidableItem>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        if canLoadObject(ofClass: T.Wrapper.self) {
            _ = loadObject(ofClass: T.Wrapper.self) { wrapper, error in
                if let error {
                    completionHandler(nil, error)
                    return
                }
                if let wrapper = wrapper as? T.Wrapper {
                    completionHandler(wrapper.item, nil)
                } else {
                    completionHandler(nil, DecodingError.typeMismatch(T.Wrapper.self, .init(codingPath: [], debugDescription: "Unable to downcast Wrapper from NSItemProviderReading")))
                }
            }
        }
    }
}

extension [NSItemProvider] {
    func loadItems<T: ProvidableItem>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        forEach { provider in
            provider.loadItem(itemType, completionHandler: completionHandler)
        }
    }
}

protocol Providable: NSItemProviderWriting, NSItemProviderReading {
    associatedtype Item: ProvidableItem where Item.Wrapper == Self
    var item: Item { get }
    init(_: Item)
    static var writableTypes: [UTType] { get }
    static var readableTypes: [UTType] { get }
}
