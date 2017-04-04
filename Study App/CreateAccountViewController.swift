//
//  CreateAccountViewController.swift
//  Pods
//
//  Created by Kelsey Meranda on 3/8/17.
//
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var gradYearField: UITextField!
    @IBOutlet weak var classNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Oops!", message: "Please make sure to enter an email and password before trying to make an account.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if self.passwordField.text != self.passwordConfirmationField.text {
            let alertController = UIAlertController(title: "Oops!", message: "Passwords do not match. Please check that you entered them correctly.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
                if error == nil {
                    var ref: FIRDatabaseReference!
                    
                    ref = FIRDatabase.database().reference()
                    let uid = user?.uid
                ref.child("users").child(uid!).child("class_name").setValue(self.classNameField.text!)
                ref.child("users").child(uid!).child("display_name").setValue(self.usernameField.text!)
                    ref.child("users").child(uid!).child("email").setValue(self.emailField.text!)
                ref.child("users").child(uid!).child("grad_year").setValue(self.gradYearField.text!)

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

    @IBAction func logInAction(_ sender: Any) {
    }
}
