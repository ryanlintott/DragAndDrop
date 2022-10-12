//
//  Bird.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct Bird: Identifiable, Codable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

extension Bird: ProvidableItem {
    typealias Wrapper = BirdWrapper
    
    static var name = "bird"
    static var uti = UTType("com.ryanlintott.draganddrop.bird") ?? .data
}

final class BirdWrapper: NSObject, Providable {
    typealias Item = Bird
    
    let item: Item
    
    required init(_ item: Item) {
        self.item = item
        super.init()
    }
    
    static var writableTypes: [UTType] {
        [Item.uti]
    }
    
    static var readableTypes: [UTType] {
        [Item.uti, UTType.plainText]
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
            case Bird.uti.identifier:
                let data = try JSONEncoder().encode(item)
                completionHandler(data, nil)
            default:
                throw DecodingError.valueNotFound(Bird.self, .init(codingPath: [], debugDescription: "No Birds"))
            }
        } catch {
            completionHandler(nil, error)
        }
        return Progress(totalUnitCount: 100)
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case Bird.uti.identifier:
            let bird = try JSONDecoder().decode(Bird.self, from: data)
            return .init(bird)
        case UTType.plainText.identifier:
            let string = String(decoding: data, as: UTF8.self)
            let bird = Bird(name: string)
            return .init(bird)
        default:
            throw DecodingError.valueNotFound(Bird.self, .init(codingPath: [], debugDescription: "No Birds"))
        }
    }
}

extension Bird {
    static let examples: [Self] = [
        "Cardinal",
        "Blue Jay",
        "Robin",
        "Goose",
        "Chicken",
        "Swan",
        "Flamingo"
    ].map { Bird(name: $0)}
}
