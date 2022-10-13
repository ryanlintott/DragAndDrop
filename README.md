# DragAndDrop
Simple drag and drop with custom objects in iOS 14.

## Demo


## Making your custom type draggable

- Start with a `Codable` object that you want to drag and drop.

```swift
struct Bird: Codable {
    let name: String
}
```

- Add your custom object info to your Project

Project > Target > Info > Exported Type Identifiers

<img width="814" alt="image" src="https://user-images.githubusercontent.com/2143656/195647322-301e2d2e-8bcd-42a7-8d22-870836066832.png">

- Add an extension that conforms your object to `Providable`
- Add a new final class `Wrapper` that inherits from `NSObject` and conforms to `ProvidableWrapper`

```swift
extension Bird: Providable {
    final class Wrapper: NSObject, ProvidableWrapper {
        /// Add properties here
    }
}
```

- Add typealias, item and required init to `Wrapper`
```swift
typealias Item = Bird

let item: Item

required init(_ item: Item) {
    self.item = item
    super.init()
}
```

- Add a type name and a custom `UTType` to match your exported type identifier.

```swift
static var name = "bird"
static var uti = UTType("com.yourname.yourappname.bird") ?? .data
```

- Add arrays of writable and readable types as `UTType`

```swift
static var writableTypes: [UTType] {
    [uti]
}

static var readableTypes: [UTType] {
    [uti, UTType.plainText]
}
```

- Add arrays of identifier strings computed from the `UTType` arrays.

```swift
static var writableTypeIdentifiersForItemProvider: [String] {
    writableTypes.map(\.identifier)
}

static var readableTypeIdentifiersForItemProvider: [String] {
    readableTypes.map(\.identifier)
}
```

- Add functions to transform the type to and from `NSItemProvider`

```swift
func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
    do {
        switch typeIdentifier {
        case Self.uti.identifier:
            let data = try JSONEncoder().encode(item)
            completionHandler(data, nil)
        default:
            throw DecodingError.valueNotFound(Bird.self, .init(codingPath: [], debugDescription: "No Birds"))
        }
    } catch {
        completionHandler(nil, error)
    }
    return Progress(totalUnitCount: 100)
}

static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
    switch typeIdentifier {
    case Self.uti.identifier:
        let bird = try JSONDecoder().decode(Bird.self, from: data)
        return .init(bird)
    case UTType.plainText.identifier:
        let string = String(decoding: data, as: UTF8.self)
        let bird = Bird(name: string)
        return .init(bird)
    default:
        throw DecodingError.valueNotFound(Bird.self, .init(codingPath: [], debugDescription: "No Birds"))
    }
}
```

## Adding drag and drop to your SwiftUI views
Once your type conforms to `Providable`, adding SwiftUI drag and drop modifiers is easy!

### onDrag
```swift
.onDrag { bird.provider }
```

### onDrop
```swift
.onDrop(of: Bird.Wrapper.readableTypes, isTargeted: nil) { providers, location in
    providers.reversed().loadItems(Bird.self) { bird, error in
        if let bird {
            birds.append(bird)
        }
    }
    return true
}
```

### onInsert(of:)
```
.onInsert(of: Bird.Wrapper.readableTypes) { index, providers in
    providers.reversed().loadItems(Bird.self) { bird, error in
        if let bird {
            birds.insert(bird, at: index)
        }
    }
}
```



