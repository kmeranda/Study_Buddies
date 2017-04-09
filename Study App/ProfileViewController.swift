//
//  ProfileViewController.swift
//  Pods
//
//  Created by Kelsey Meranda on 3/10/17.
//
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var profDisplayName: UILabel!
    @IBOutlet weak var profDisplayNameField: UITextField!
    @IBOutlet weak var profGradYear: UILabel!
    @IBOutlet weak var profGradYearField: UITextField!
    @IBOutlet weak var profClasses: UILabel!
    @IBOutlet weak var profClassesField: UITextField!
    @IBOutlet weak var saveData: UIButton!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    /*@IBAction func signOutAction(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "SigningOut", sender: nil)
    }*/
    
    override func viewDidLoad() {
        
        self.profDisplayNameField.isHidden = true
        self.profGradYearField.isHidden  = true
        self.profClassesField.isHidden = true
        self.saveData.isHidden = true
        
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.menuLeading.constant = -213    // extra 3 for dropshadow
        //self.menuView.layer.shadowOpacity = 1.0
        super.viewDidLoad()
        
        // get user auth
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        
        // get profile info
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["display_name"] as? String ?? ""
            let gradyear = value?["grad_year"] as? String ?? ""
            let coursename = value?["class_name"] as? String ?? ""
            let image = value?["prof_img"] as? String ?? ""
            // get ref to storage
            let storage = FIRStorage.storage()
            let storageRef = storage.reference().child("\(image)")
            
            storageRef.downloadURL(completion: { (url, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    guard let imageData = UIImage(data: data!) else { return }
                    
                    DispatchQueue.main.async {
                        self.profImage.image = imageData
                    }
                    
                }).resume()
                self.profImage.layer.cornerRadius = self.profImage.frame.size.height/2;
                self.profImage.layer.masksToBounds = true;
                self.profImage.layer.borderWidth = 0;
            
            })
            /*storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error ?? "")
                    return
                }
                self.profImage.image = UIImage(data: data!)

            }*/
            // populate page with user data
            self.profDisplayName.text = username
            self.profGradYear.text = gradyear
            self.profClasses.text = coursename
            
            
            /*let dbRef = storageRef.child(image)
            // Start the download (in this case writing to a file)
            let downloadTask = storageRef.write(toFile: image)
            
            // Observe changes in status
            downloadTask.observe(.resume) { snapshot in
                // Download resumed, also fires when the download starts
            }
            
            downloadTask.observe(.pause) { snapshot in
                // Download paused
            }
            
            downloadTask.observe(.progress) { snapshot in
                // Download reported progress
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
            }
            
            downloadTask.observe(.success) { snapshot in
                // Download completed successfully
            }
            
            // Errors only occur in the "Failure" case
            downloadTask.observe(.failure) { snapshot in
                guard let errorCode = (snapshot.error as? NSError)?.code else {
                    return
                }
                guard let error = FIRStorageErrorCode(rawValue: errorCode) else {
                    return
                }
                switch (error) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User cancelled the download
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // Another error occurred. This is a good place to retry the download.
                    break
                }
            }*/
            /*let imagesRef = storageRef.child(image)
            imagesRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print(error ?? "")
                } else {
                    let myImage: UIImage! = UIImage(data: data!)
                    self.profImage.image = myImage
                }
            }*/

            //let user = User.init(username: username) // dunno what this does
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            if let user = FIRAuth.auth()?.currentUser { // user already logged in
                self.performSegue(withIdentifier: "LoggingOut", sender: user)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        // set text of text field
        self.profDisplayNameField.text = self.profDisplayName.text
        self.profGradYearField.text  = self.profGradYear.text
        self.profClassesField.text = self.profClasses.text
        
        // make edit text field visible
        self.profDisplayNameField.isHidden = false
        self.profGradYearField.isHidden  = false
        self.profClassesField.isHidden = false
        self.saveData.isHidden = false
        
        // hide labels
        self.profDisplayName.isHidden = true
        self.profGradYear.isHidden  = true
        self.profClasses.isHidden = true
        
    }

    @IBAction func saveProfile(_ sender: UIButton) {
        
        // hide text fields
        self.profDisplayNameField.isHidden = true
        self.profGradYearField.isHidden  = true
        self.profClassesField.isHidden = true
        self.saveData.isHidden = true
        
        // make labels visible
        self.profDisplayName.isHidden = false
        self.profGradYear.isHidden  = false
        self.profClasses.isHidden = false
        
        // update label field
        self.profDisplayName.text = self.profDisplayNameField.text
        self.profGradYear.text  = self.profGradYearField.text
        self.profClasses.text = self.profClassesField.text
        
        // update database
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        ref.child("users").child(uid!).child("class_name").setValue(self.profClasses.text!)
        ref.child("users").child(uid!).child("display_name").setValue(self.profDisplayName.text!)
        ref.child("users").child(uid!).child("grad_year").setValue(self.profGradYear.text!)
    }
    
    @IBAction func openMenu(_ sender: Any) {
        print("open menu")
    }
}
