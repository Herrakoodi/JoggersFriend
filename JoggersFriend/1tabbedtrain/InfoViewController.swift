//
//  InfoViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    /*
     TODO
     Show important info of the trip currently going on or loaded
     */
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "ic_info_18pt"), tag: 1)
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
