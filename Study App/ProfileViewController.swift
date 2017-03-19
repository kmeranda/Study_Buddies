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
    @IBOutlet weak var profGradYear: UILabel!
    @IBOutlet weak var profClasses: UILabel!
    @IBOutlet weak var menuLeading: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    var menuShowing = false
    
    @IBAction func signOutAction(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "SigningOut", sender: nil)
    }
    
    override func viewDidLoad() {
        self.menuLeading.constant = -213    // extra 3 for dropshadow
        self.menuView.layer.shadowOpacity = 1.0
        super.viewDidLoad()
        
        let user = FIRAuth.auth()?.currentUser
        /*var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let userID = user?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["display_name"] as? String ?? ""
            let gradyear = value?["grad_year"] as? String ?? ""
            let coursename = value?["class_name"] as? String ?? ""
            //let image = 
            //let groups =
            
            // populate page with user data
            self.profDisplayName.text = username
            self.profGradYear.text = gradyear
            self.profClasses.text = coursename
            
            //let user = User.init(username: username) // dunno what this does
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            if let user = FIRAuth.auth()?.currentUser { // user already logged in
                self.performSegue(withIdentifier: "LoggingOut", sender: user)
            }
        }*/
        
        
        let alertController = UIAlertController(title: "User Info", message: user?.uid, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openMenu(_ sender: Any) {
        if menuShowing {
            self.menuLeading.constant = -213 // extra 3 for the dropshadow
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        } else {
            self.menuLeading.constant = 0
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
                
            })
        }
        menuShowing = !menuShowing
    }
}
