//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

struct ContentView: View {
    @State private var birds1 = Bird.examples
    @State private var birds2 = Bird.examples
    
    var body: some View {
        VStack {
            List {
                ForEach(birds1) { bird in
                    Text(bird.name)
                        .onDrag {
                            bird.provider
                        }
                }
                .onInsert(of: Bird.Wrapper.readableTypes) { index, itemProviders in
                    itemProviders.reversed().loadItems(Bird.self) { bird, error in
                        if let bird {
                            birds1.insert(bird, at: index)
                        }
                    }
                }
                .onMove {
                    birds1.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    birds1.remove(atOffsets: $0)
                }
            }
            
            List {
                ForEach(birds2) { bird in
                    Text(bird.name)
                        .onDrag {
                            bird.provider
                        }
                }
                .onInsert(of: Bird.Wrapper.readableTypes) { index, itemProviders in
                    itemProviders.reversed().loadItems(Bird.self) { bird, error in
                        if let bird {
                            birds2.insert(bird, at: index)
                        }
                    }
                }
                .onMove {
                    birds2.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    birds2.remove(atOffsets: $0)
                }
            }
            
            Text("Hand")
                .onDrag { Bird(name: "HandBird").provider }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
