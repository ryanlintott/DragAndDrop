//
//  BirdUserActivityProvidableView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-11.
//

import SwiftUI

@available(iOS 16, macOS 13, *)
struct BirdUserActivityProvidableView: ViewModifier {
    @Environment(\.openWindow) var openWindow
    
    func body(content: Content) -> some View {
        content
            .onContinueUserActivity(Bird.self) { bird in
                guard let bird else { return }
                openWindow(value: bird)
            }
    }
}
