//
//  Item.swift
//  ToDo
//
//  Created by Nishit on 18/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // inverse relationship
}
