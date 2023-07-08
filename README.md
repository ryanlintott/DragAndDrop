# DragAndDrop
Example app for [ILikeToMoveIt](https://github.com/ryanlintott/ILikeToMoveIt)

Also just a demo app for Drag and Drop features.

## Accessible move actions
*\*iOS 15+*
Adding `.onMove` allows some users to drag items up and down in a list but it does not add any accessibility affordances to perform these actions.

If you want to add accessibility actions to move items up and down your list you can add the package [ILikeToMoveIt](https://github.com/ryanlintott/ILikeToMoveIt) and follow the instructtions to add `.accessibilityMoveable()` view modifiers.

## Drag and drop for custom types

<img width="250" alt="" src="https://user-images.githubusercontent.com/2143656/195680033-2a22ccb1-bc9c-4a87-aa05-05082ead4f4e.gif">

## Making a new draggable type
- Start with a `Codable` object that you want to drag and drop.

```swift
struct Bird: Codable {
    let name: String
}
```

- Add your custom object info to your Project

Project > Target > Info > Exported Type Identifiers

<img width="814" alt="image" src="https://user-images.githubusercontent.com/2143656/195647322-301e2d2e-8bcd-42a7-8d22-870836066832.png">

- Add your type as an extension to UTType

```swift
import UniformTypeIdentifiers

extension UTType {
    static let bird = UTType("com.ryanlintott.draganddrop.bird") ?? .data
}
```

## Draggable custom types in iOS 14 & 15

- Add [ILikeToMoveIt](https://github.com/ryanlintott/ILikeToMoveIt) to your project and follow instructions to conform your object to `Providable`.


## Draggable custom types in iOS 16

- Conform your object to `Transferable`
- Add the `transferRepresetation` property and include a `CodableRepresentation` for your custom type along with a `DataRepresentation` for any other compatible types.

```swift
static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .bird)

    DataRepresentation(importedContentType: .plainText) { data in
        let string = String(decoding: data, as: UTF8.self)
        return Bird(name: string)
    }
}
```

## Adding drag and drop to your SwiftUI views
Once your type conforms to `Transferable`, adding SwiftUI drag and drop modifiers is easy!

### draggable(\_:)
Make any view draggable by adding this modifier
```swift
.draggable(bird)
```

### dropDestination(for:,action:,isTargetted:)
Any view can be a drop destination. Add the dropped items using the action, use the location for animation if you like, and use the isTargeted closure to animate the view when droppable content is hovering.
```swift
.dropDestination(for: Bird.self) { droppedBirds, location in
    birds.append(contentsOf: droppedBirds)
    return true
} isTargeted: {
    isTargetted = $0
}
```

### dropDestination(for:,action:)
When added to ForEach dropped items can be inserted in-between other items.
```
.dropDestination(for: Bird.self) { droppedBirds, offset in
    birds.insert(contentsOf: droppedBirds, at: offset)
}
```


