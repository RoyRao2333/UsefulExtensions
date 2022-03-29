//
//  PublisherExtension.swift
//  ChartDemo
//
//  Created by roy on 2022/3/8.
//

import Combine

extension Publisher {

    /// Includes the current element as well as the previous element from the upstream publisher in a tuple where the previous element is optional.
    /// The first time the upstream publisher emits an element, the previous element will be `nil`.
    ///
    ///     let range = (1...5)
    ///     cancellable = range.publisher
    ///         .withPrevious()
    ///         .sink { print ("(\($0.previous), \($0.current))", terminator: " ") }
    ///      // Prints: "(nil, 1) (Optional(1), 2) (Optional(2), 3) (Optional(3), 4) (Optional(4), 5) ".
    ///
    /// - Returns: A publisher of a tuple of the previous and current elements from the upstream publisher.
    func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
        scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    /// Includes the current element as well as the previous element from the upstream publisher in a tuple where the previous element is not optional.
    /// The first time the upstream publisher emits an element, the previous element will be the `initialPreviousValue`.
    ///
    ///     let range = (1...5)
    ///     cancellable = range.publisher
    ///         .withPrevious(0)
    ///         .sink { print ("(\($0.previous), \($0.current))", terminator: " ") }
    ///      // Prints: "(0, 1) (1, 2) (2, 3) (3, 4) (4, 5) ".
    ///
    /// - Parameter initialPreviousValue: The initial value to use as the "previous" value when the upstream publisher emits for the first time.
    /// - Returns: A publisher of a tuple of the previous and current elements from the upstream publisher.
    func withPrevious(_ initialPreviousValue: Output) -> AnyPublisher<(previous: Output, current: Output), Failure> {
        scan((initialPreviousValue, initialPreviousValue)) { ($0.1, $1) }.eraseToAnyPublisher()
    }
}


extension Publisher where Self.Failure == Never {
    
    func assign2<Root1, Root2>(
        to keyPath1: ReferenceWritableKeyPath<Root1, Output>, on object1: Root1,
        and keyPath2: ReferenceWritableKeyPath<Root2, Output>, on object2: Root2
    ) -> AnyCancellable {
        sink { value in
            object1[keyPath: keyPath1] = value
            object2[keyPath: keyPath2] = value
        }
    }

    func assign3<Root1, Root2, Root3>(
        to keyPath1: ReferenceWritableKeyPath<Root1, Output>, on object1: Root1,
        and keyPath2: ReferenceWritableKeyPath<Root2, Output>, on object2: Root2,
        and keyPath3: ReferenceWritableKeyPath<Root3, Output>, on object3: Root3
    ) -> AnyCancellable {
        sink { value in
            object1[keyPath: keyPath1] = value
            object2[keyPath: keyPath2] = value
            object3[keyPath: keyPath3] = value
        }
    }

    /// assign object 为 AnyObject 使用 assignNoRetain 系统assign 会强引用object
    func assignNoRetain<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root
    ) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
