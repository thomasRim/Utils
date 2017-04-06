//
//  Array+removeNulls.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 1/14/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        var result: [Iterator.Element.Wrapped] = []
        for element in self {
            if let element = element.map({ $0 }) {
                result.append(element)
            }
        }
        return result
    }
}
