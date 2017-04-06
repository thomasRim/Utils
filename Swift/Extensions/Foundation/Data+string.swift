//
//  Data+string.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 1/25/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation

extension Data {
    func stringValue() -> String? {
        let str = NSString(data: self, encoding: String.Encoding.utf8.rawValue)
        return str as String?
    }
}
