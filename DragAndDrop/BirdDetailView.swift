//
//  BirdDetailView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-11.
//

import SwiftUI

struct BirdDetailView: View {
    @State private var isTargeted = false
    
    @State private var bird: Bird
    
    init(bird: Bird) {
        self._bird = .init(initialValue: bird)
    }
    
    var body: some View {
        Color.clear
            .overlay(
                VStack {
                    Text(bird.name)
                        .font(.largeTitle)
                    Text(bird.id.uuidString)
                }
            )
            .opacity(isTargeted ? 0.5 : 1)
            .onDrop(of: Bird.readableTypes, isTargeted: $isTargeted) { providers, location in
                providers.reversed().loadItems(Bird.self) { bird, error in
                    if let bird {
                        self.bird = bird
                    }
                }
                return true
            }
    }
}

struct BirdDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BirdDetailView(bird: Bird.examples.first!)
    }
}
