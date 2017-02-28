//
//  ApiHelper.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-20.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import Foundation

class ApiHelper {
    
    static let url : String = "http://www.matapi.se/foodstuff"
    static let jsonOptions = JSONSerialization.ReadingOptions()
    
    static func getAllValuesForSpecificItem (food : Food, block:@escaping (Void) -> Void) {
        let number = food.number
        if let url = URL(string: "\(self.url)/\(number)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {
                (maybeData: Data?, response: URLResponse?, error: Error?) in
                if let actualData = maybeData {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String : Any] {
                            
                            if food.name == nil {
                                let name = parsed["name"] as! String
                                food.name = name
                            }
                            
                            var nutrientValues = parsed["nutrientValues"] as! [String : Any]
                            
                            let energyValue = nutrientValues["energyKcal"] as! Int
                            //print("Energy Value:\(energyValue)")
                            food.energyValue = energyValue
                            
                            let fat = nutrientValues["fat"] as! Int
                            //print("Fat:\(fat)")
                            food.fat = fat
                            
                            let protein = nutrientValues["protein"] as! Int
                            //print("Protein:\(fat)")
                            food.protein = protein
                            
                            let carbohydrates  = nutrientValues["carbohydrates"] as! Int
                            //print("carbohydrates :\(carbohydrates )")
                            food.carbohydrates  = carbohydrates
                            block()
                        } else {
                            NSLog("Failed to cast from json.")
                        }
                    }
                    catch let parseError {
                        NSLog("Failed to parse json: \(parseError)")
                    }
                    
                } else {
                    NSLog("No data received.")
                }
                
            }
            task.resume()
        }
    }


    static func getData(searchQuery : String, block : @escaping ([Food]) -> Void){
        var data : [Food] = []
        if let safeUrlString = "\(self.url)\(searchQuery)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: safeUrlString) {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {
                (maybeData: Data?, response: URLResponse?, error: Error?) in
                if let actualData = maybeData {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [[String:Any]] {
                            
                            //print(parsed)
                            
                            for item in parsed {
                                let name = item["name"] as! String
                                let number = item["number"] as! Int
                                let food : Food = Food(name: name, number: number)
                                data.append(food)
                            }
                            
                            block(data)
                        } else {
                            NSLog("Failed to cast from json.")
                        }
                    }
                    catch let parseError {
                        NSLog("Failed to parse json: \(parseError)")
                    }
                    
                } else {
                    NSLog("No data received.")
                }
            }
            task.resume()
            
        } else {
            NSLog("Failed to create url.")
        }
    }
    
    static func getSimpleFavoriteList (numberList : [Int]) -> [Food] {
        var simpleFavoriteList : [Food] = []
        for num in numberList {
            let food = Food(number: num)
            simpleFavoriteList.append(food)
        }
        return simpleFavoriteList
    }

    
}

/*
 // -----------WORK IN PROGRESS -FÖRSÖK TILL UTFAKTORERING-----------------
 static func parseJson(data : Data , block : @escaping ([Food]) -> Void) {
 do {
 if let parsed = try JSONSerialization.jsonObject(with: data, options: jsonOptions) as? [[String:Any]] {
 
 print(parsed)
 var data : [Food] = []
 
 for item in parsed {
 let name = item["name"] as! String
 let number = item["number"] as! Int
 let food : Food = Food(name: name, number: number)
 data.append(food)
 }
 
 block(data)
 } else {
 NSLog("Failed to cast from json.")
 }
 }
 catch let parseError {
 NSLog("Failed to parse json: \(parseError)")
 }
 }
 
 static func getData<T>(url : URL, block : @escaping (T) -> Void){
 
 
 let request = URLRequest(url: url)
 let task = URLSession.shared.dataTask(with: request) {
 (maybeData: Data?, response: URLResponse?, error: Error?) in
 if let actualData = maybeData {
 parseJson(data: actualData, block: block)
 } else {
 NSLog("No data received.")
 }
 }
 task.resume()
 }
 
 static func getSearchResults (searchWord : String, block:@escaping ([String:Any]) -> Void) {
 let searchQuery = "?query=\(searchWord)"
 if let safeUrlString = "\(self.url)\(searchQuery)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
 let url = URL(string: safeUrlString) {
 self.getData(url: url, block: block)
 
 } else {
 NSLog("Failed to create url.")
 }
 }
 
 
 ////
 
 
 static func setEnergyValue(food : Food, block:@escaping (Int) -> Void) {
 let number = food.number
 if let url = URL(string: "\(self.url)/\(number)?nutrient=energyKcal") {
 let request = URLRequest(url: url)
 let task = URLSession.shared.dataTask(with: request) {
 (maybeData: Data?, response: URLResponse?, error: Error?) in
 if let actualData = maybeData {
 let jsonOptions = JSONSerialization.ReadingOptions()
 do {
 if let parsed = try JSONSerialization.jsonObject(with: actualData, options: jsonOptions) as? [String : Any] {
 var nutrientValues = parsed["nutrientValues"] as! [String : Any]
 let energyValue = nutrientValues["energyKcal"] as! Int
 print("Energy Value:\(energyValue)")
 block(energyValue)
 
 } else {
 NSLog("Failed to cast from json.")
 }
 }
 catch let parseError {
 NSLog("Failed to parse json: \(parseError)")
 }
 
 } else {
 NSLog("No data received.")
 }
 
 }
 task.resume()
 }
 }
 */



