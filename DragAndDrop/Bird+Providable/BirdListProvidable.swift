//
//  BirdListProvidable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-13.
//

import SwiftUI

struct BirdListProvidable: View {
    @Binding var birds: [Bird]
    @State private var isEmptyListTargeted = false
    
    var body: some View {
        if birds.isEmpty {
            Color.gray
                .opacity(isEmptyListTargeted ? 0.5 : 1)
                .onDrop(of: Bird.readableTypes, isTargeted: $isEmptyListTargeted) { providers, location in
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
                            .accessibilityHidden(true)
                    }
                    .accessibilityHint("id: \(bird.id.uuidString)")
                    .accessibilityMoveableIfAvailable(bird, actions: [.up, .down, .up(3), .down(3), .toTop, .toBottom])
                    .onDrag {
                        bird.provider
                    }
                }
                .onInsert(of: Bird.readableTypes) { index, providers in
                    providers.reversed().loadItems(Bird.self) { bird, error in
                        if let bird {
                            /// only add birds with new unique ids
                            if !birds.contains(where: { $0.id == bird.id }) {
                                birds.insert(bird, at: index)
                            }
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
            .accessibilityMoveableListIfAvailable($birds, label: \.name)
        }
    }
}

struct BirdList_Previews: PreviewProvider {
    static var previews: some View {
        BirdListProvidable(birds: .constant(Bird.examples))
    }
}
