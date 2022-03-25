//
//  ArrayExtension.swift
//
//  Created by iobit on 2021/12/30.
//

import Foundation

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
