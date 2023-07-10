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
                VStack {
                    Text(
"""
Things you can do in this example app:

- Drag items to reorder.
- Drag from one list to another.
- While dragging tap to add additional items.
- Drag string into list.
- Drag strings from any app.
- Test out both Transferable and Providable versions
- Enable VoiceOver and test move actions to move items up, down, to the top and to the bottom of the list.
"""
                    )
                    
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
