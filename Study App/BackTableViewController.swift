//
//  BackTableViewController.swift
//
//  Created by Kelsey Meranda on 3/25/17.
//
//

import Foundation

class BackTableViewController : UITableViewController {
    
    var TableArray = [String] ()
    
    override func viewDidLoad() {
        TableArray = ["Search", "Profile", "Groups", "Map", "Settings", "Sign Out"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        return cell
    }
    
}
