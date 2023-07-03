//
//  BirdListTransferable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-05-25.
//

import SwiftUI

@available(iOS 16, macOS 13, *)
struct BirdListTransferable: View {
    @Binding var birds: [Bird]
    @State private var isEmptyListTargeted = false
    
    var body: some View {
        if birds.isEmpty {
            Color.gray
                .opacity(isEmptyListTargeted ? 0.5 : 1)
                .dropDestination(for: Bird.self) { droppedBirds, location in
                    birds.append(contentsOf: droppedBirds)
                    return true
                } isTargeted: {
                    isEmptyListTargeted = $0
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
                    .accessibilityMoveable(bird, actions: [.up, .down, .up(3), .down(3), .toTop, .toBottom])
                    .draggable(bird)
                }
                .onMove {
                    birds.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    birds.remove(atOffsets: $0)
                }
                .dropDestination(for: Bird.self) { droppedBirds, offset in
                    /// only add birds with new unique ids
                    let newBirds = droppedBirds.filter { bird in
                        !birds.contains { $0.id == bird.id }
                    }
                    birds.insert(contentsOf: newBirds, at: offset)
                }
                
            }
            .accessibilityMoveableList($birds, label: \.name)
        }
    }
}

@available(iOS 16, macOS 13, *)
struct BirdListTransferable_Previews: PreviewProvider {
    static var previews: some View {
        BirdListTransferable(birds: .constant(Bird.examples))
    }
}
