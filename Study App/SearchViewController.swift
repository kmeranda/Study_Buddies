//
//  SearchViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/25/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation

class SearchViewController : UIViewController {
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
