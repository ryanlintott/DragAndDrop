//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

enum DragProtocol: String, CaseIterable, Identifiable {
    case providable
    case transferable
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var birds1: [Bird] = Bird.examples
    @State private var birds2: [Bird] = []
    @State private var dragProtocol: DragProtocol = .providable
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Protocol", selection: $dragProtocol) {
                    ForEach(DragProtocol.allCases) { dragProtocol in
                        Text(dragProtocol.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
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
                    switch dragProtocol {
                    case .providable:
                        BirdListProvidable(birds: $birds1)
                        BirdListProvidable(birds: $birds2)
                    case .transferable:
                        if #available(iOS 16, macOS 13, *) {
                            BirdListTransferable(birds: $birds1)
                            BirdListTransferable(birds: $birds2)
                        } else {
                            Text("Not supported.")
                        }
                    }
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
