//
//  SequenceExtension.swift
//
//  Created by iobit on 2021/12/30.
//

import Foundation

// MARK: - Array
extension Array {
    
    /// 安全取值
    subscript(safe index: Int) -> Element? {
        guard (startIndex..<endIndex).contains(index)  else {
            return nil
        }
        return self[index]
    }
    
    /// 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map( { filter($0) } ).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}


// MARK: - Sequence
extension Sequence {

    /// Group a `Sequence` into a dictionary with the elements of the sequence as keys and the number of occurrences as values.
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: Box<[Iterator.Element]>] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.value.append(element) {
                categories[key] = Box([element])
            }
        }
        var result: [U: [Iterator.Element]] = Dictionary(minimumCapacity: categories.count)
        for (key,val) in categories {
            result[key] = val.value
        }

        return result
    }

    /// Group a `Sequence` into a array of individual arrays, each containing the elements that share the same key.
    func group<T: Hashable>(by key: (_ element: Element) -> T) -> [[Element]] {
        var categories: [T: [Element]] = [:]
        for element in self {
            let key = key(element)
            categories[key, default: []].append(element)
        }
        
        return categories.values.map { $0 }
    }
}