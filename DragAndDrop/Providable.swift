//
//  Providable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-12.
//

import Foundation
import UniformTypeIdentifiers

protocol Providable: Codable {
    associatedtype Wrapper: ProvidableWrapper where Wrapper.Item == Self
}

extension Providable {
    var provider: NSItemProvider {
        .init(object: Wrapper(self))
    }
    
    static func load(from provider: NSItemProvider, completionHandler: @escaping (Self?, Error?) -> Void) {
        provider.loadItem(Self.self, completionHandler: completionHandler)
    }
}

extension NSItemProvider {
    func loadItem<T: Providable>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
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
    func loadItems<T: Providable>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        forEach { provider in
            provider.loadItem(itemType, completionHandler: completionHandler)
        }
    }
}

protocol ProvidableWrapper: AnyObject, NSObjectProtocol, NSItemProviderWriting, NSItemProviderReading {
    associatedtype Item: Providable where Item.Wrapper == Self
    var item: Item { get }
    init(_: Item)
    static var uti: UTType { get }
    static var name: String { get }
    static var writableTypes: [UTType] { get }
    static var readableTypes: [UTType] { get }
}
