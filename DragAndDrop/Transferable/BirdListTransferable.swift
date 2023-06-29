//
//  BirdListTransferable.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-05-25.
//

import SwiftUI

@available(iOS 16, macOS 13, *)
struct BirdListTransferable: View {
    @AccessibilityFocusState private var focus: Bird?
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
                    }
                    .accessibilityMove(bird)
//                    .accessibilityFocused($focus, equals: bird)
//                    .accessibilityActions {
//                        Button {
//                            if let firstIndex = birds.firstIndex(of: bird),
//                               birds.count > 1,
//                               firstIndex > birds.startIndex {
//                                /// Save a copy of the user here
//                                let thisBird = bird
//                                birds.swapAt(firstIndex, birds.index(before: firstIndex))
//                                /// Set the focus to the copy (setting the focus to user does not work)
//                                focus = thisBird
//                                UIAccessibility.post(notification: .announcement, argument: "Moved above \(birds[firstIndex].name)")
//                            }
//                        } label: {
//                            Text("Move Up")
//                        }
//
//                        Button {
//                            if let firstIndex = birds.firstIndex(of: bird),
//                               birds.count > 1,
//                               firstIndex < birds.endIndex - 1 {
//                                /// Save a copy of the user here
//                                let thisBird = bird
//                                birds.swapAt(firstIndex, birds.index(after: firstIndex))
//                                /// Set the focus to the copy (setting the focus to user does not work)
//                                focus = thisBird
//                                UIAccessibility.post(notification: .announcement, argument: "Moved below \(birds[firstIndex].name)")
//                            }
//                        } label: {
//                            Text("Move Down")
//                        }
//                    }
                    .draggable(bird)
                }
                .onMove {
                    birds.move(fromOffsets: $0, toOffset: $1)
                }
                .onDelete {
                    birds.remove(atOffsets: $0)
                }
                .dropDestination(for: Bird.self) { droppedBirds, offset in
                    birds.insert(contentsOf: droppedBirds, at: offset)
                }
                
            }
            .accessibilityMoveable($birds, label: \.name)
        }
    }
}

@available(iOS 16, macOS 13, *)
struct BirdListTransferable_Previews: PreviewProvider {
    static var previews: some View {
        BirdListTransferable(birds: .constant(Bird.examples))
    }
}
