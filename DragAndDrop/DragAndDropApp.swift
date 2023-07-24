//
//  DragAndDropApp.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

@main
struct DragAndDropApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        if #available(iOS 16, macOS 13, *) {
            WindowGroup(for: Bird.self) { $bird in
                if let bird {
                    BirdDetailView(bird: bird)
                } else {
                    Text("No bird.")
                }
            }
        }
    }
}
