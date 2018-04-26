//
//  shelterDataViewController.swift
//  Homeless Shelter
//
//  Created by Johnny Maroun on 4/24/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class shelterDataViewController: UIViewController, UITextViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var shelterDetails: UITextView!
    @IBOutlet weak var reserveLabel: UILabel!
    @IBOutlet weak var numberInput: UITextField!
    
    var ref:FIRDatabaseReference?
    
    var address: String?
    var capacity: Double?
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var phone: String?
    var restrictions: String?
    var roomtype: String?
    var special: String?
    var shelterCount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var text = ""
        let detail = ["Address: " + address!,
                        "Capacity: " + String(Int(capacity!)),
                       "Name: " + name!,
                       "Phone: " + phone!,
                       "Restrictions: " + restrictions!,
                       "Room Type: " + roomtype!,
                       "Special: " + special!]
        for x in detail {
            text += x + "\n"
        }
        shelterDetails.text = text
        
        reserveLabel.text = "Reserve up to " + String(Int(capacity!)) + " people."
    }
    
    
    @IBAction func reserveTapped(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        if numberInput.text == nil || numberInput.text == "" || Int(numberInput.text!)! > Int(capacity!) {
            self.displayAlert(title: "Error", message: "You must input a valid reservation value.")
        } else {
            ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("occupiedBeds").setValue(Int(numberInput.text!))
            ref?.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).child("currentShelter").setValue(name)
            ref?.child("shelter").child(self.shelterCount!).child("capacity").setValue(Int(capacity! - Double(numberInput.text!)!))
        }

        print("Reserved Success")
        performSegue(withIdentifier: "reservedSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reservedSegue" {
            let reservedViewController = segue.destination as! UserViewController
            reservedViewController.reservedNumber = Int(numberInput.text!)
            reservedViewController.reservedName = name
            reservedViewController.currentBeds = Int(capacity!) - Int(numberInput.text!)!
            reservedViewController.releaseNumber = shelterCount
        }
    }
    

    @IBAction func cancelTapped(_ sender: Any) {
        performSegue(withIdentifier: "cancelShelterDataSegue", sender: nil)
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
