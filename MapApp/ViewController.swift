//
//  ViewController.swift
//  MapApp
//
//  Created by GeFrank on 1/1/20.
//  Copyright © 2020 GeFrank. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var userLocation = CLLocationCoordinate2D()
    var mapView = MKMapView()
    var window: UIWindow?
    var firstTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "MovieNavi"
    }
    
    override func loadView() {
        super.loadView()

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //get window dimension
        self.window = UIWindow(frame: UIScreen.main.bounds)

        //fill map with windown dimension
        mapView.frame = CGRect(x: 0, y: 0, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!)
        self.view.addSubview(mapView)
        
        //set constraint
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        addBottemSheetView()
    }
    
    //set location to user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        userLocation = locValue
        let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        if firstTime {
            mapView.setRegion(region, animated: true)
            firstTime = false
        }
        mapView.showsUserLocation = true
    }

    func addBottemSheetView() {
        let bottomSheetVC = BottomSlidableSheetViewController()
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        bottomSheetVC.view.frame = CGRect(x: 0, y: (self.window?.frame.maxY)!, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!)
    }
    
}

