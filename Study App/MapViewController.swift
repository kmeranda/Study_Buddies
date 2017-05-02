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
import Firebase

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
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
        //self.mapView.showsBuildings = true
        self.mapView.mapType = MKMapType.hybrid
        self.locationManager.stopUpdatingLocation()
        
        // get array of study sessions
        // get profile info
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("sessions").observe(.childAdded, with: { (snapshot) -> Void in
        //ref.child("sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let val = snapshot.value as? NSDictionary
            print("purpose: " + String(describing: val?["purpose"]))
            //let username = value?["display_name"] as? String ?? ""
            //for sess in snapshot.children {
                //let sess_dict = snapshot.childSnapshotForPath((sess).key).value
                //print(sess)
            //}
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: val?["latitude"]! as! CLLocationDegrees, longitude: val?["longitude"]! as! CLLocationDegrees)
            annotation.title = val?["group"]! as! String
            annotation.subtitle = val?["purpose"]! as! String
            self.mapView.addAnnotation(annotation)

            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        //var arr = [NSDictionary]()
        //let x : NSDictionary = NSDictionary()
        //x = {"group": "Study Buddies", "purpose": "Studying Mobile Computing", "latitude": 41.699755, "longitude": -8623716, "time": 1493669925 }
        //arr.append(x)
        
        // add pins of study sessions
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 41.699755, longitude: -86.23716)
        annotation.title = "Study Buddies"
        annotation.subtitle = "Studying Mobile Computing"
        self.mapView.addAnnotation(annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERRORS: "+error.localizedDescription)
    }
    
    
    
    
    
    
    
    
    
    
}
