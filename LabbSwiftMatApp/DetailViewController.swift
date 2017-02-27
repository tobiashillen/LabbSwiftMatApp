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
    
    var food : Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let name = food?.name,
            let energy = food?.energyValue,
            let fat = food?.fat,
            let protein = food?.protein,
            let carbohydrates = food?.carbohydrates {
            detailTitleLabel.text = name
            energyLabel.text = "Energivärde: \(energy) kcal"
            fatLabel.text = "Fett: \(fat)"
            proteinLabel.text = "Protein: \(protein)"
            carbohydratesLabel.text = "Kolhydrater: \(carbohydrates)"
        } else {
            NSLog("DetailView: Failed to load data from Food-object")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
