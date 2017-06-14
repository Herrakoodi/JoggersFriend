//
//  SavedViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // Shoud I put all actions in top of the file?
    
    @IBAction func loadAskedFile(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: "File64823", message: "Load a trip file and show details?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            print("ok pressed")
            
            // call info views loaddetail -method
            // loaddetail calls saved views loadJSON method
            // and shows details
            
            // call map views loadatrip -method
            // loadatrip call saved views loadJSON method
            // and show a trip jogged
            
            // could be simpler solution?
            

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("cancel pressed")

        }))
        
        present(refreshAlert, animated: true, completion: nil)

        
    }
    @IBAction func deleteChosenFile(_ sender: Any) {
    }
    /* 
     TODO
     Change to the table view
     Load the saved data
     User can load the data of some trip and it is showed in the map and in the info view
     TODO someday
     User can upload summary to facebook
     User can load the data and start compare tracking
    */
    
    // Data model: These strings will be the data for the table view cells
    var animals: [String] = ["🎅🏻 Trip 1", "💆‍♂️ Trip 2", "👮🏻 Trip 3", "👻 Trip 4", "Trip 5",
                             "X Trip 6", "🦑 Trip 7", "fase2esf#F23 Trip 8", "🙏🏻 Trip 9", "👿 Trip 10", "🙊 Trip 11", "🐦 Trip 12", "🐤 Trip 13", "👻 Trip 14", "gdsgfwe Trip 15"]
    
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"

    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: "ic_attachment_18pt"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
        checkAppFilesInSandboxDefaultDocumentDirectory(fileName: "Lokaatiot")
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let myColor : UIColor = UIColor( red: 0.4, green: 0.4, blue:0.4, alpha: 1.0 )
        loadButton.layer.borderColor = myColor.cgColor
        loadButton.layer.masksToBounds = true
        loadButton.layer.borderWidth = 1
        loadButton.layer.cornerRadius = 10.0
        saveButton.layer.borderColor = myColor.cgColor
        saveButton.layer.masksToBounds = true
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 10.0
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.animals[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        print(self.animals[indexPath.row])
    }
    
    func checkAppFilesInSandboxDefaultDocumentDirectory(fileName: String) {
        
        print("SavedViewController::checkAppFilesInSandboxDefaultDocumentDirectory()")
        
        /*let path = Bundle.main.path(forResource: fileName, ofType: "json")
         do {
         let content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
         print(content)
         } catch {
         print("nil")
         }*/
        
        // oli forResource:
        //contentsOfFile:path!
        
        if let path : String = Bundle.main.path(forResource: fileName, ofType: "json") {
            print("json filu löytyi")
            if let data = NSData(contentsOfFile: path) {
                print("lokaatio filu löytyi")
                animals.append("lokaatiot")
                print(data)
            }
        }
        
    }

}
