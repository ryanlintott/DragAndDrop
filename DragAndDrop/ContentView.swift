//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

struct ContentView: View {
    @State private var birds = Bird.examples
    
    var birdList: some View {
        List {
            ForEach(birds) { bird in
                Text(bird.name)
                    .onDrag {
                        bird.provider
                    }
            }
            .onInsert(of: Bird.Wrapper.readableTypes) { index, itemProviders in
                insertBird(position: index, itemProviders: itemProviders)
            }
            .onMove {
                birds.move(fromOffsets: $0, toOffset: $1)
            }
            .onDelete {
                birds.remove(atOffsets: $0)
            }
        }
    }
    
    var body: some View {
        VStack {
            birdList
            
            birdList
            
            Text("Hand")
                .onDrag { Bird(name: "HandBird").provider }
        }
        .padding()
    }
    
    func insertBird(position: Int, itemProviders: [NSItemProvider]) {
        itemProviders.reversed().loadItems(Bird.self) { bird, error in
            if let bird {
                birds.insert(bird, at: position)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
