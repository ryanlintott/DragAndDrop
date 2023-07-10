//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2022-10-11.
//

import SwiftUI

enum DragProtocol: String, CaseIterable, Identifiable {
    case transferable
    case providable
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var birds1: [Bird] = Bird.examples
    @State private var birds2: [Bird] = []
    @State private var dragProtocol: DragProtocol = .transferable
    @State private var isShowingMoreInfo = false
    
    var logo: some View {
        Image("ILikeToMoveIt-logo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 400)
            .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                logo
                
                VStack(alignment: .leading) {
                    Text("This is a demo of SwiftUI drag and drop features along with iLikeToMoveIt extensions.")
                    
                    Button {
                        isShowingMoreInfo = true
                    } label: {
                        Label("More Info", systemImage: "info.circle")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    
                    Picker("Protocol", selection: $dragProtocol) {
                        ForEach(DragProtocol.allCases) { dragProtocol in
                            Text(dragProtocol.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text("Draggable String >")
                        
                        Text("StringBird")
                            .padding()
                            .onDrag { NSItemProvider(object: "StringBird" as NSString) }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    switch dragProtocol {
                    case .transferable:
                        if #available(iOS 16, macOS 13, *) {
                            BirdListTransferable(birds: $birds1)
                            BirdListTransferable(birds: $birds2)
                        } else {
                            Text("Transferable Not supported. Use Providable.")
                        }
                    case .providable:
                        BirdListProvidable(birds: $birds1)
                        BirdListProvidable(birds: $birds2)
                    }
                }
            }
            .navigationTitle("iLikeToMoveIt")
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingMoreInfo) {
                MoreInfo()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
