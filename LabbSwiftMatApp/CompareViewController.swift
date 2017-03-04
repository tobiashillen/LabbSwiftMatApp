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
    @IBOutlet weak var graphView: UIView!
    
    @IBOutlet weak var firstFoodLabel: UILabel!
    
    @IBOutlet weak var secondFoodLabel: UILabel!
    
    var firstCompareFood : Food!
    var secondCompareFood : Food!
    var values : GKBarGraph!
    let green : UIColor = UIColor(red: 36/255, green: 143/255, blue: 0, alpha: 1)
    let red : UIColor = UIColor(red: 148/255, green: 17/255, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstFoodLabel.text = firstCompareFood.name!
        secondFoodLabel.text = secondCompareFood.name!
        
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
            return firstCompareFood.fat! as NSNumber!
        case 1:
            return secondCompareFood.fat! as NSNumber!
        case 2:
            return firstCompareFood.protein! as NSNumber!
        case 3:
            return secondCompareFood.protein! as NSNumber!
        case 4:
            return firstCompareFood.carbohydrates! as NSNumber!
        case 5:
            return secondCompareFood.carbohydrates! as NSNumber!
        default:
            return 0
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
            return ("\(firstCompareFood.fat!)")
        case 1:
            return ("\(secondCompareFood.fat!)")
        case 2:
            return ("\(firstCompareFood.protein!)")
        case 3:
            return ("\(secondCompareFood.protein!)")
        case 4:
            return ("\(firstCompareFood.carbohydrates!)")
        case 5:
            return ("\(secondCompareFood.carbohydrates!)")
        default:
            return ""
        }
    }
}
