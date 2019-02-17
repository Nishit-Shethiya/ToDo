//
//  Item.swift
//  ToDo
//
//  Created by Nishit on 15/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import Foundation

class Item: Codable {               // By conforming to Codable is equivalent to both Encodable & Decodable
    var title: String = ""
    var done: Bool = false
}
