/*
 * Copyright (c) 2015 Magnet Systems, Inc.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you
 * may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import Foundation

/**
 *  DateFormats
 */
enum DateFormat:String {
    case MMddyy = "MM/dd/yy"
    case MMMMddyyyy = "MMMM dd, yyyy"
    case MMMMdd = "MMMM dd"
    case MDYHma = "MMM dd, yyyy HH:mm a"
    case Mdyhma = "MM/dd/yy hh:mm a"
    case MM_dd_yyyy = "MM-dd-yyyy"
    case MMddyyyy = "MM/dd/yyyy"
    case mmss = "mm:ss"
    case Hma = "HH:mm a"
    case EEEMMMddyyyy = "EEE, MMM dd, yyyy"
    case EEEEMMMMddyyyy = "EEEE, MMMM dd, yyyy"
    case MMMMddyyyyAtHna = "MMMM dd, yyyy 'at' HH:mm a"
}

extension Date {
    func stringWithFormat(_ format:DateFormat) -> String {
        return self.stringWithFormat(format.rawValue)
    }

    func stringWithFormat(_ formatString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        let str = self
        return dateFormatter.string(from: str)
    }
}

extension String {
    func dateWithFormat(_ formatString:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        let string = self
        return dateFormatter.date(from: string)
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}
