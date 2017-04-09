//
//  NewGroupViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 4/8/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation
import Firebase

class NewGroupViewController : UIViewController {
    
    //@IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var privacyField: UISegmentedControl!
    @IBOutlet weak var member1Field: UITextField!
    @IBOutlet weak var member2Field: UITextField!
    @IBOutlet weak var member3Field: UITextField!
    
    override func viewDidLoad() {
    }
    
    @IBAction func privacyDescriptionPopUp(_ sender: Any) {
        let alertController = UIAlertController(title: "Group Privacy Settings", message: "Public Groups can be seen by everyone.\n\nProtected Groups can be seen by the friends of members of the group.\n\nPrivate Groups can only be seen by members of the group.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createNewGroup(_ sender: UIButton) {
        // groups must have a name
        if self.groupNameField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please make sure to enter a group name before trying to make a group.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // create dictionary of members
        let ref = FIRDatabase.database().reference()
        var mems : [String : Any] = [:]
        // user is the first member of the groups
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        mems["1"] = ref.child("users").child(userID!).child("user_name")
        // other members from text boxes
        var i = 2
        if (self.member1Field.text != "") {
            mems[String(i)] = self.member1Field.text!
            i += 1
        }
        if (self.member2Field.text != "") {
            mems[String(i)] = self.member2Field.text!
            i += 1
        }
        if (self.member3Field.text != "") {
            mems[String(i)] = self.member3Field.text!
        }
        //var i = 2
        /*for case let textField as UITextField in self.view.subviews {
            if textField != self.groupNameField && textField.text != "" {
                mems[String(i)] = textField.text
                i += 1
            }
        }*/
        
        // get privacy selection
        let priv: String
        switch self.privacyField.selectedSegmentIndex
        {
        case 0:
            priv = "public"
        case 1:
            priv = "protected"
        case 2:
            priv = "private"
        default:    // default to public group
            priv = "public"
        }
        
        // add group to database
        let newGroup = ref.child("groups").childByAutoId()
        // data to be entered into database
        let value = [ "name":self.groupNameField, "privacy":priv, "members":mems ] as [String : Any]
        
        newGroup.setValue(value)
    }
    
}
