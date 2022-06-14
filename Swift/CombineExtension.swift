//
//  CombineExtension.swift
//
//  Created by Roy Rao on 2022/6/14.
//

import Combine

extension Future where Failure == Error {
    
    convenience init(operation: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let output = try await operation()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
