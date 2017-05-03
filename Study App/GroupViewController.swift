//
//  GroupViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/29/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class GroupViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupTable: UITableView!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var addNewGroup: UIBarButtonItem!
    
    @IBOutlet weak var newGroupNameLabel: UILabel!
    @IBOutlet weak var newGroupNameField: UITextField!
    @IBOutlet weak var newGroupPrivacyLabel: UILabel!
    @IBOutlet weak var newGroupPrivacyPicker: UISegmentedControl!
    @IBOutlet weak var newGroupPrivacyDescription: UIButton!
    @IBOutlet weak var newGroupMembersLabel: UILabel!
    @IBOutlet weak var newGroupMember1: UITextField!
    @IBOutlet weak var newGroupMember2: UITextField!
    @IBOutlet weak var newGroupMember3: UITextField!
    @IBOutlet weak var createNewGroup: UIButton!
    @IBOutlet weak var newGroupCancel: UIButton!
    
    var TableArray = [Group] ()
    var ref : FIRDatabaseReference!
    var refHandle: UInt!
    
    let cellID = "cellID"   // might not need
    
    override func viewDidLoad() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // make sure table of groups is visible
        self.groupTable.isHidden = false
        
        // only have the new group fields when creating group
        self.newGroupNameLabel.isHidden = true
        self.newGroupNameField.isHidden = true
        self.newGroupPrivacyLabel.isHidden = true
        self.newGroupPrivacyPicker.isHidden = true
        self.newGroupPrivacyDescription.isHidden = true
        self.newGroupMembersLabel.isHidden = true
        self.newGroupMember1.isHidden = true
        self.newGroupMember2.isHidden = true
        self.newGroupMember3.isHidden = true
        self.createNewGroup.isHidden = true
        self.newGroupCancel.isHidden = true
        
        // Firebase database
        ref = FIRDatabase.database().reference()
        fetchGroups()
        
        //TableArray = ["Search", "Profile", "Groups", "Map", "Settings", "Sign Out"]
    }
    
    func numberOfSections( in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    // populate cells of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() //tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row].name
        return cell
    }
    
    // delete group
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // get user auth
            let user = FIRAuth.auth()?.currentUser
            let userID = user?.uid
            print(String(describing: userID!))
            
            // get user info
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["display_name"] ?? ""
                let groupId = self.TableArray[indexPath.row].id ?? ""
                let num = self.TableArray[indexPath.row].members.index(of: String(describing: name))
                
                let len = self.TableArray[indexPath.row].members.count - 1
                print(String(describing: self.TableArray[indexPath.row].members))
                print("length: " + String(len))
                self.ref.child("groups").child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                    let x = snapshot.value as? [String]
                    print("\n" + String(describing: snapshot.ref))
                    //let x_val = x?[String(len-1)] ?? ""
                    print((x?[len]) ?? "")
                    
                    self.ref.child("groups").child(groupId).child("members").child(String(describing: num!)).setValue(x?[len] ?? "")
                    self.ref.child("groups").child(groupId).child("members").child(String(len)).removeValue()
                })
                
                
                
                
                self.TableArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
            })
        
        }
    }
    
    // pull up details on group
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(describing: TableArray[indexPath.row].members))
    }
    
    func fetchGroups() {
        // get user auth
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        print(String(describing: userID!))
        
        // get user info
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            // get group info
            self.refHandle = self.ref.child("groups").observe(.childAdded, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if (dictionary["members"]?.contains(value?["display_name"] ?? ""))! {
                        print(dictionary["name"] ?? "")
                        print("\n\n\n" + String(describing: dictionary))
                        
                        let group = Group()
                        group.id = snapshot.key
                        group.name = dictionary["name"] as? String
                        group.privacy = dictionary["privacy"] as? String
                        group.members = dictionary["members"] as! [String]
                        //group.setValuesForKeys(dictionary)
                        
                        self.TableArray.append(group)
                    }
                    DispatchQueue.main.async(execute: {
                        self.groupTable.reloadData()
                    })
                }
            }, withCancel: { (error) in
                print(error)
            })
        })
    }
    
    @IBAction func privacyExplanationAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Group Privacy Settings", message: "Public Groups can be seen by everyone.\n\nProtected Groups can be seen by the friends of members of the group.\n\nPrivate Groups can only be seen by members of the group.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createNewGroupAction(_ sender: UIBarButtonItem) {
        // hide table of groups
        self.groupTable.isHidden = true
        
        // make new group form visible
        self.newGroupNameLabel.isHidden = false
        self.newGroupNameField.isHidden = false
        self.newGroupPrivacyLabel.isHidden = false
        self.newGroupPrivacyPicker.isHidden = false
        self.newGroupPrivacyDescription.isHidden = false
        self.newGroupMembersLabel.isHidden = false
        self.newGroupMember1.isHidden = false
        self.newGroupMember2.isHidden = false
        self.newGroupMember3.isHidden = false
        self.createNewGroup.isHidden = false
        self.newGroupCancel.isHidden = false
        
    }
    
    @IBAction func cancelNewGroupAction(_ sender: UIButton) {
        // show table of groups
        self.groupTable.isHidden = false
        
        // make new group form hidden
        self.newGroupNameLabel.isHidden = true
        self.newGroupNameField.isHidden = true
        self.newGroupPrivacyLabel.isHidden = true
        self.newGroupPrivacyPicker.isHidden = true
        self.newGroupPrivacyDescription.isHidden = true
        self.newGroupMembersLabel.isHidden = true
        self.newGroupMember1.isHidden = true
        self.newGroupMember2.isHidden = true
        self.newGroupMember3.isHidden = true
        self.createNewGroup.isHidden = true
        self.newGroupCancel.isHidden = true
    }
    
    @IBAction func addNewGroupAction(_ sender: UIButton) {
        // add new group to Firebase
        // groups must have a name
        if self.newGroupNameField.text == "" {
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
        // get profile info
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let val = snapshot.value as? NSDictionary
            let username = val?["display_name"] as? String ?? ""
            print(username)
            mems["0"] = username
            // other members from text boxes
            var i = 1
            if (self.newGroupMember1.text != "") {
                mems[String(i)] = self.newGroupMember1.text!
                i += 1
            }
            if (self.newGroupMember2.text != "") {
                mems[String(i)] = self.newGroupMember2.text!
                i += 1
            }
            if (self.newGroupMember3.text != "") {
                mems[String(i)] = self.newGroupMember3.text!
            }
            
            // get privacy selection
            let priv: String
            switch self.newGroupPrivacyPicker.selectedSegmentIndex
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
            let value = [ "name":self.newGroupNameField.text!, "privacy":priv, "members":mems ] as [String : Any]
            
            newGroup.setValue(value)    // actually add to database
            
            // show table of groups
            self.groupTable.isHidden = false
            
            // make new group form hidden
            self.newGroupNameLabel.isHidden = true
            self.newGroupNameField.isHidden = true
            self.newGroupPrivacyLabel.isHidden = true
            self.newGroupPrivacyPicker.isHidden = true
            self.newGroupPrivacyDescription.isHidden = true
            self.newGroupMembersLabel.isHidden = true
            self.newGroupMember1.isHidden = true
            self.newGroupMember2.isHidden = true
            self.newGroupMember3.isHidden = true
            self.createNewGroup.isHidden = true
            self.newGroupCancel.isHidden = true
        })
    }
    
}
