//
//  HashableSynthesizable.swift
//
//  Created by roy on 2022/3/11.
//

import UIKit

/// A type whose `Hashable` conformance could be auto-synthesized
public protocol HashableSynthesizable: Hashable { }

public extension HashableSynthesizable {
    
    static func == (hashable0: Self, hashable1: Self) -> Bool {
        zip(hashable0.hashables, hashable1.hashables).allSatisfy(==)
    }

    func hash(into hasher: inout Hasher) {
        hashables.forEach { hasher.combine($0) }
    }
}

private extension HashableSynthesizable {
    
    var hashables: [AnyHashable] {
        Mirror(reflecting: self).children
            .compactMap { $0.value as? AnyHashable }
    }
}


extension CGPoint: HashableSynthesizable {}
extension CGFloat: HashableSynthesizable {}
extension CGRect: HashableSynthesizable {}
