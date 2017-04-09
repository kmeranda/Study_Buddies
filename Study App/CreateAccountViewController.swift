//
//  CreateAccountViewController.swift
//  Pods
//
//  Created by Kelsey Meranda on 3/8/17.
//
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var gradYearField: UITextField!
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var profPicField: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectProfPicAction(_ sender: UIButton) {
        //pick profile image
        //print("\n\nhihihi")
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            profPicField.isHidden = true
            
        } else{
            print("Something went wrong")
        }
    
        self.dismiss(animated: true, completion: nil)
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
                    // successfully create user
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    let uid = user?.uid
                    let storageRef = FIRStorage.storage().reference().child("\(uid!).png")
                    if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
                        
                        storageRef.put(uploadData, metadata: nil, completion: {
                            (metadata, error) in
                            
                            if error != nil {
                                print(error ?? "")
                                ref.child("users").child(uid!).child("class_name").setValue(self.classNameField.text!)
                                ref.child("users").child(uid!).child("display_name").setValue(self.usernameField.text!)
                                ref.child("users").child(uid!).child("email").setValue(self.emailField.text!)
                                ref.child("users").child(uid!).child("grad_year").setValue(self.gradYearField.text!)
                                return
                            }
                            if (metadata?.downloadURL()?.absoluteString != nil) {
                                ref.child("users").child(uid!).child("class_name").setValue(self.classNameField.text!)
                                ref.child("users").child(uid!).child("display_name").setValue(self.usernameField.text!)
                                ref.child("users").child(uid!).child("email").setValue(self.emailField.text!)
                                ref.child("users").child(uid!).child("grad_year").setValue(self.gradYearField.text!)
                                ref.child("users").child(uid!).child("prof_img").setValue("\(uid!).png")
                            }
                            
                        })
                    }
                //ref.child("users").child(uid!).child("class_name").setValue(self.classNameField.text!)
                //ref.child("users").child(uid!).child("display_name").setValue(self.usernameField.text!)
                //ref.child("users").child(uid!).child("email").setValue(self.emailField.text!)
                //ref.child("users").child(uid!).child("grad_year").setValue(self.gradYearField.text!)
                    sleep(2)
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
