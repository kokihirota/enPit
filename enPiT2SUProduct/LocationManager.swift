//
//  LocationManager.swift
//  LocaleManager_Project
//
//  Created by kimihiro on 2017/10/20.
//  Copyright © 2017年 kimihiro. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    public static let sharedInstance = LocationManager();
    
    //急な移動をしないように
    let maximumAcceleration = 5.0   //最大加速度(m/s)
    let maximumSpeedErrorRate = 2.0  //測定値と理想値の最大倍率
    var nowSpeedByAcceleration = 0.0 //理想スピード
    
    
    //var description: String = "LocationManager"
    let locationMgr = CLLocationManager()
    var latestLocale: CLLocation?
    var previousLocale: CLLocation?
    var latestLocaleTime = NSDate()
    var previousLocaleTime = NSDate()
    
    var runningDistance = 0.0
    var runningTime = 0.0
    
    var startTime = NSDate()
    var prevUpdateTime = NSDate()
    
    var isFirstLogging = true
    var flagLogging = false
    
    func didLoad() {
        locationMgr.delegate = self
        
        locationMgr.requestAlwaysAuthorization()
        locationMgr.requestWhenInUseAuthorization()
        //if CLLocationManager.authorizationStatus() != .authorizedAlways{
        //
        //}
        
        // 位置情報の精度
        //locationManager.desiredAccuracy = .CLLocationAccuracyBest
        // 位置情報の取得間隔距離(メートル)
        //locationManager.distanceFilter = 1
        
        startLogging()
        stopLogging()
    }
    
    //測定開始
    func startLogging(){
        // 位置情報のアップデートを開始
        locationMgr.startUpdatingLocation()
        if(!flagLogging){
            previousLocale = nil
            startTime = NSDate()
            runningDistance = 0.0
            runningTime = 0.0
            flagLogging = true
        }
        nowSpeedByAcceleration = 0.0
    }
    
    //測定一時停止
    func pauseLogging(){
        locationMgr.stopUpdatingLocation()
        isFirstLogging = true
        nowSpeedByAcceleration = 0.0
    }
    
    //測定終了
    func stopLogging(){
        locationMgr.stopUpdatingLocation()
        flagLogging = false
        isFirstLogging = true
        nowSpeedByAcceleration = 0.0
    }
    
    //測定しているか
    func isLogging()->Bool{
        return flagLogging
    }
    
    //最新のCLLocation
    func getLatestLocation()->CLLocation?{
        return latestLocale
    }
    
    //最新の移動速度
    func getLatestSpeed()->CLLocationSpeed?{
        if (latestLocale != nil){
            return latestLocale?.speed
        }
        return 0.0
    }
    func getLatestSpeedKMPH()->CLLocationSpeed?{
        if (latestLocale != nil){
            return (latestLocale?.speed)! * 3600.0 / 1000.0
        }
        return 0.0
    }
    
    //最新の現在位置
    func getLatestCoordinate()->CLLocationCoordinate2D?{
        return latestLocale?.coordinate
    }
    
    //最新の移動量
    func getLatestMoveDistanceDiff()->Double{
        var distance = 0.0
        if(previousLocale != nil && latestLocale != nil){
            distance = (latestLocale?.distance(from: previousLocale!))!
            //let timeDiff = latestLocale?.timestamp.timeIntervalSince((previousLocale?.timestamp)!)
            let timeDiff = latestLocaleTime.timeIntervalSince(previousLocaleTime as Date)
            
            if(distance > nowSpeedByAcceleration * timeDiff * maximumSpeedErrorRate){
                //print("Correction Ex")
                distance =  nowSpeedByAcceleration * timeDiff * maximumSpeedErrorRate
            }
            //print("speed : \(nowSpeedByAcceleration)")
            //print("speed : \((latestLocale?.speed)!)")
            //print("Time  : \(timeDiff)")
            //print("Dista : \(distance)")
            //print("+++++++++++++++++++++")
            //print("")
        }
        
        if(distance < 0){
            distance = 0
        }
        
        return distance
    }
    
    //合計の移動量
    func getMoveDistance()->Double{
        if(runningDistance > 0){
            return runningDistance
        }
        return 0.0
    }
    
    //平均の移動速度(m/s)
    func getAverageSpeed()->Double{
        return getMoveDistance() / getRunningTime()
    }
    
    func getAverageSpeedKMPH()->Double{
        return getAverageSpeed() * 3600.0 / 1000.0
    }
    
    //トータルの移動時間
    func getRunningTime()->Double{
        return runningTime
        //return startTime.timeIntervalSinceNow
        //return NSDate().timeIntervalSince(startTime as Date)
    }
    
    
    /////////////////
    //// For GPS
    /////////////////
    
    /* Update Information*/
    func updateLocationInfo(){
        
        updateSpeedInfo()
        if(!isFirstLogging){
            runningDistance += getLatestMoveDistanceDiff()
            runningTime += NSDate().timeIntervalSince(prevUpdateTime as Date)
            prevUpdateTime = NSDate()
        }
        else{
            //ポーズ明けの場所飛び対策のために最初は記録を行わない
            prevUpdateTime = NSDate()
            isFirstLogging = false
        }
        
        
        //Record
        
    }
    
    /* Update Speed */
    func updateSpeedInfo(){
        if(previousLocale == nil || latestLocale == nil){
            return
        }
        
        //let timeDiff = latestLocale?.timestamp.timeIntervalSince((previousLocale?.timestamp)!)
        let timeDiff = latestLocaleTime.timeIntervalSince(previousLocaleTime as Date)
        
        if((latestLocale?.speed)! - nowSpeedByAcceleration > maximumAcceleration * timeDiff){
            nowSpeedByAcceleration += maximumAcceleration * timeDiff
        }
        else if((latestLocale?.speed)! - nowSpeedByAcceleration < -(maximumAcceleration * timeDiff)){
            nowSpeedByAcceleration -= maximumAcceleration * timeDiff
        }
        else{
            nowSpeedByAcceleration = (latestLocale?.speed)!
        }
        
    }
    
    /* Success - GetLocation*/
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        if(newLocation.horizontalAccuracy >= 0){
            previousLocale = latestLocale
            previousLocaleTime = latestLocaleTime
            
            latestLocale = newLocation
            latestLocaleTime = NSDate()
            updateLocationInfo()
        }
    }
    
    /* Success - GetLocation*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations[0].horizontalAccuracy >= 0){
            previousLocale = latestLocale
            previousLocaleTime = latestLocaleTime
            
            latestLocale = locations[0]
            latestLocaleTime = NSDate()
            updateLocationInfo()
        }
    }
    
    
    /*Error - GetLocation*/
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error : \(error)")
    }
    
    /* Error - Authorization */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if status == .authorizedWhenInUse{
        //    manager.requestLocation()
        //}
    }
    
}

