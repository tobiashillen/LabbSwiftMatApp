//
//  ViewController.swift
//  LabbSwiftMatApp
//
//  Created by Tobias Hillén on 2017-02-14.
//  Copyright © 2017 Tobias Hillén. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var apple1: UIImageView!
    @IBOutlet weak var apple2: UIImageView!
    @IBOutlet weak var apple3: UIImageView!
    @IBOutlet weak var apple4: UIImageView!
    @IBOutlet weak var apple5: UIImageView!
    @IBOutlet weak var apple6: UIImageView!
    
    var dynamicAnimator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTitle()
        animateDynamicApples()
    }
    
    func animateTitle() {
        let titleLabelStart : CGPoint = CGPoint(x: titleLabel.center.x, y: 0)
        let titleLabelEnd : CGPoint = titleLabel.center
        titleLabel.center = titleLabelStart
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.center = titleLabelEnd
        })
    }
    
    func animateDynamicApples() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [apple1, apple2, apple3, apple4, apple5, apple6])
        collision = UICollisionBehavior(items: [apple1, apple2, apple3, apple4, apple5, apple6])
        snap = UISnapBehavior(item: apple1, snapTo: view.center)
        snap.damping = 2
        
        dynamicAnimator.addBehavior(snap)
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
        
        //Fades small apples laying on top of the big apple if present.
        UIView.beginAnimations("Fade out small apples", context: nil)
        UIView.setAnimationDuration(1)
        UIView.setAnimationDelay(3)
        apple2.alpha=0
        apple3.alpha=0
        apple4.alpha=0
        apple5.alpha=0
        apple6.alpha=0
        UIView.commitAnimations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC : ResultTableViewController = segue.destination as! ResultTableViewController
        if let searchWord = searchField.text {
            resultVC.searchWord = searchWord
            let query : String = "?query=\(searchWord)"
            ApiHelper.getData(searchQuery: query, block: {downloadedData in
                DispatchQueue.main.async {
                    resultVC.data = downloadedData
                    resultVC.tableView.reloadData()
                }
            })
            
        }
    }
}
