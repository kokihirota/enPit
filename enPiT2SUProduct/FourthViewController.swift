//
//  FourthViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/10/14.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import MapKit

class FourthViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var timer: Timer?
    let locationMgr = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
        // Do any additional setup after loading the view.
    }
    
    @objc func update() {
        let location = locationMgr.getLatestLocation()
        //print("**************************** : /(location)")
        let region = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FourthViewController.update), userInfo: nil, repeats: true);
    }
    
    //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //    print("locations : /(locations)")
    //    let current = locations[0]
    //    let region = MKCoordinateRegionMakeWithDistance(current.coordinate, 500, 500)
    //    mapView.setRegion(region, animated: true)
    //}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
