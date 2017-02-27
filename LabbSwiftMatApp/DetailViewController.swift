//
//  DetailViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-17.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var food : Food?
    var color : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color = (favoriteButton.titleLabel?.textColor)!
        loadData()
    }
    
    //  Setting all views with data from Food-object. Sending new API-request if any values are missing.
    func loadData () {
        if let name = food?.name {
            detailTitleLabel.text = name
        } else {
            NSLog("DetailView: Failed to load title.")
        }
        
        if let energy = food?.energyValue,
            let fat = food?.fat,
            let protein = food?.protein,
            let carbohydrates = food?.carbohydrates {
            energyLabel.text = "Energivärde: \(energy) kcal"
            fatLabel.text = "Fett: \(fat)"
            proteinLabel.text = "Protein: \(protein)"
            carbohydratesLabel.text = "Kolhydrater: \(carbohydrates)"
            NSLog("DetailView: Data set to views")
            self.enableFavoriteButton()
        } else {
            energyLabel.text = "Energivärde: Laddar..."
            fatLabel.text = "Fett: Laddar..."
            proteinLabel.text = "Protein: Laddar..."
            carbohydratesLabel.text = "Kolhydrater: Laddar..."
            ApiHelper.getAllValuesForSpecificItem(food: food!, block: {_ in
                DispatchQueue.main.async {
                    NSLog("DetailView: Data from API recieved.")
                    self.loadData()
                }
            })
            NSLog("DetailView: Waiting for data from API.")
            self.disableFavoriteButton()
        }

    }
    
    func disableFavoriteButton() {
        favoriteButton.setTitleColor(UIColor .lightGray, for: .normal)
        favoriteButton.isEnabled = false
    }
    
    func enableFavoriteButton() {
        favoriteButton.setTitleColor(color, for: .normal)
        favoriteButton.isEnabled = true
    }
    
    @IBAction func saveFavorite(_ sender: UIButton) {
        let userDef : UserDefaults = UserDefaults.standard
        if var favList : [Int] = userDef.array(forKey: "favorites") as? [Int] {
            favList.append(food!.number)
            userDef.set(favList, forKey: "favorites")
            userDef.synchronize()
            NSLog("New favorite food saved: \(food!.name!)")
        } else {
            if let number = food?.number {
                var favList : [Int] = []
                favList.append(number)
                userDef.set(favList, forKey: "favorites")
                userDef.synchronize()
                NSLog("First favorite food saved: \(food!.name!)")
            } else {
                NSLog("Failed to save favorite food.")
            }
        }
        sender.setTitleColor(UIColor .lightGray, for: .normal)
        sender.isEnabled = false
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
