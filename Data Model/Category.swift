//
//  Category.swift
//  Todoey
//
//  Created by Jason Dubon on 5/11/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
    
}
