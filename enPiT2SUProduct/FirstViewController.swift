//
//  FirstViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/10/13.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import UserNotifications
import BWWalkthrough
import CoreMotion

class FirstViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    var timer2: Timer!
    var  count = 0
    
    @IBOutlet weak var progressBarView: MBCircularProgressBarView!
    @IBOutlet weak var weatherView: UILabel!
    @IBOutlet weak var weatherimgView: UIImageView!
    
    
    let locationMgr = LocationManager.sharedInstance
    let pedometer = CMPedometer()
    var pauseSteps = 0
    var result = ActivityRecord_t()
    var resultUpload = activityData()
    var firstStart = true
    var beforeDistance = 0.0
    var prevUpdateTime = NSDate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeather()
        locationMgr.didLoad()
        
        //到達度判定のためのタイマー
        timer2 = Timer.scheduledTimer(timeInterval: 100.0, target: self, selector: #selector(self.arrivalJudgment), userInfo: nil, repeats: true)
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
    @objc func arrivalJudgment(){
        
        let achieve = Double(locationMgr.getMoveDistance() * 0.001) //現在の歩行距離
        let goal = appDelegate.goalNum
        //目標の歩行距離
        
        if achieve >= goal{
            achieveNotification()
            timer2.invalidate()
        } else if achieve < goal{
            if count > 179{
                reminderNotification()
            }
            count += 1
        }
    }
    
    //到達時の通知
    func achieveNotification(){
        let content = UNMutableNotificationContent()
        content.title = "目標達成"
        content.body = "目標距離に到達しました！お疲れ様！"
        content.badge = NSNumber(value: 1)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  1, repeats: false)
        let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    //非到達時の通知
    func reminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Warning！"
        content.body = "目標距離に到達していません！歩きましょう！"
        content.badge = NSNumber(value: 1)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  1, repeats: false)
        let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
        count=0
    }
    
    @IBAction func percentSliderValueChanged(sender: UISlider) {
        progressBarView.value = CGFloat(sender.value)
    }
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var stepNumLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var mainProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var goalDistanceLabel: UILabel!
    
    var timer: Timer?
    var currentSeconds = 0.0
    var measure = false // 測定中はtrue
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var varCalorie = 0.0
    var varDistance = 0.0
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {
        if(appDelegate.goalType == 0){
            goalDistanceLabel.text = "\(appDelegate.goalNum) km"
            self.progressBarView.unitString = "km"
        }else if(appDelegate.goalType == 1){
            goalDistanceLabel.text = "\(appDelegate.goalNum ) kcal"
            self.progressBarView.unitString = "kcal"
            //            appDelegate.goalNum *= 1000.0
        }else{
            goalDistanceLabel.text = "\(appDelegate.goalNum ) 千歩"
            self.progressBarView.unitString = "千步"
            //            appDelegate.goalNum *= 1000.0
            
        }
    }
    
    @IBAction func goNext(_ sender: UIBarButtonItem) { // SETボタン
        let next = storyboard!.instantiateViewController(withIdentifier: "nextView")
        self.present(next,animated: true, completion: nil)
    }
    
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if measure == false {
            startButton.setTitle("PAUSE", for: UIControlState.normal)
            if firstStart {
                result.startTime = nowTime()
                firstStart = false
            }
            start()
        }
        else {
            startButton.setTitle("START", for: UIControlState.normal)
            pause()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        if measure == false { //測定中は何もしない
            reset()
            firstStart = true
        }
    }
    
    func calcCalorie(distance: Double, timeDiff: Double)->Double{
        var mets = 1.0
        let weight = ((appDelegate.weight) != nil) ? (appDelegate.weight)! : 60.0
        
        if(distance < 8){//Walking
            let a = 0.18916
            let e = 1.68118
            mets = a * pow(distance, e)
        }
        else{//Running
            let a = 0.75210
            let e = 1.08970
            mets = a * pow(distance, e)
        }
        
        if(mets < 0){ mets = 0 }
        if(mets > 20){ mets = 20 }
        
        print("dist * \(distance)")
        print("mets : \(mets)")
        
        let calo = 1.05 * mets * weight * timeDiff * (1.0 / 3600.0)
        
        return calo
    }
    
    @objc func update() {
        if measure {
            let timeDiff = -prevUpdateTime.timeIntervalSinceNow
            currentSeconds += timeDiff
            prevUpdateTime = NSDate()
            
            //Time
            time.text = "\(String(format: "%02d:%02d:%02d",Int(currentSeconds) / 3600,Int(currentSeconds) % 3600 / 60,Int(currentSeconds) % 3600 % 60))"
            
            //Speed
            averageSpeedLabel.text = String(format: "%.02f", locationMgr.getAverageSpeedKMPH())
            
            //Calorie
            varCalorie += calcCalorie(distance: locationMgr.getLatestSpeedKMPH()!, timeDiff: timeDiff)
            calLabel.text = String(format: "%.02f", varCalorie)
            
            if(appDelegate.goalType == 0){
                mainProgressBar.value = CGFloat(min(locationMgr.getMoveDistance() * 0.001, appDelegate.goalNum))
            }
            else if(appDelegate.goalType == 1){
                mainProgressBar.value = CGFloat(min(Double(self.calLabel.text!)!, appDelegate.goalNum))
                print(appDelegate.goalNum * 0.001)
                print(self.calLabel.text)
            }
            else{
                mainProgressBar.value = CGFloat(min(Double(self.stepNumLabel.text!)! * 0.001, appDelegate.goalNum ))
            }
            
            //            beforeDistance = locationMgr.getLatestMoveDistanceDiff()
            //            メッツ×体重×時間(分)=消費カロリー(kcal)
            
        }
    }
    
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FirstViewController.update), userInfo: nil, repeats: true);
        measure = true
        mainProgressBar.maxValue = CGFloat(appDelegate.goalNum)
        pedo()
        
        locationMgr.startLogging()
        prevUpdateTime = NSDate()
    }
    
    func pause() {
        measure = false
        self.pedometer.stopUpdates()
        pauseSteps = Int(self.stepNumLabel.text!)!
        
        locationMgr.pauseLogging()
    }
    
    func reset() {
        
        result.version = 0.1
        result.type = .walk
        //        result.startTime = 0
        result.endTime = nowTime()
        result.time = Int(currentSeconds)
        result.distance = Double(progressBarView.value)
        result.stepCount = Int(self.stepNumLabel.text!)!
        result.calorie = Double(self.calLabel.text!)!
        result.speed = Double(self.averageSpeedLabel.text!)!
        
        RecordManager().save(date: NSDate(), data: result)
        
        resultUpload.time = Double(result.time)
        resultUpload.distance = result.distance
        resultUpload.pedometer = Double(result.stepCount)
        resultUpload.calorie = result.calorie
        HistoryShareMgr().historyUpload(id: Int(appDelegate.uid)!, date: Date() as NSDate, data: resultUpload, completeHandler: {
            
            print("aaaaaaaaa")
        })
        
        currentSeconds = 0
        time.text = "00:00:00"
        averageSpeedLabel.text = "0.00"
        stepNumLabel.text = "0"
        calLabel.text = "0.00"
        mainProgressBar.value = 0
        pauseSteps = 0
        
        varCalorie = 0.0
        
        locationMgr.stopLogging()
    }
    
    func pedo(){
        // CMPedometerの確認
        if(CMPedometer.isStepCountingAvailable()){
            
            self.pedometer.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        // 歩数
                        let steps = Int(truncating: data!.numberOfSteps) + self.pauseSteps
                        self.stepNumLabel.text = "\(steps)"
                    }
                })
            }
        }
        
    }
    
    func nowTime() -> Int {
        let houFormatter = DateFormatter()
        houFormatter.dateFormat = "HH"
        let houTime = houFormatter.string(from: Date())
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        let minTime = minFormatter.string(from: Date())
        print("\(Int(houTime)!) : \(Int(minTime)!)")
        return Int(houTime)! * 60 + Int(minTime)!
    }
    
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ウォークスルー及び初回起動の判定
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    //ウォークスルーを新たなビューとして出現
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")
        let page_five = stb.instantiateViewController(withIdentifier: "walk5")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)
        walkthrough.add(viewController:page_five)
        walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////
    ///////
    ///////   For Weather
    ///////
    ////////////////////////////////////////////////////////////////////////////////
    
    func showWeather(str: String){
        self.weatherView.text?.append(str)
        
    }
    
    func loadWeather(){
        let areaCode = "130010" //東京
        let urlWeather = "http://weather.livedoor.com/forecast/webservice/json/v1?city=" + areaCode
        
        if let url = URL(string: urlWeather) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            
            print("Start Session")
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: {(data, resp, err) in
                //print(resp!.url!)
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                if(err != nil){
                    print("error:\(err)")
                    return
                }
                
                // 受け取ったdataをJSONパース、エラーならcatchへジャンプ
                do {
                    // dataをJSONパースし、変数"getJson"に格納
                    let getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    publicTime = (getJson["publicTime"] as? String)!
                    let location = (getJson["location"] as? NSDictionary)!
                    area = (location["area"] as? String)!
                    city = (location["city"] as? String)!
                    prefecture = (location["prefecture"] as? String)!
                    print("\(area):\(city):\(prefecture)")
                    
                    let description = (getJson["description"] as? NSDictionary)!
                    descriptionText = (description["text"] as? String)!
                    descriptionPublicTime = (description["publicTime"] as? String)!
                    print("\(descriptionText):\(descriptionPublicTime)")
                    
                    let forcasts = (getJson["forecasts"] as? NSArray)!
                    for dailyForcast in forcasts {
                        let forcast = dailyForcast as! NSDictionary
                        let dateLabel = (forcast["dateLabel"] as? String)!
                        let telop = (forcast["telop"] as? String)!
                        let date = (forcast["date"] as? String)!
                        
                        let temperature = (forcast["temperature"] as? NSDictionary)!
                        let minTemperature = (temperature["min"] as? NSDictionary)
                        var minTemperatureCcelsius: String
                        
                        if minTemperature == nil {
                            minTemperatureCcelsius = "-"
                        }
                        else{
                            minTemperatureCcelsius = (minTemperature?["celsius"] as? String)!
                        }
                        
                        let maxTemperature = (temperature["max"] as? NSDictionary)
                        var maxTemperatureCcelsius: String
                        if maxTemperature == nil {
                            maxTemperatureCcelsius = "-"
                        }
                        else{
                            maxTemperatureCcelsius = (maxTemperature?["celsius"] as? String)!
                        }
                        
                        let image = (forcast["image"] as? NSDictionary)!
                        let url = (image["url"] as? String)!
                        let title = (image["title"] as? String)!
                        let width = (image["width"] as? Int)!
                        let height = (image["height"] as? Int)!
                        
                        let imgUrl = URL(string: url)
                        let imgData = try? Data(contentsOf: imgUrl!)
                        let img = UIImage(data: imgData!)
                        
                        self.weatherimgView.image = img
                        weather.append(Weather(dateLabel: dateLabel, telop: telop, date: date, minTemperatureCcelsius: minTemperatureCcelsius, maxTemperatureCcelsius: maxTemperatureCcelsius, url: url, img: img!, title: title, width: width, height: height))
                    }
                    
                    //print("End Session")
                    for w in weather {
                        if(w.dateLabel == "今日"){
                            let string  = ("\(w.maxTemperatureCcelsius)℃")
                            
                            self.showWeather(str: string)
                        }
                    }
                    
                }
                catch {
                    print ("json error")
                    return
                }
            })
            task.resume()
        }
    }
    
}




var publicTime = ""
var area = ""
var city = ""
var prefecture = ""
var descriptionText = ""
var descriptionPublicTime = ""

struct Weather {
    var dateLabel: String
    var telop: String
    var date: String
    var minTemperatureCcelsius: String
    var maxTemperatureCcelsius: String
    var url: String
    var img: UIImage
    var title: String
    var width: Int
    var height: Int
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init(dateLabel: String, telop: String, date: String, minTemperatureCcelsius: String, maxTemperatureCcelsius: String, url: String,img: UIImage, title: String, width: Int, height: Int) {
        self.dateLabel = dateLabel
        self.telop = telop
        self.date = date
        self.minTemperatureCcelsius = minTemperatureCcelsius
        self.maxTemperatureCcelsius = maxTemperatureCcelsius
        self.url = url
        self.img = img
        self.title = title
        self.width = width
        self.height = height
    }
}
var weather = [Weather]()









