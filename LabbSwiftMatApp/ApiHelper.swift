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
                            food.energyValue = energyValue
                            let fat = nutrientValues["fat"] as! Int
                            food.fat = fat
                            let protein = nutrientValues["protein"] as! Int
                            food.protein = protein
                            let carbohydrates  = nutrientValues["carbohydrates"] as! Int
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
