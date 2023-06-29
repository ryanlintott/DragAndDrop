//
//  AccessibilityMoveActions.swift
//  DragAndDrop
//
//  Created by Ryan Lintott on 2023-06-28.
//

import SwiftUI

public enum AccessibilityMoveAction: Identifiable, Hashable, Equatable {
    case up
    case down
    
    public var id: Self { self }
}

public extension AccessibilityMoveAction {
    var name: String {
        switch self {
        case .up:
            return "Move up"
        case .down:
            return "Move down"
        }
    }
}

public struct AccessibilityFocusedItemKey: EnvironmentKey {
    public static let defaultValue: (any Hashable)? = nil
}

public struct AccessibilityMoveKey: EnvironmentKey {
    public static let defaultValue: ((any Hashable, AccessibilityMoveAction) -> Void)? = nil
}

public extension EnvironmentValues {
    var accessibilityFocusedItem: (any Hashable)? {
        get { self[AccessibilityFocusedItemKey.self] }
        set { self[AccessibilityFocusedItemKey.self] = newValue }
    }
    
    var accessibilityMove: ((_ item: any Hashable, _ action: AccessibilityMoveAction) -> Void)? {
        get { self[AccessibilityMoveKey.self] }
        set { self[AccessibilityMoveKey.self] = newValue }
    }
}

@available(iOS 15, macOS 12, *)
struct AccessibilityMoveViewModifier<Item: Hashable & Equatable>: ViewModifier {
    @Environment(\.accessibilityFocusedItem) var accessibilityFocusedItem
    @AccessibilityFocusState var isFocused: Bool
    
    let item: Item
    let actions: [AccessibilityMoveAction]
    
    func body(content: Content) -> some View {
        content
            .accessibilityFocused($isFocused)
            .accessibilityMoveActionsRecursive(item: item, actions: actions)
            .onChange(of: accessibilityFocusedItem as? Item) { newValue in
                isFocused = newValue == item
            }
    }
}

struct AccessibilityMoveActionViewModifier<Item: Hashable & Equatable>: ViewModifier {
    @Environment(\.accessibilityMove) var accessibilityMove
    
    let item: Item
    let action: AccessibilityMoveAction
    
    func body(content: Content) -> some View {
        content
            .accessibilityAction(named: action.name) {
                accessibilityMove?(item, action)
            }
    }
}

@available(iOS 15, macOS 12, *)
public extension View {
    func accessibilityMove<Item: Hashable>(_ item: Item, actions: [AccessibilityMoveAction] = [.up, .down]) -> some View {
        modifier(AccessibilityMoveViewModifier(item: item, actions: actions))
    }
    
    @ViewBuilder
    fileprivate func accessibilityMoveActionsRecursive<T: Hashable>(item: T, actions: some Collection<AccessibilityMoveAction>) -> some View {
        switch actions.count {
        case ...0:
            self
        case 1:
            self
                .modifier(AccessibilityMoveActionViewModifier(item: item, action: actions.first!))
        default:
            self
                .modifier(AccessibilityMoveActionViewModifier(item: item, action: actions.first!))
                .accessibilityMoveActionsRecursive(item: item, actions: actions.dropFirst(1))
        }
    }
}

public extension View {
    func accessibilityMoveIfAvailable<Item: Hashable>(_ item: Item, actions: [AccessibilityMoveAction] = [.up, .down]) -> some View {
        if #available(iOS 15, macOS 12, *) {
            return modifier(AccessibilityMoveViewModifier(item: item, actions: actions))
        } else {
            return self
        }
    }
}

@available(iOS 15, macOS 12, *)
struct AccessibilityMoveableViewModifier<Item: Hashable>: ViewModifier {
    @AccessibilityFocusState var focus: Item?
    
    @Binding var items: [Item]
    let label: KeyPath<Item, String>?
    
    func body(content: Content) -> some View {
        content
            .environment(\.accessibilityFocusedItem, focus)
            .environment(\.accessibilityMove) { item, destination in
                guard
                    let item = item as? Item,
                    let firstIndex = items.firstIndex(of: item),
                    items.count > 1
                else { return }
                
                switch destination {
                case .up:
                    if firstIndex > items.startIndex {
                        /// Save a copy of the user here
                        let thisItem = item
                        items.swapAt(firstIndex, items.index(before: firstIndex))
                        /// Set the focus to the copy (setting the focus to user does not work)
                        focus = thisItem
                        
                        let announcement: String
                        if let label {
                            announcement = "Moved above \(items[firstIndex][keyPath: label])"
                        } else {
                            announcement = "Moved up"
                        }
                        
                        UIAccessibility.post(notification: .announcement, argument: announcement)
                    }
                case .down:
                    if firstIndex < items.endIndex - 1 {
                        /// Save a copy of the user here
                        let thisItem = item
                        items.swapAt(firstIndex, items.index(after: firstIndex))
                        /// Set the focus to the copy (setting the focus to user does not work)
                        focus = thisItem
                        
                        let announcement: String
                        if let label {
                            announcement = "Moved below \(items[firstIndex][keyPath: label])"
                        } else {
                            announcement = "Moved down"
                        }
                        
                        UIAccessibility.post(notification: .announcement, argument: announcement)
                    }
                }
            }
    }
}

@available(iOS 15, macOS 12, *)
public extension View {
    func accessibilityMoveable<Item: Hashable>(_ items: Binding<Array<Item>>, label: KeyPath<Item, String>? = nil) -> some View {
        modifier(AccessibilityMoveableViewModifier(items: items, label: label))
    }
}

public extension View {
    func accessibilityMoveableIfAvailable<Item: Hashable>(_ items: Binding<Array<Item>>, label: KeyPath<Item, String>? = nil) -> some View {
        if #available(iOS 15, macOS 12, *) {
            return modifier(AccessibilityMoveableViewModifier(items: items, label: label))
        } else {
            return self
        }
    }
}


