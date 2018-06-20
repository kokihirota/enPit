//
//  RecordManager.swift
//  LocaleManager_Project
//
//  Created by kimihiro on 2017/10/26.
//  Copyright © 2017年 kimihiro. All rights reserved.
//

import Foundation

//履歴などの記録を管理する
class RecordManager2{
    
}
class RecordManager{
    public static let sharedInstance = RecordManager()
    
    /*SaveInfo*/
    func save(date: NSDate, data: ActivityRecord_t){
        
        //出力ファイル名の生成
        //let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let year = Calendar.current.component(.year, from: date as Date)
        let month = Calendar.current.component(.month, from: date as Date)
        let day = Calendar.current.component(.day, from: date as Date)
        let fileName = String(format: "%d%02d%02d01.log", year, month, day)
        //let fileName = "\(year)\(month)\(day)01.log"
        
        let string = convertActivityRecordToString(data: data) //保存する内容
//        print("Save:\(fileName)")
//        print("write:\(string)")
        
        //出力
        let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first
        if  (dir != nil){
            let PathFileName = dir?.appendingPathComponent( fileName )
            do {
                //Save処理
                //ファイルが存在しない場合作成する
                if(!(FileManager.default.fileExists(atPath: (PathFileName?.path)!))){
                    try "".write(to: PathFileName!, atomically: true, encoding: String.Encoding.utf8)
                }
                
                //データの書き込み
                let fileHandle = try FileHandle(forWritingTo: PathFileName!)
                // ファイルの最後に追記
                fileHandle.seekToEndOfFile()
                fileHandle.write(string.data(using: String.Encoding.utf8)!)
                
            }
            catch {
                //エラー処理
                print("Cannot Save")
            }
        }
        
    }
    
    /*LoadInfo*/
    func load(date: NSDate)->Array<ActivityRecord_t>{
        //ファイル名の生成
        let year = Calendar.current.component(.year, from: date as Date)
        let month = Calendar.current.component(.month, from: date as Date)
        let day = Calendar.current.component(.day, from: date as Date)
        let fileName = String(format: "%d%02d%02d01.log", year, month, day)
        //let fileName = "\(year)\(month)\(day)01.log"
        var data: [ActivityRecord_t] = []
        
//        print("Load:\(fileName)")
        
        
        if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
            let pathFileName = dir.appendingPathComponent( fileName )
            do {
                //Load処理
                let rawString = try String( contentsOf: pathFileName, encoding: String.Encoding.utf8 )
                let strings   = rawString.components(separatedBy: "\n")
                
                print( rawString )
                for s in strings{
                    let dat = convertStringToActivityRecord(str: s)
                    if (dat != nil){
                        data.append(dat!)
                    }
                }
            }
            catch {
                //エラー処理
                //print("No Data")
                
            }
        }
        return data
    }
    
    func loadCalorie(date: NSDate)->Double{
        let data = load(date: date)
        var sum = 0.0
        for d in data{
            sum+=d.calorie
        }
        
        return sum
    }
    
    func loadDistance(date: NSDate)->Double{
        let data = load(date: date)
        var sum = 0.0
        for d in data{
            sum+=d.distance
        }
        
        return sum
    }
    
    func loadStepcount(date: NSDate)->Int{
        let data = load(date: date)
        var sum = 0
        for d in data{
            sum+=d.stepCount
        }
        
        return sum
    }
    
    func loadTime(date: NSDate)->Int{
        let data = load(date: date)
        var sum = 0
        for d in data{
            sum+=d.time
        }
        
        return sum
    }
    
    /*private Func*/
    
    //文字列からデータへの変換・頭の悪い書き方
    func convertActivityRecordToString(data: ActivityRecord_t)->String{
        let str =
            "\(data.version)," +
                "\(data.type.rawValue)," +
                "\(data.startTime)," +
                "\(data.endTime)," +
                "\(data.time)," +
                "\(data.distance)," +
                "\(data.stepCount)," +
                "\(data.calorie)," +
                "\(data.speed)," +
        "\n"
        
        return str
    }
    
    //データから文字列への変換・そのうち抜本的に変えたい
    func convertStringToActivityRecord(str: String)->ActivityRecord_t?{
        var data = ActivityRecord_t()
        let element = str.components(separatedBy: ",")
        
        
        //読み込めないよ
        if (element.count <= 8){
            return nil
        }
        print("su:\(element.count)")
        data.version    = Double(element[0])!
        data.type       = ActivityType(rawValue: element[1])!
        data.startTime  = Int(element[2])!
        data.endTime    = Int(element[3])!
        data.time       = Int(element[4])!
        data.distance   = Double(element[5])!
        data.stepCount  = Int(element[6])!
        data.calorie    = Double(element[7])!
        data.speed      = Double(element[8])!
        
        return data
    }
    
}



enum ActivityType: String{
    case walk = "Walk"
    case run  = "Run"
    case bike = "Bike"
    
}

//履歴記録構造体
struct ActivityRecord_t{
    var version             = 0.1
    var type: ActivityType  = .walk
    var startTime: Int      = 0
    var endTime: Int        = 0
    var time: Int           = 0
    var distance: Double    = 0.0
    var stepCount: Int      = 0
    var calorie: Double     = 0.3
    var speed: Double       = 0.0
    
    //使うかもしれないデータ用の予備
    var comment: String       = ""
    var route: Int            = 0
    var weather: Int          = 0
}

