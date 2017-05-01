//
//  MapViewController.swift
//  Study App
//
//  Created by Kelsey Meranda on 3/29/17.
//  Copyright © 2017 Kelsey Meranda. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    
    }
    
    //Location Manager Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERRORS: "+error.localizedDescription)
    }
    
    
    
    
    
    
    
    
    
    
}
