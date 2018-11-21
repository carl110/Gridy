//
//  Dictionary+extensions.swift
//  Gridy
//
//  Created by Carl Wainwright on 09/11/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary
{
    init<K: Sequence, V: Sequence>(keys: K, values: V) where K.Element == Key, V.Element == Value, K.Element: Hashable {
        self.init()
        for (key, value) in zip(keys, values) {
            self[key] = value
        }
    }
}

extension Array where Element: Any {
    //create disctionary from array with key as Int
    var toDictionary: [Int:Element] {
        var dictionary: [Int:Element] = [:]
        for (index, element) in enumerated() {
            dictionary[index] = element
        }
        return dictionary
    }
    
}
