//
//  Bird+Providable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-13.
//

import Foundation
import UniformTypeIdentifiers

extension Bird: Providable {
    final class Wrapper: NSObject, ProvidableWrapper {
        typealias Item = Bird
        
        let item: Item
        
        required init(_ item: Item) {
            self.item = item
            super.init()
        }
        
        static var name = "bird"
        static var uti = UTType.bird
        
        static var writableTypes: [UTType] {
            [uti]
        }
        
        static var readableTypes: [UTType] {
            [uti, UTType.plainText]
        }
        
        static var writableTypeIdentifiersForItemProvider: [String] {
            writableTypes.map(\.identifier)
        }

        static var readableTypeIdentifiersForItemProvider: [String] {
            readableTypes.map(\.identifier)
        }
        
        func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
            do {
                switch typeIdentifier {
                case Self.uti.identifier:
                    let data = try JSONEncoder().encode(item)
                    completionHandler(data, nil)
                default:
                    throw ProvidableError.unsupportedUTIIdentifier
                }
            } catch {
                completionHandler(nil, error)
            }
            return Progress(totalUnitCount: 100)
        }
        
        static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
            switch typeIdentifier {
            case Self.uti.identifier:
                let item = try JSONDecoder().decode(Item.self, from: data)
                return .init(item)
            case UTType.plainText.identifier:
                let string = String(decoding: data, as: UTF8.self)
                let item = Bird(name: string)
                return .init(item)
            default:
                throw ProvidableError.unsupportedUTIIdentifier
            }
        }
    }
}
