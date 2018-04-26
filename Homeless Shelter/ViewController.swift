//
//  ViewController.swift
//  Uber
//
//  Created by Johnny Maroun on 4/18/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = false
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
    }
    
    @IBAction func topTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if signUpMode == false {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password,
                                           completion: { (user, error) in
                                            if error != nil {
                                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                            } else {
                                                print("Log In Success")
                                                self.performSegue(withIdentifier: "userSegue", sender: nil)
                                            }
                    })
                } else {
                    if let name = nameTextField.text {
                        if let user = userTextField.text {
                            if emailTextField.text == "" || passwordTextField.text == "" || user == "" || name == "" {
                                displayAlert(title: "Missing Information", message: "You must provide an email, password, name, and username.")
                                
                            } else {
                                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                                    if error != nil {
                                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                                    } else {
                                        print("Sign Up Success")
                                        self.ref.child("user").child((user?.uid)!).child(("admin")).setValue(!self.riderDriverSwitch.isOn)
                                        self.ref.child("user").child((user?.uid)!).child(("currentShelter")).setValue("NA")
                                        self.ref.child("user").child((user?.uid)!).child(("email")).setValue(self.emailTextField.text)
                                        self.ref.child("user").child((user?.uid)!).child(("firstName")).setValue(self.nameTextField.text)
                                        self.ref.child("user").child((user?.uid)!).child(("lastName")).setValue(self.lastNameTextField.text)
                                        self.ref.child("user").child((user?.uid)!).child(("occupiedBeds")).setValue(0)
                                        self.ref.child("user").child((user?.uid)!).child(("username")).setValue(self.userTextField.text)
                                        print(self.riderDriverSwitch.isOn)
                                        self.performSegue(withIdentifier: "userSegue", sender: nil)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Not Registered? Click here", for: .normal)
            adminLabel.isHidden = true
            userLabel.isHidden = true
            nameTextField.isHidden = true
            lastNameTextField.isHidden = true
            emailTextField.isHidden = false
            riderDriverSwitch.isHidden = true
            userTextField.isHidden = true
            signUpMode = false
        } else {
            topButton.setTitle("Register", for: .normal)
            bottomButton.setTitle("cancel", for: .normal)
            adminLabel.isHidden = false
            userLabel.isHidden = false
            nameTextField.isHidden = false
            lastNameTextField.isHidden = false
            emailTextField.isHidden = false
            riderDriverSwitch.isHidden = false
            userTextField.isHidden = false
            signUpMode = true
        }
    }
    
    
}

