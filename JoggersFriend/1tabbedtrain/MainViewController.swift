//
//  MainViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    enum JoggingAppState {
        case normalJogging, timeJogging, distanceJogging, compareJogging, loitering
    }
    var joggingState = JoggingAppState.loitering
    
    @IBOutlet weak var mainScreenMainLabel: UILabel!
    @IBOutlet weak var startJogging: UIButton!
    //@IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var startTimeJogg: UIButton!
    @IBOutlet weak var startDistanceJogg: UIButton!
    @IBOutlet weak var startCompareJogg: UIButton!
    
    @IBAction func startNormalJogging(_ sender: Any) {
        print("startNormalJogging")
        joggingState = JoggingAppState.normalJogging
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![1] as! MapViewController
        tabBarController!.selectedIndex = 1
        svc.startNormalJogging()
    }
    
    @IBAction func startTimeJogging(_ sender: Any) {
        print("startTimeJogging")
        joggingState = JoggingAppState.timeJogging
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![1] as! MapViewController
        tabBarController!.selectedIndex = 1
        svc.startTimeJogging()
    }
    
    @IBAction func startDistanceJoggin(_ sender: Any) {
        print("startDistanceJogging")
        joggingState = JoggingAppState.distanceJogging
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![1] as! MapViewController
        tabBarController!.selectedIndex = 1
        svc.startDistanceJogging()
    }
    
    @IBAction func startCompareJoggin(_ sender: Any) {
        // TODO
        // Go to saved tab view
        // note that if user wants to start the compare jogging user needs to load a jogg
        //print("startCompareJogging")
        //let barViewControllers = self.tabBarController?.viewControllers
        //let svc = barViewControllers![1] as! MapViewController
        tabBarController!.selectedIndex = 3
        //svc.startDistanceJogging()
    }
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Main", image: UIImage(named: "ic_home_18pt"), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //mainImageView.image = UIImage(named: ("late-for-work-running"))
        //self.view.addSubview(mainImageView)
        //mainScreenMainLabel.text = "666 km/h"
        startJogging.layer.cornerRadius = 5.0
        startTimeJogg.layer.cornerRadius = 5.0
        startDistanceJogg.layer.cornerRadius = 5.0
        startCompareJogg.layer.cornerRadius = 5.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

