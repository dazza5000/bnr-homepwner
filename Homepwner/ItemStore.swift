//
//  ItemStore.swift
//  Homepwner
//
//  Created by Darran Kelinske on 6/7/18.
//  Copyright © 2018 whereisdarran. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
}
