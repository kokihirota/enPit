//
//  ViewController.swift
//  testEureka
//
//  Created by s15ti050 on 2017/11/09.
//  Copyright © 2017年 s15ti050. All rights reserved.
//
import UIKit
import Eureka
import BWWalkthrough

enum ThemeColor: String{
    case blue = "blue"
    case red = "red"
    case lightGray = "lightGray"
    case yellow = "yellow"
    
    static func all() -> [ThemeColor]{
        return [
            ThemeColor.blue,
            ThemeColor.red,
            ThemeColor.lightGray,
            ThemeColor.yellow
        ]
    }
}

class ThirdViewController: FormViewController, BWWalkthroughViewControllerDelegate {
    let userDefault = UserDefaults.standard
    var nickname = ""
    var birthday = Date()
    var alertOn = true
    var themeColor = ThemeColor.blue
    var priority = 0
    //    var weight = 0.0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var dateFormat: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        
        return f
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
        
        form
            // Profile
            +++ Section("プロフィール")
            <<< NameRow("userName"){
                $0.title = "ユーザー名"
                $0.placeholder = "optional"
                if let uname:AnyObject = self.userDefault.object(forKey: "userName") as AnyObject{
                    $0.value = uname as? String
                }
                $0.onChange{row in
                    if row.value != nil{
                        self.nickname = row.value!
                        self.userDefault.setValue(row.value, forKey: "userName")
                        self.submit()
                    }
                }
            }
            <<< LabelRow(){
                $0.title = "ID:"
                $0.value = "\(appDelegate.uid)"
            }
            <<< DateRow(){
                $0.title = "誕生日"
                $0.dateFormatter = type(of: self).dateFormat
                $0.minimumDate = type(of: self).dateFormat.date(from: "1900/01/01") ?? Date()
                if let ubday:AnyObject = self.userDefault.object(forKey: "birthday") as AnyObject {
                    $0.value = ubday as? Date
                }
                $0.onChange{row in
                    self.userDefault.setValue(row.value, forKey: "birthday")
                }
            }
            
            <<< DecimalRow(){
                $0.title = "体重"
                $0.placeholder = "60.0"
                if let uweight:AnyObject = self.userDefault.object(forKey: "weight") as AnyObject{
                    $0.value = uweight as? Double
                    self.appDelegate.weight = uweight as? Double
                }
                $0.onChange{row in
                    self.userDefault.setValue(row.value, forKey: "weight")
                    self.appDelegate.weight = row.value ?? 0.0
                }
                
            }
            
            +++ Section("目標")
            
            <<< DecimalRow(){
                $0.title = "カロリー (kc)"
                $0.placeholder = "0.0"
                if let ugoalCalo:AnyObject = self.userDefault.object(forKey: "goalCalo") as AnyObject{
                    $0.value = ugoalCalo as? Double
                    if(ugoalCalo as? Double != nil){
                        self.appDelegate.goalCalo = (ugoalCalo as! Double)
                    }
                }
                $0.onChange{row in
                    self.userDefault.setValue(row.value, forKey: "goalCalo")
                    self.appDelegate.goalCalo = row.value ?? 0.0
                }
            }
            
            <<< DecimalRow(){
                $0.title = "距離 (km)"
                $0.placeholder = "0.0"
                if let ugoalDist:AnyObject = self.userDefault.object(forKey: "goalDist") as AnyObject{
                    $0.value = ugoalDist as? Double
                    if(ugoalDist as? Double != nil){
                        self.appDelegate.goalDist = (ugoalDist as! Double)
                    }
                }
                $0.onChange{row in
                    self.userDefault.setValue(row.value, forKey: "goalDist")
                    self.appDelegate.goalDist = row.value ?? 0.0
                }
            }
            
            <<< DecimalRow(){
                $0.title = "歩数 (步)"
                $0.placeholder = "0"
                if let ugoalPedo:AnyObject = self.userDefault.object(forKey: "goalPedo") as AnyObject{
                    $0.value = ugoalPedo as? Double
                    if(ugoalPedo as? Double != nil){
                        self.appDelegate.goalPedo = (Int(ugoalPedo as! Double))
                    }
                }
                $0.onChange{row in
                    self.userDefault.setValue(row.value, forKey: "goalPedo")
                    self.appDelegate.goalPedo = Int(row.value ?? 0.0)
                }
            }
            
            // Button
            +++ Section()
            <<< ButtonRow(){
                $0.title = "アプリの使い方"
                $0.onCellSelection{ [unowned self] cell, row in
                    self.showWalkthrough()
                }
        }
        
    }
    
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
    
    func submit() {
        
        HistoryShareMgr().userRename(id: Int(appDelegate.uid)!, name: nickname, completeHandler: {})
        
        //        let postString = "new_name=\(nickname)&uid=\(appDelegate.uid)"
        //
        //        var request = URLRequest(url: URL(string: "http://ihonki.sytes.net/ihonki/rename.php")!)
        //        //        var request = URLRequest(url: URL(string: "http://192.168.0.9/ihonki/rename.php")!)
        //        request.httpMethod = "POST"
        //        request.httpBody = postString.data(using: .utf8)
        //
        //        let task = URLSession.shared.dataTask(with: request, completionHandler: {
        //            (data, response, error) in
        //
        //            if error != nil {
        //                print(error as Any)
        //                return
        //            }
        //
        //            print("response: \(response!)")
        //
        //            let phpOutput = String(data: data!, encoding: .utf8)!
        //            print("php output: \(phpOutput)")
        //        })
        //        task.resume()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
}


