//
//  MoreInfo.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-10.
//

import SwiftUI

struct MoreInfo: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Providable or Transferable")
                        .font(.title)
                    
                    Text(
"""
- Drag items to reorder.
- Drag from one list to another.
- While dragging tap to add additional items.
- Drag string into list.
- Drag strings from any app.
- Enable VoiceOver and use move actions to move items up, down, to the top and to the bottom of the list. (iOS 15+ only. dragging between lists and apps not yet supported)
"""
                    )
                    .padding(.horizontal)
                    
                    Text("Providable Only")
                        .font(.title)
                        .padding(.top)
                    
                    Text(
"""
- Drag items to make a new window on iPadOS (iOS 16+ only)
"""
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("More Info")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

struct MoreInfo_Previews: PreviewProvider {
    struct PreviewData: View {
        @State private var isShowingMoreInfo = true
        
        var body: some View {
            Color.clear
                .sheet(isPresented: $isShowingMoreInfo) {
                    MoreInfo()
                }
        }
    }
    
    static var previews: some View {
        PreviewData()
    }
}
