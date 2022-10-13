//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

struct ContentView: View {
    @State private var birds1: [Bird] = Bird.examples
    @State private var birds2: [Bird] = []
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(
"""
- Drag birds to reorder.
- Drag from one list to another.
- While dragging tap to add additional birds.
- Drag string from below.
- Drag strings from any app.
"""
                    )
                    
                    Text("StringBird")
                        .padding()
                        .onDrag { NSItemProvider(object: "StringBird" as NSString) }
                }
                .padding()
                
                HStack {
                    BirdList(birds: $birds1)
                    BirdList(birds: $birds2)
                }
            }
            .navigationTitle("Drag and Drop")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
