//
//  ResultTableViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-16.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit

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
}

class ResultTableViewCell : UITableViewCell {
    
    @IBOutlet weak var searchItemTitle: UILabel!
    @IBOutlet weak var searchItemEnergyValue: UILabel!
}

class ResultTableViewController: UITableViewController {
    
    var data : [Food] = []
    var favorites : [Food] = []
    var searchWord : String = ""
    let userDef : UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let favlist : [Int] = userDef.array(forKey: "favorites") as! [Int]? {
            NSLog("Favlist count: \(favlist.count)")
        } else {
            NSLog("Failed to set favlist")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableViewCell
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
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc : DetailViewController = segue.destination as! DetailViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            dvc.food = data[indexPath.row]
        }
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
