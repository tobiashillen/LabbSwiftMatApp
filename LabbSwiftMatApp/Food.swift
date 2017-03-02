//
//  Food.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-03-02.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import Foundation

class Food {
    var name : String?
    var number : Int
    var energyValue : Int?
    var protein : Int?
    var fat : Int?
    var carbohydrates : Int?
    
    init(number : Int) {
        self.number = number
    }
    
    init(name : String, number : Int) {
        self.name = name
        self.number = number
    }
    
    var healthValue : Int {
        var value = 0
        if let energyValue = self.energyValue,
            let protein = self.protein,
            let fat = self.fat {
            value = (energyValue + (protein*15))
            if fat > 0 {
                value = value/fat
            } else {
                value *= 2
            }
        }
        return value
    }
}
