//
//  DraggableStringView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-24.
//

import SwiftUI

struct DraggableStringView: View {
    var body: some View {
        HStack {
            Text("Draggable String:")
            
            
            Text("StringBird")
                .padding()
                .onDrag { NSItemProvider(object: "StringBird" as NSString) }
            
//            DraggableView(item: Bird(name: "StringBird"))
        }
    }
}

struct DraggableStringView_Previews: PreviewProvider {
    static var previews: some View {
        DraggableStringView()
    }
}
