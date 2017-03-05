//
//  DetailViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-17.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var healthValueLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var food : Food?
    var isSavedToFavorites : Bool?
    var color : UIColor?
    let userDef : UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color = (favoriteButton.titleLabel?.textColor)!
        if let savedImage = UIImage(contentsOfFile: imagePath) {
            foodImage.image = savedImage
        } else {
            NSLog("No image to load from: \(imagePath)")
        }
        checkFavoritesForCurrentFood()
        loadAllData()
    }
    
    func checkFavoritesForCurrentFood() {
        var foundInFavorites = false
        if let currentFoodNumber = food?.number {
            if let favoritesNumberList : [Int] = userDef.array(forKey: "favorites") as? [Int] {
                for number in favoritesNumberList {
                    if number == currentFoodNumber {
                        foundInFavorites = true
                        NSLog("Current food object is already in favorites list.")
                    }
                }
                if foundInFavorites {
                    favoriteButton.setTitle("Ta bort från favoriter", for: .normal)
                    isSavedToFavorites = true
                } else {
                    favoriteButton.setTitle("Spara som favorit", for: .normal)
                    isSavedToFavorites = false
                }
            } else {
                let list : [Int] = []
                userDef.set(list, forKey: "favorites")
                userDef.synchronize()
                favoriteButton.setTitle("Spara som favorit", for: .normal)
                isSavedToFavorites = false
            }
        } else {
            NSLog("Unable to load current food number.")
        }
    }
    
    //  Setting all views with data from Food-object. Sending new API-request if any values are missing.
    func loadAllData () {
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
            fatLabel.text = "Fett: \(fat) %"
            proteinLabel.text = "Protein: \(protein) %"
            carbohydratesLabel.text = "Kolhydrater: \(carbohydrates) %"
            healthValueLabel.text = "Nyttighetsvärde: \(food!.healthValue)"
            NSLog("DetailView: Data set to views")
        } else {
            energyLabel.text = "Energivärde: Laddar..."
            fatLabel.text = "Fett: Laddar..."
            proteinLabel.text = "Protein: Laddar..."
            carbohydratesLabel.text = "Kolhydrater: Laddar..."
            healthValueLabel.text = "Nyttighetsvärde: Laddar..."
            ApiHelper.getAllValuesForSpecificItem(food: food!, block: {_ in
                DispatchQueue.main.async {
                    NSLog("DetailView: Data from API recieved.")
                    self.loadAllData()
                }
            })
            NSLog("DetailView: Waiting for data from API.")
        }
    }
    
    @IBAction func saveOrDeleteFavorite(_ sender: UIButton) {
        if let saved = isSavedToFavorites {
            if saved {
                deleteFromFavorite()
            } else {
                saveToFavorites()
            }
        } else {
            NSLog("Unable to save favorite.")
        }
    }
    
    func deleteFromFavorite() {
        if var favoritesNumberList : [Int] = userDef.array(forKey: "favorites") as? [Int],
            let currentFoodNumber = food?.number {
                for (index, number) in favoritesNumberList.enumerated() {
                    if number == currentFoodNumber {
                        favoriteButton.setTitle("Spara som favorit", for: .normal)
                        favoritesNumberList.remove(at: index)
                        isSavedToFavorites = false
                        userDef.set(favoritesNumberList, forKey: "favorites")
                        userDef.synchronize()
                        NSLog("Removed object from favorites.")
                    }
            }
        } else {
            NSLog("Unable to save favorite.")
        }
    }
    
    func saveToFavorites() {
        if var favList : [Int] = userDef.array(forKey: "favorites") as? [Int] {
            favList.append(food!.number)
            userDef.set(favList, forKey: "favorites")
            userDef.synchronize()
            isSavedToFavorites = true
            favoriteButton.setTitle("Ta bort från favoriter", for: .normal)
            NSLog("New favorite food saved: \(food!.name!)")
        } else {
            if let number = food?.number {
                var favList : [Int] = []
                favList.append(number)
                userDef.set(favList, forKey: "favorites")
                userDef.synchronize()
                favoriteButton.setTitle("Ta bort från favoriter", for: .normal)
                isSavedToFavorites = true
                NSLog("First favorite food saved: \(food!.name!)")
            } else {
                NSLog("Failed to save favorite food.")
            }
        }

    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        else {
            NSLog("No image source available.")
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        if let imageData = UIImagePNGRepresentation(image) {
            do {
                let url = URL(fileURLWithPath: imagePath)
                try imageData.write(to: url)
                NSLog("Png image saved to: \(imagePath)")
            }
            catch let error {
                NSLog("Failed to save png image data: \(error)")
            }
        }
        foodImage.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        NSLog("Image picker dismissed.")
    }
    
    var imagePath : String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let documentsDirectory = paths.first {
            return documentsDirectory.appending("/\(food!.number).png")
        } else {
            fatalError("Could not load image path.")
        }
    }
}
