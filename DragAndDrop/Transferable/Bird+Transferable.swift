//
//  Bird+Transferable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-05-25.
//

import SwiftUI

@available(iOS 16, macOS 13, *)
extension Bird: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .bird) { bird in
            try JSONEncoder().encode(bird)
        } importing: { data in
            try JSONDecoder().decode(Bird.self, from: data)
        }
        
        DataRepresentation(importedContentType: .plainText) { data in
            let string = String(decoding: data, as: UTF8.self)
            return Bird(name: string)
        }
    }
}
