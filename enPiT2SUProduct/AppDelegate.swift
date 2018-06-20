//
//  AppDelegate.swift
//  enPiT2SUProduct
//
//  Created by Jun Ohkubo on 2017/09/15.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var goalDistance : Double? = 0.5
    var goalNum : Double = 0.0
    var goalType : Int = 0
//    0ならkm 1ならkcal 2なら千步
    
    var rowInt = 0
    var rowDouble = 0
    var rowUnit = 0
    
    var weight : Double? = 60.0
    var goalDist : Double = 0.0 // 今月の目標距離
    var goalCalo : Double = 0.0
    var goalPedo : Int = 0
    var window: UIWindow?
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //スプラッシュ画面の起動時間
        sleep(UInt32(1.7));
        
        //通知の可否を問う
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { result, error in
        })
        
        uidget()
        print("uid\(uid)")
        
        //        defaults.set(self.uid1, forKey: "uid")
        //        defaults.synchronize()
        
        return true
    }
    
    
    //uidがなかったら作成
    var uid = ""
    let defaults = UserDefaults.standard
    
    //uidをforkeyとしているものを開く、なければ何も帰ってこない（初回起動）
    func user() {
        if let aaa = defaults.object(forKey: "uid"){
            uid = aaa as! String
            print("uid\(uid)")
        }
    }
    
    func uidget(){
        user()
        print("aaa")
        if uid == "" {
            print("vvv")
            //            UIDを取得、uidに値を入れる。その後、usersaveを呼び出す。
            
            //let stringUrl = "http://192.168.0.9/ihonki/regist.php"
            //let stringUrl = "http://ihonki.sytes.net/ihonki/regist.php"
            let stringUrl = "http://enpit-team-A.net.fmx.ics.saitama-u.ac.jp/ihonki/regist.php"
            let url = URL(string: stringUrl)
            let req = URLRequest(url: url!)
            
            
            let task = URLSession.shared.dataTask(with: req, completionHandler: {
                (data, res, err) in
                if data != nil {
                    let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    DispatchQueue.main.async(execute: {
                        self.uid = text! as String
                        print(self.uid)
                        if (self.uid == ""){
                            print("ERROR")
                        } else {
                            print("初回起動のため、登録しました")
                            print("uid : \(self.uid)")
                            self.defaults.set(self.uid, forKey: "uid")
                            self.defaults.synchronize()
                            self.uid = text! as String
                            
                            //ここで値の保存、全view共有化も行う
                        }
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        print("ERROR2")
                    })
                }
            })
            task.resume()
            
        }else{
            print("初回起動ではありません。")
        }
    }
    
    
    func usersave() {
        defaults.set(uid, forKey: "uid")
        defaults.synchronize()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //バックグラウンドでタイマーを動作させる
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //前回終了時から一日後の通知
        let requestIdentifier = "onceDayIdentifier"
        let content = UNMutableNotificationContent()
        content.title = "こんにちは"
        content.body = "今日は歩いていません。歩きましょう。"
        content.badge = NSNumber(value: 1)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false); //本来は86400秒
        let request = UNNotificationRequest.init(identifier: requestIdentifier,
                                                 content: content,
                                                 trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.endBackgroundTask(self.backgroundTaskID)
        //一日起動しない際の通知を削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["onceDayIdentifier"])    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //通知をタップしてアプリ起動したら呼ばれる
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //アプリがフォアグラウンドの時に通知が来たら呼ばれる
    }
}

