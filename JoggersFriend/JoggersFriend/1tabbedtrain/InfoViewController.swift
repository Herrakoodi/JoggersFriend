//
//  InfoViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var left1View: UIView!
    @IBOutlet weak var left2View: UIView!
    @IBOutlet weak var left3View: UIView!
    @IBOutlet weak var right1View: UIView!
    @IBOutlet weak var right2View: UIView!
    @IBOutlet weak var speedLabel: UILabel!
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
        
        let borderColor:CGColor = UIColor( red: 0.4, green: 0.4, blue:0.4, alpha: 1.0 ).cgColor
        self.left1View.layer.borderWidth = 0.5
        self.left1View.layer.borderColor = borderColor
        self.left2View.layer.borderWidth = 0.5
        self.left2View.layer.borderColor = borderColor
        self.left3View.layer.borderWidth = 0.5
        self.left3View.layer.borderColor = borderColor
        self.right1View.layer.borderWidth = 0.5
        self.right1View.layer.borderColor = borderColor
        self.right2View.layer.borderWidth = 0.5
        self.right2View.layer.borderColor = borderColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
