//
//  ViewController.swift
//  Uber
//
//  Created by Johnny Maroun on 4/18/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var hardUser = "johnny"
    var hardPass = "maroun"
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func topTapped(_ sender: Any) {
        if (signUpMode == false && (userTextField.text == "" || passwordTextField.text == "")) {
            displayAlert(title: "Missing Information", message: "You must provide a valid email and password.")
        } else if (signUpMode && (userTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || emailTextField.text == "")) {
            displayAlert(title: "Missing Information", message: "You must provide your name, a username, email, and password.")
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
            emailTextField.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        } else {
            topButton.setTitle("Register", for: .normal)
            bottomButton.setTitle("cancel", for: .normal)
            adminLabel.isHidden = false
            userLabel.isHidden = false
            nameTextField.isHidden = false
            emailTextField.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
    }
    
    
}

