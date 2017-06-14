//
//  MapViewController.swift
//  1tabbedtrain
//
//  Created by Janne Mäkinen on 01/06/2017.
//  Copyright © 2017 Janne Mäkinen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,
        CLLocationManagerDelegate,
        MKMapViewDelegate {
    
    /*
     TODOS:
     - handle location tracking more carefully (in case of errors)
     - maybe better NSLocationWhenInUseUsageDescription than "This app needs location priviledges" needed?
     - is JoggingState needed both in the main view and in the map view?
        -> a class or struct that has the state? (MVC)
        -> and/or a class of trip?
     - traslate miles/hour to meters/hour
     */
    
    /*
     - known bugs and/or abnormalities
     - starting normal jogging without stopping looks a bit funny
     - gps seems to be a really slow with iPad Mini
     */
    
    enum JoggingAppState {
        case normalJogging, timeJogging, distanceJogging, compareJogging, loitering
    }
    var joggingState = JoggingAppState.loitering
    
    @IBOutlet weak var stopStartButton: UIButton!
    @IBOutlet weak var mapViewLabel: UILabel!
    @IBOutlet weak var mapViewLabel2: UILabel!
    @IBOutlet weak var mapViewLabel3: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    
    var polyline:MKGeodesicPolyline = MKGeodesicPolyline()
    var wholePolyline:MKGeodesicPolyline = MKGeodesicPolyline()
    
    var latitudeLocation = String()
    var longitudeLocation = String()
    var joggersDistance = 0
    var trackingIsOngoing = false
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var locationStorage: [CLLocation] = []
    
    // Authors View Controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "ic_my_location_18pt"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // change button similar to main menu - > stack view...
        let myColor : UIColor = UIColor( red: 0.4, green: 0.4, blue:0.4, alpha: 1.0 )
        stopStartButton.layer.borderColor = myColor.cgColor
        stopStartButton.layer.masksToBounds = true
        stopStartButton.layer.borderWidth = 1
        stopStartButton.layer.cornerRadius = 10.0
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()        
        startLocation = nil
        
        theMap.showsUserLocation = true
        theMap.delegate = self
        
        showJoggingState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        print("@IBAction func startStopButtonPressed(_ sender: Any)")
        startLocation = nil
        
        if (trackingIsOngoing) {
            stopTrackingAndAskSaving()
        }
        else {
            /*print("locationManager.startUpdatingLocation()")
            locationManager.startUpdatingLocation()
            trackingIsOngoing = true
            theMap.showsUserLocation = true
            locationStorage.removeAll()*/
            startNormalJogging()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
    
        if (trackingIsOngoing) {
            let latestLocation: CLLocation = locations[locations.count - 1]
            locationStorage.append(latestLocation)

            latitudeLocation = String(format: "%.4f",
                                      latestLocation.coordinate.latitude)
            
            longitudeLocation = String(format: "%.4f",
                                       latestLocation.coordinate.longitude)
            
            mapViewLabel2.text = latitudeLocation
            mapViewLabel3.text = longitudeLocation
            
            if startLocation == nil {
                startLocation = latestLocation
            }
            
            if (locationStorage.count == 1) {
                let currentLocation = CLLocationCoordinate2DMake(latestLocation.coordinate.latitude, latestLocation.coordinate.longitude)
                theMap.setCenter(currentLocation, animated: true)
            }
            
            addTheLineTravelled()
            
            // 5 for so that we see two different animations (transition&zoom->zoom)
            // good for simulator
            // a waaay too slow for real life
            if (locationStorage.count == 1) {
                let regionRadius: CLLocationDistance = 6000
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(latestLocation.coordinate,
                                                                          regionRadius * 2.0, regionRadius * 2.0)
                theMap.setRegion(coordinateRegion, animated: true)
            }

            if (locationStorage.count > 2) {
                let prevLocation: CLLocation = locationStorage[locationStorage.count - 2]
                let distanceBetween = Int(latestLocation.distance(from: prevLocation))
                joggersDistance += distanceBetween
                mapViewLabel.text = String(joggersDistance)
                
                let barViewControllers = self.tabBarController?.viewControllers
                let svc = barViewControllers![2] as! InfoViewController
                
                // Quick hack
                // Crashes if Info View has not been constructed
                if (locationStorage.count==3) {
                    tabBarController!.selectedIndex = 2
                    // checking for inccorrect measures
                    if (latestLocation.speed>0&&latestLocation.speed<300) {
                        svc.speedLabel.text = String(latestLocation.speed)
                    }
                }
                if (locationStorage.count>3) {
                    // checking for inccorrect measures
                    if (latestLocation.speed>0&&latestLocation.speed<300) {
                        svc.speedLabel.text = String(latestLocation.speed)
                    }
                }
                
                
            }
            
            /*let testl: CLLocation = locationStorage[locationStorage.count]
            let mikalie1 = testl.altitude
            let mikalie2 = testl.coordinate
            let mikalie3 = testl.course
            let mikalie4 = testl.horizontalAccuracy
            let mikalie5 = testl.speed
            let mikalie6 = testl.timestamp
            let mikalie7 = testl.verticalAccuracy
            */
            
            let kountti = locationStorage.count
            print(kountti)
            
            // TODO
            // soem data to the main view?
            // maybe speed to main label?
            // let barViewControllers = self.tabBarController?.viewControllers
            // let svc = barViewControllers![0] as! MainViewController
            // svc.mainScreenMainLabel.text = String(joggersDistance)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Location Manager trows on error!")
        print(error)
    }
    
    func showJoggingState() {
        switch joggingState {
        case .normalJogging:
            print("State of Jogging App is: NORMAL")
        case .timeJogging:
            print("State of Jogging App is: TIME")
        case .distanceJogging:
            print("State of Jogging App is: DISTANCE")
        case .compareJogging:
            print("State of Jogging App is: COMPARE")
        case .loitering:
            print("State of Jogging App is: LOITERING")
        }
    }
    
    func startNormalJogging() {
        
        // Ask if user wants to start tracking the jogging?
        
        let refreshAlert = UIAlertController(title: "Let's Jogg", message: "Start Normal Jogging? ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            print("ok pressed")
            print("Starting Normal Jogging")
            self.removeOldLineFromTheMap()
            self.locationStorage.removeAll()
            self.joggersDistance = 0
            self.joggingState = JoggingAppState.normalJogging
            self.trackingIsOngoing = true
            self.theMap.showsUserLocation = true
            self.showJoggingState()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("cancel pressed")
            print("Keeping the previous state")
            self.showJoggingState()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        showJoggingState()
    }
    
    func startTimeJogging() {
        
        // TODO
        // Ask if user wants to start the time jogging
        
        print("MapViewController:Starting Time Jogging")
        joggingState = JoggingAppState.timeJogging
        showJoggingState()
    }
    
    func startDistanceJogging() {
        
        // TODO
        // Ask if user wants to start the distance jogging
        
        print("MapViewController:Starting Distance Jogging")
        joggingState = JoggingAppState.distanceJogging
        showJoggingState()
    }
    
    func startCompareJogging() {
        // TODO
        // This is called from Saved view if user wants to start compare jogging
    }
    
    func stopTrackingAndAskSaving() {
        
        // Start/Stop pressed 
        // Do user wants to stop jogging or not?
 
        let refreshAlert = UIAlertController(title: "Let's Jogg", message: " Stop Jogging? ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            print("ok pressed")
            print("stopping jogging")
            self.joggingState = JoggingAppState.loitering
            self.trackingIsOngoing = false
            self.theMap.showsUserLocation = false
            self.showJoggingState()
            self.askIfUserWantsToSaveTheJogg()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("cancel pressed")
            print("Keeping the previous state")
            self.showJoggingState()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        showJoggingState()
    }
    
    func askIfUserWantsToSaveTheJogg() {
        
        // User wants to stop jogging
        // Ask if user wants to save the data?
        
        let refreshAlert = UIAlertController(title: "Let's Jogg", message: " Save the trip? ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            print("ok pressed")
            print("saving the data...")
            self.saveToJsonFile()
            
            
            // tämä puis!!!
            // let barViewControllers = self.tabBarController?.viewControllers
            // let svc = barViewControllers![3] as! SavedViewController
            //svc.mainScreenMainLabel.text = String(joggersDistance)
            // svc.checkAppFilesInSandboxDefaultDocumentDirectory(fileName: "joggerdata432")
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("saving cancelled")
            print("Keeping the previous state")
            self.showJoggingState()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        showJoggingState()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.init(colorLiteralRed: (242/255), green: (64/255), blue: (70/255), alpha: 1)
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        print("overlay is NOT MKPolyline")
        return polylineRenderer
        //return nil
    }
    
    func addTheLineTravelled() {
        if (locationStorage.count > 1){
            let sourceIndex = locationStorage.count - 1
            let destinationIndex = locationStorage.count - 2
            let c1 = locationStorage[sourceIndex].coordinate
            let c2 = locationStorage[destinationIndex].coordinate
            let a = [c1, c2]
            polyline = MKGeodesicPolyline(coordinates: a, count: 2)
            theMap.add(polyline)
        }
    }
    
    func removeOldLineFromTheMap() {
        self.theMap.overlays.forEach {
            if !($0 is MKUserLocation) {
                self.theMap.remove($0)
            }
        }
    }

    
    // testi // nimet uusiksi !!!
    // do timebased filename!
    // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
    func saveToJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Lokaatiot.json")
        
        //let personArray =  [["person": ["name": "Dani", "age": "24"]], ["person": ["name": "ray", "age": "70"]]]
        
        var GPSLista = [String]()
        
        // käydään läpi tallennetut lokaatiot
        for lokaatio in locationStorage {
            //print("Läpi käydään lokaatioita")
            GPSLista.append(String(lokaatio.coordinate.longitude))
            GPSLista.append(String(lokaatio.coordinate.latitude))
        }
        
        // Create a write-only stream
        guard let stream = OutputStream(toFileAtPath: fileUrl.path, append: false) else { return }
        stream.open()
        defer {
            stream.close()
        }
        
        // Transform array into data and save it into file
        var error: NSError?
        JSONSerialization.writeJSONObject(GPSLista, to: stream, options: [], error: &error)
        
        // Handle error
        if let error = error {
            print(error)
        }
    }
    
    // turha, mutta lukee JSONit kuten pitää
    // tästä mallia saved viewiin
    
    func retrieveFromJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("joggerdata432.json")
        
        // Create a read-only stream
        guard let stream = InputStream(url: fileUrl) else { return }
        stream.open()
        defer {
            stream.close()
        }
        
        // Read data from .json file and transform data into an array
        do {
            guard let personArray = try JSONSerialization.jsonObject(with: stream, options: []) as? [[String: [String: String]]] else { return }
            print(personArray) // prints [["person": ["name": "Dani", "age": "24"]], ["person": ["name": "ray", "age": "70"]]]
        } catch {
            print(error)
        }
    }
    
    
    
}

