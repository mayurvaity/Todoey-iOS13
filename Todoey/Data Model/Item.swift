//
//  Item.swift
//  Todoey
//
//  Created by Mayur Vaity on 04/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? 
    //forming reverse relationship with Category
    //items mentioned below is the name of the varible from Category class (created for creating relationship)
    //parentCategory is the name of the relationship in Item class 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
