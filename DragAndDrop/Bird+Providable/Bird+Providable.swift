//
//  Bird+Providable2.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-03.
//

import Foundation
import ILikeToMoveIt
import UniformTypeIdentifiers

extension Bird: Providable {
    static var writableTypes: [UTType] {
        [.bird]
    }

    static var readableTypes: [UTType] {
        [.bird, .plainText]
    }

    func data(type: UTType) async throws-> Data? {
        switch type {
        case .bird:
            return try JSONEncoder().encode(self)
        default:
            return nil
        }
    }

    init?(type: UTType, data: Data) throws {
        switch type {
        case .bird:
            self = try JSONDecoder().decode(Bird.self, from: data)
        case .plainText:
            let string = String(decoding: data, as: UTF8.self)
            self = Bird(name: string)
        default:
            return nil
        }
    }
}
