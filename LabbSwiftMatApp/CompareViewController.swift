//
//  CompareViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-03-02.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit
import GraphKit

class CompareViewController: UIViewController, GKBarGraphDataSource {
    
    @IBOutlet weak var firstFoodLabel: UILabel!
    @IBOutlet weak var secondFoodLabel: UILabel!
    
    var firstCompareFood : Food!
    var secondCompareFood : Food!
    var values : GKBarGraph!
    let green : UIColor = UIColor(red: 36/255, green: 143/255, blue: 0, alpha: 1)
    let red : UIColor = UIColor(red: 148/255, green: 17/255, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextLabels()
        setUpGraph()
    }
    
    func setTextLabels() {
        if let firstName = firstCompareFood.name {
            firstFoodLabel.text = firstName
        } else {
            firstFoodLabel.text = "-"
        }
        if let secondName = secondCompareFood.name {
            secondFoodLabel.text = secondName
        } else {
            secondFoodLabel.text = ""
        }
    }
    
    func setUpGraph() {
        values = GKBarGraph(frame: CGRect(x: self.view.center.x, y: 0, width: 0, height: 240))
        self.view.addSubview(values)
        values.marginBar = 30
        values.dataSource = self
        values.draw()
    }
    
    public func numberOfBars() -> Int {
        return 6
    }
    
    public func valueForBar(at index: Int) -> NSNumber! {
        switch index {
        case 0:
            if let firstFat = firstCompareFood.fat {
                return firstFat as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        case 1:
            if let secondFat = secondCompareFood.fat {
                return secondFat as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        case 2:
            if let firstProtein = firstCompareFood.protein {
                return firstProtein as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        case 3:
            if let secondProtein = secondCompareFood.protein {
                return secondProtein as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        case 4:
            if let firstCarbohydrates = firstCompareFood.carbohydrates {
                return firstCarbohydrates as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        case 5:
            if let secondCarbohydrates = secondCompareFood.carbohydrates {
                return secondCarbohydrates as NSNumber!
            } else {
                return NSNumber(integerLiteral: 0)
            }
        default:
            return NSNumber(integerLiteral: 0)
        }
    }
    
    public func colorForBar(at index: Int) -> UIColor! {
        if index % 2 == 0{
            return self.green
        } else {
            return self.red
        }
        
        
    }
    
    public func animationDurationForBar(at index: Int) -> CFTimeInterval {
        return 1.0
    }
    
    public func titleForBar(at index: Int) -> String! {
        switch index {
        case 0:
            if let firstFat = firstCompareFood.fat {
                return ("\(firstFat) %")
            } else {
                return "-"
            }
        case 1:
            if let secondFat = secondCompareFood.fat {
                return ("\(secondFat) %")
            } else {
                return "-"
            }
        case 2:
            if let firstProtein = firstCompareFood.protein {
                return ("\(firstProtein) %")
            } else {
                return "-"
            }
        case 3:
            if let secondProtein = secondCompareFood.protein {
                return ("\(secondProtein) %")
            } else {
                return "-"
            }
        case 4:
            if let firstCarbohydrates = firstCompareFood.carbohydrates {
                return ("\(firstCarbohydrates) %")
            } else {
                return "-"
            }
        case 5:
            if let secondCarbohydrates = secondCompareFood.carbohydrates {
                return ("\(secondCarbohydrates) %")
            } else {
                return "-"
            }
        default:
            return "-"
        }
    }
}
