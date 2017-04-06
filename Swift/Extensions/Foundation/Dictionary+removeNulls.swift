//
//  Dictionary+removeNulls.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 1/14/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation

extension Dictionary {
    func removeNils() -> Dictionary {
        var dict = self
        let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }

        return dict
    }
}
