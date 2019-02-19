//
//  Category.swift
//  ToDo
//
//  Created by Nishit on 18/02/19.
//  Copyright © 2019 Nishit. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    // making relationship forward is same as declaring empty array syntax: let array1 = Array<Int>()
}
