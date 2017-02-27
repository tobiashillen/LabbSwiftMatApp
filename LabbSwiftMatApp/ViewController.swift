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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
