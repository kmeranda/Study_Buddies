//
//  SearchViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/25/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation
import Firebase

class SearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchPicker: UISegmentedControl!
    
    // for getting data for table
    var ref : FIRDatabaseReference!
    var refHandle: UInt!
    let cellID = "cellID"   // might not need
    // for searchy things
    var searchActive : Bool = false
    var data = [String]() //["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        /* Setup delegates */
        self.searchTable.delegate = self
        self.searchTable.dataSource = self
        self.searchbar.delegate = self
        
        // get data from Firebase
        //fetchData()
        data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) //CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.searchTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        // get user auth
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        print(String(describing: userID!))
        
        // get user info
        ref.child("users").child("hFoX1wA9IMexyAzOJDfegsZC4ia2").observeSingleEvent(of: .value, with: { (snapshot) in
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
                        
                        print(String(describing: self.data))
                        self.data.append(group.name!)
                    }
                    DispatchQueue.main.async(execute: {
                        self.searchTable.reloadData()
                    })
                }
            }, withCancel: { (error) in
                print(error)
            })
        })

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") //tableView.dequeueReusableCell(withIdentifier: "Cell")!;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
}
