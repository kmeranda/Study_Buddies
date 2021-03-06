//
//  ViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/8/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    /* LoginView Controller */
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser { // user already logged in
            self.performSegue(withIdentifier: "LoggingIn", sender: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountAction(_ sender: UIButton) {}   // for segue

    
    @IBAction func loginAction(_ sender: UIButton) {
        
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Oops!", message: "Please make sure to enter an email and password before trying to make an account.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "LoggingIn", sender: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
        }

    }
    
    /* @IBAction func logoutAction(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        self.usernameLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    } */
    
}

