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

class UserViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var findShelterButton: UIButton!
    @IBOutlet weak var reservationTextView: UITextView!
    @IBOutlet weak var releaseButton: UIButton!
    
    var reserved: Bool?
    var reservedNumber: Int?
    var reservedName: String?
    var isSearching = false
    
    
    var locationManager = CLLocationManager()
    
    var ref:FIRDatabaseReference?
    var refHandle: UInt!

    var databaseHandle:FIRDatabaseHandle?
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingReservedVariables()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let location0 = CLLocationCoordinate2DMake(33.780174, -84.410142)
        let location1 = CLLocationCoordinate2DMake(33.784889, -84.408771)
        let location2 = CLLocationCoordinate2DMake(33.765162, -84.39265)
        let location3 = CLLocationCoordinate2DMake(33.76515, -84.392273)
        let location4 = CLLocationCoordinate2DMake(33.770949, -84.384433)
        let location5 = CLLocationCoordinate2DMake(33.762316, -84.43023)
        let location6 = CLLocationCoordinate2DMake(33.762316, -84.43023)
        let location7 = CLLocationCoordinate2DMake(33.759138, -84.371706)
        let location8 = CLLocationCoordinate2DMake(33.78823, -84.437988)
        let location9 = CLLocationCoordinate2DMake(33.731823, -84.367953)
        let location10 = CLLocationCoordinate2DMake(33.753594, -84.390429)
        let location11 = CLLocationCoordinate2DMake(33.747618, -84.394529)
        let location12 = CLLocationCoordinate2DMake(33.789157, -84.470567)
        let location13 = CLLocationCoordinate2DMake(33.747641, -84.328691)
        
        map.setRegion(MKCoordinateRegionMakeWithDistance(location0, 20000, 20000), animated: true)
            
        let pin0 = pinAnnotation(title: "My Sister's House", subtitle: "(404)367-2465", coordinate: location0)
        let pin1 = pinAnnotation(title: "The Atlanta Day Center for Women & Children", subtitle: "(404)588-4007", coordinate: location1)
        let pin2 = pinAnnotation(title: "The Shepherd's Inn", subtitle: "(404)367-2493", coordinate: location2)
        let pin3 = pinAnnotation(title: "Fuqua Hall", subtitle: "(404)367-2492", coordinate: location3)
        let pin4 = pinAnnotation(title: "Atlanta's Children Center", subtitle: "(404)892-3713", coordinate: location4)
        let pin5 = pinAnnotation(title: "Eden Village - Families", subtitle: "(404)874-2241", coordinate: location5)
        let pin6 = pinAnnotation(title: "Eden Village - Singles", subtitle: "(404)874-2241", coordinate: location6)
        let pin7 = pinAnnotation(title: "Our House", subtitle: "(404)522-6056", coordinate: location7)
        let pin8 = pinAnnotation(title: "Covenant House Georgia", subtitle: "(404)937-6957", coordinate: location8)
        let pin9 = pinAnnotation(title: "Nicholas House", subtitle: "(404)962-0793", coordinate: location9)
        let pin10 = pinAnnotation(title: "Hope Atlanta", subtitle: "(404)817-7070", coordinate: location10)
        let pin11 = pinAnnotation(title: "Gateway Center", subtitle: "(404)215-6600", coordinate: location11)
        let pin12 = pinAnnotation(title: "Young Adult Guidance Center", subtitle: "(404)792-7616", coordinate: location12)
        let pin13 = pinAnnotation(title: "Homes of Light", subtitle: "(844)289-8382", coordinate: location13)
        
        map.addAnnotation(pin0)
        map.addAnnotation(pin1)
        map.addAnnotation(pin2)
        map.addAnnotation(pin3)
        map.addAnnotation(pin4)
        map.addAnnotation(pin5)
        map.addAnnotation(pin6)
        map.addAnnotation(pin7)
        map.addAnnotation(pin8)
        map.addAnnotation(pin9)
        map.addAnnotation(pin10)
        map.addAnnotation(pin11)
        map.addAnnotation(pin12)
        map.addAnnotation(pin13)
        


//        // Retrieve the posts and listen for changes
//        databaseHandle = ref?.child("shelter").observe(.childAdded, with: { (snapshot) in
//
////            let annotation = MKPointAnnotation()
////            let lat =  snapshot.childSnapshot(forPath: "latitude")
////            let long = snapshot.childSnapshot(forPath: "longitude")
////            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
////            self.map.addAnnotation(annotation)
//        })
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let coord = manager.location?.coordinate {
//            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            map.setRegion(region, animated: true)
//            map.removeAnnotations(map.annotations)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = center
//            annotation.title = "Your Location"
//            map.addAnnotation(annotation)
//
//        }
//    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func findShelterTapped(_ sender: Any) {
        performSegue(withIdentifier: "shelterListSegue", sender: nil)
    }
    func settingReservedVariables() {
        ref = FIRDatabase.database().reference()
        
        refHandle = ref?.child("user").observe(.childAdded, with: {(snapshot) in
            if let currentEmail = FIRAuth.auth()?.currentUser?.email {
                if currentEmail == snapshot.childSnapshot(forPath: "email").value as? String {
                    let rNumber = snapshot.childSnapshot(forPath: "occupiedBeds").value
                    let rName = snapshot.childSnapshot(forPath: "currentShelter").value
                    self.reservedNumber = rNumber as? Int
                    self.reservedName = rName as? String
                    if self.reservedNumber != 0 {
                        self.reserved = true
                    } else {
                        self.reserved = false
                    }
                }
                if self.reservedNumber != nil && self.reservedName != nil && self.reserved != nil {
                    self.ref?.removeObserver(withHandle: self.refHandle)
                    self.setTextView()
                }

            }

        })
    }
    
    func setTextView() {
        if self.reserved! {
            let text1 = "You currently have a reservation at " + self.reservedName!
            let text2 = " with " + String(self.reservedNumber!) + " beds."
            let text3 = " To reserve at other shelters, you must release your current reservations."
            reservationTextView.text = text1 + text2 + text3
            releaseButton.isEnabled = true
            findShelterButton.isEnabled = false
        } else {
            reservationTextView.text = "You don't have any reservations currently."
            releaseButton.isEnabled = false
        }
    }
    
    var releaseNumber: String?
    var shelterName: String?
    var occupiedBeds: Int?
    var currentBeds: Int?
    var refHandle2: UInt!
    @IBAction func releaseTapped(_ sender: Any) {
        print("Why")
        ref = FIRDatabase.database().reference()
//        ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("currentShelter").setValue("NA")
//        ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("occupiedBeds").setValue(0)
//        ref?.child("shelter").child(releaseNumber!).child("capacity").setValue(occupiedBeds! + currentBeds!)
//
//        self.reserved = false
//        releaseButton.isEnabled = false
//        findShelterButton.isEnabled = true

        refHandle2 = ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "occupiedBeds" {
                self.occupiedBeds = snapshot.value as? Int
            }
            if snapshot.key == "currentShelter" {
                self.shelterName = snapshot.value as? String
            }
            
            if self.occupiedBeds != nil && self.shelterName != nil {
                self.ref?.removeObserver(withHandle: self.refHandle2)
                self.secondFunc()
            }
        })
    }
    
    func secondFunc() {
        print("Here")
        refHandle = ref?.child("shelter").observe(.childAdded, with: { (snapshot) in
            if snapshot.childSnapshot(forPath: "name").value as? String == self.shelterName {
                self.releaseNumber = snapshot.key
                self.currentBeds = snapshot.childSnapshot(forPath: "capacity").value as? Int
            }
            if self.releaseNumber != nil && self.shelterName != nil && self.occupiedBeds != nil && self.currentBeds != nil {
                self.ref?.removeObserver(withHandle: self.refHandle)
                self.updateValues()
            }
        })
    }
    func updateValues() {
        ref = FIRDatabase.database().reference()
        ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("currentShelter").setValue("NA")
        ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("occupiedBeds").setValue(0)
        ref?.child("shelter").child(releaseNumber!).child("capacity").setValue(occupiedBeds! + currentBeds!)
        reserved = false
        reservationTextView.text = "You don't have any reservations currently."
        findShelterButton.isEnabled = true
        releaseButton.isEnabled = false

    }

    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == nil || searchBar.text == "" {
//            isSearching = false
//            view.endEditing(true)
//            map.reloadInputViews()
//        } else {
//            isSearching = true
//            let text = searchBar.text
//            map = map.filter({($0.name?.localizedCaseInsensitiveContains(text!))!})
//            map.reloadInputViews()
//        }
//    }
    
    
    
    
    
    
    
    
}
