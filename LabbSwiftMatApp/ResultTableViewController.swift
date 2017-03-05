//
//  ResultTableViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-16.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit
import BEMCheckBox

class ResultTableViewController: UITableViewController {
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    @IBOutlet weak var compareButton: UIBarButtonItem!
    var data : [Food] = []
    var favorites : [Food] = []
    var selectedFoodItems : [Food?] = []
    var searchWord : String = ""
    let userDef : UserDefaults = UserDefaults.standard
    var favoriteMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compareButton.isEnabled = false
        if self.favoriteMode {
            self.loadFavoriteMode()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.favoriteMode {
            self.loadFavoriteMode()
        }
    }
    
    @IBAction func modeButton(_ sender: UIBarButtonItem) {
        if favoriteMode {
            self.setUpViewForSearchMode()
        } else {
            self.loadFavoriteMode()
        }
    }
    
    func loadFavoriteMode() {
        if let favlist : [Int] = userDef.array(forKey: "favorites") as! [Int]? {
            if favlist.count > 0 {
                NSLog("Favlist count: \(favlist.count)")
                self.favorites = ApiHelper.getSimpleFavoriteList(numberList: favlist)
                    var count = favorites.count
                    for (food) in favorites {
                        ApiHelper.getAllValuesForSpecificItem(food: food, block: {_ in
                            count -= 1
                            NSLog("Count: \(count)")
                            if count == 0 {
                                DispatchQueue.main.async {
                                    self.setUpViewForFavoriteMode()
                                }
                            }
                        })
                    }
            } else {
                favorites.removeAll()
                setUpViewForFavoriteMode()
            }
        } else {
            let list : [Int] = []
            userDef.set(list, forKey: "favorites")
            userDef.synchronize()
            setUpViewForFavoriteMode()
        }
    }
    
    func setUpViewForFavoriteMode() {
        self.favoriteMode = true
        self.title = "Favoriter"
        self.favoriteButton.title = "🔍"
        self.tableView.reloadData()
        NSLog("Favorite mode activated.")
    }
    
    func setUpViewForSearchMode() {
        self.favoriteMode = false
        self.title = "Sökresultat"
        self.favoriteButton.title = "⭐️"
        self.tableView.reloadData()
        NSLog("Search mode activated")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.favoriteMode {
            return favorites.count
        } else {
            return data.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableViewCell
        
        if self.favoriteMode {
            cell.searchItemTitle.text = favorites[indexPath.row].name
            if let energy = favorites[indexPath.row].energyValue {
                cell.searchItemEnergyValue.text = "\(energy) kcal"
            } else {
                ApiHelper.getAllValuesForSpecificItem(food: favorites[indexPath.row], block: {newFoodObject in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
                cell.searchItemEnergyValue.text = "-"
            }
            cell.food = favorites[indexPath.row]
        } else {
            cell.searchItemTitle.text = data[indexPath.row].name
            if let energy = data[indexPath.row].energyValue {
                cell.searchItemEnergyValue.text = "\(energy) kcal"
            } else {
                ApiHelper.getAllValuesForSpecificItem(food: data[indexPath.row], block: {newFoodObject in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
                cell.searchItemEnergyValue.text = "-"
            }
            cell.food = data[indexPath.row]
        }
        cell.rtvc = self
        var isChecked = false
        for selectedFood in selectedFoodItems {
            if selectedFood?.number == cell.food.number {
                isChecked = true
            }
        }
        if isChecked {
            cell.checkBox.on = true
        } else {
            cell.checkBox.on = false
        }
        return cell
    }

    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let dvc : DetailViewController = segue.destination as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if favoriteMode {
                    dvc.food = favorites[indexPath.row]
                } else {
                    dvc.food = data[indexPath.row]
                }
            }
        } else if segue.identifier == "compare" {
            let cvc : CompareViewController = segue.destination as! CompareViewController
            if let firstCompareFood = self.selectedFoodItems[0] {
                cvc.firstCompareFood = firstCompareFood
            }
            if let secondCompareFood = self.selectedFoodItems[1] {
                cvc.secondCompareFood = secondCompareFood
            }
        }
    }
}

class ResultTableViewCell : UITableViewCell {
    
    var food : Food!
    weak var rtvc : ResultTableViewController!
    
    @IBOutlet weak var searchItemTitle: UILabel!
    @IBOutlet weak var searchItemEnergyValue: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    @IBAction func boxChecked(_ sender: BEMCheckBox) {
        if sender.on {
            var isChecked = false
            for selectedFood in rtvc.selectedFoodItems {
                if food.number == selectedFood?.number {
                    isChecked = true
                }
            }
            
            if !isChecked {
                rtvc.selectedFoodItems.append(food)
                if rtvc.selectedFoodItems.count > 2 {
                    rtvc.selectedFoodItems.removeFirst()
                }
            }
            
        } else {
            for (index, selectedFood) in rtvc.selectedFoodItems.enumerated() {
                if food.number == selectedFood?.number {
                    rtvc.selectedFoodItems.remove(at: index)
                }
            }
        }
        
        if rtvc.selectedFoodItems.count == 2 {
            rtvc.compareButton.title = "⚖"
            rtvc.compareButton.isEnabled = true
        } else {
            rtvc.compareButton.title = "-"
            rtvc.compareButton.isEnabled = false
        }
        
        rtvc.tableView.reloadData()
        NSLog("\(rtvc.selectedFoodItems.count)")
        NSLog(food!.name!)
    }
}

