//
//  DraggableView.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-07-24.
//

import ILikeToMoveIt
import UIKit
import SwiftUI

class DraggableUIView: UIView, UIDragInteractionDelegate {
    var item: Providable? = nil
    var itemName: String? = nil
    
    func makeAccessibilityElements() {
        let element = UIAccessibilityElement(accessibilityContainer: self)
        element.accessibilityFrameInContainerSpace = frame
        element.accessibilityLabel = "UIView draggable"
        let dragPoint = CGPoint(x: frame.midX, y: frame.midY)
        let name = itemName ?? "item"
        let descriptor = UIAccessibilityLocationDescriptor(name: "Drag \(name)", point: dragPoint, in: self)
        element.accessibilityDragSourceDescriptors = [descriptor]
        
        accessibilityElements = [element]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let item else { return [] }
        return [UIDragItem(itemProvider: item.provider)]
    }
}

struct DraggableView: UIViewRepresentable {
    typealias UIViewType = DraggableUIView
    
    let item: Providable
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        /// Do something
    }
    
    func makeUIView(context: Context) -> UIViewType {
        let uiView = UIViewType()
        uiView.item = item
        uiView.itemName = "Bird"
        uiView.backgroundColor = .red
        uiView.makeAccessibilityElements()
        uiView.addInteraction(UIDragInteraction(delegate: uiView))
        return uiView
    }
}

struct DraggableView_Previews: PreviewProvider {
    static var previews: some View {
        DraggableView(item: Bird(name: "Test"))
            .frame(width: 100, height: 100)
    }
}
