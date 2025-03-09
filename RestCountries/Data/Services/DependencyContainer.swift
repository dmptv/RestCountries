//
//  DependencyContainer.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import Foundation

@Observable
final class DependencyContainer {
    private var dependencies: [String: Any] = [:]

    func register<T>(_ dependency: T, for type: T.Type = T.self) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }

    func resolve<T>(_ type: T.Type = T.self) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
}
