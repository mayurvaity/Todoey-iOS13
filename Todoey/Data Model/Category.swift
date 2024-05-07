//
//  Category.swift
//  Todoey
//
//  Created by Mayur Vaity on 04/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgcolor: String = ""
    
    //to define relationship with Item class
    let items = List<Item>()
    
}
