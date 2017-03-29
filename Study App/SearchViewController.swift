//
//  SearchViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/25/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation

class SearchViewController : UIViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
