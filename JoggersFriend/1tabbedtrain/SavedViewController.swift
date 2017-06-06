//
//  SavedViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {
    
    /* 
     TODO
     Change to the table view
     Load the saved data
     User can load the data of some trip and it is showed in the map and in the info view
     TODO someday
     User can upload summary to facebook
     User can load the data and start compare tracking
    */
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: "ic_attachment_18pt"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
