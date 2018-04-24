//
//  UserViewController.swift
//  Homeless Shelter
//
//  Created by Johnny Maroun on 4/18/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class UserViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var findShelterButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    var ref:FIRDatabaseReference?

    var databaseHandle:FIRDatabaseHandle?
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //Set the firebase reference
        ref = FIRDatabase.database().reference()

        // Retrieve the posts and listen for changes
        databaseHandle = ref?.child("shelter").observe(.childAdded, with: { (snapshot) in
            
//            let annotation = MKPointAnnotation()
//            let lat =  snapshot.childSnapshot(forPath: "latitude")
//            let long = snapshot.childSnapshot(forPath: "longitude")
//            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            self.map.addAnnotation(annotation)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
            
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func findShelterTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "shelterListSegue", sender: nil)
    }
}
