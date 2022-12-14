//
//  BirdList.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-13.
//

import SwiftUI

struct BirdList: View {
    @Binding var birds: [Bird]
    
    var body: some View {
        if birds.isEmpty {
            Color.gray
                .onDrop(of: Bird.Wrapper.readableTypes, isTargeted: nil) { providers, location in
                    providers.reversed().loadItems(Bird.self) { bird, error in
                        if let bird {
                            birds.append(bird)
                        }
                    }
                    return true
                }
        } else {
            List {
                ForEach(birds) { bird in
                    VStack {
                        Text(bird.name)
                        Text("id: \(bird.id.uuidString)")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .onDrag {
                        bird.provider
                    }
                }
                .onInsert(of: Bird.Wrapper.readableTypes) { index, providers in
                    providers.reversed().loadItems(Bird.self) { bird, error in
                        if let bird {
                            birds.insert(bird, at: index)
                        }
                    }
                }
                .onMove {
                    birds.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    birds.remove(atOffsets: $0)
                }
            }
        }
    }
}

struct BirdList_Previews: PreviewProvider {
    static var previews: some View {
        BirdList(birds: .constant(Bird.examples))
    }
}
