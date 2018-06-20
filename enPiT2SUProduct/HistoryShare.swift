//
//  HistoryShareMgr.swift
//  PHPTest
//
//  Created by kimihiro on 2017/12/13.
//  Copyright © 2017年 kimihiro. All rights reserved.
//

import Foundation

//let urlDetail = "ihonki.sytes.net" //自宅サーバ
//let urlDetail = "192.168.0.9" //どこかの開発環境

let urlDetail = "enpit-team-A.net.fmx.ics.saitama-u.ac.jp"

class HistoryShareMgr {
    
    /*URL集*/
    let urlRegist          = "http://\(urlDetail)/ihonki/regist.php"
    let urlRename          = "http://\(urlDetail)/ihonki/rename.php"
    let urlUploadHistory   = "http://\(urlDetail)/ihonki/upload.php"
    let urlDownloadHistory = "http://\(urlDetail)/ihonki/download.php"
    let urlAddComment      = "http://\(urlDetail)/ihonki/addcomment.php"
    let urlGetComment      = "http://\(urlDetail)/ihonki/getcomment.php"
    let urlGetName         = "http://\(urlDetail)/ihonki/getname.php"
    let urlSearchUser      = "http://\(urlDetail)/ihonki/searchuser.php"
    let urlExist           = "http://\(urlDetail)/ihonki/exist.php"
    
   
    /*
     ユーザ登録を行い,ユーザIDを取得する
     引数 　- completeHandler:完了時の処理
     戻り値 - なし
     備考　 - completeHandlerの引数idは取得したID
     */
    func userRegist(completeHandler: @escaping (_ id: Int)->()){
        let postString = "name=default"
        
        var request = URLRequest(url: URL(string: urlRegist)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Complete
            print("Task Completed")
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            let output = String(data: data!, encoding: .utf8)!
            var id = -1
            if(Int(output) != nil){
                id = Int(output)!
            }
            
            completeHandler(id)
        })
        task.resume()
    }
    
    /*
     ユーザ名の改名を行う
     引数 　- id:ユーザID, name:新しい名前, completeHandler:完了時の処理
     戻り値 - なし
     */
    func userRename(id : Int, name : String, completeHandler: @escaping ()->()) {
        //Check ID
        if(id <= 0){
            print("Invalid UID")
            return
        }
        
        let postString = "new_name=\(name)&uid=\(id)"
        
        var request = URLRequest(url: URL(string: urlRename)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Complete
            print("Task Completed")
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            completeHandler()
        })
        task.resume()
    }
    
    /*
     記録のアップロードを行う
     引数 　- id:ユーザID, date:日時, data: 記録, completeHandler:完了時の処理
     戻り値 - なし
     */
    func historyUpload(id: Int, date: NSDate, data: activityData, completeHandler: @escaping ()->()){
        //Generate Date
        let year = Calendar.current.component(.year, from: date as Date)
        let month = Calendar.current.component(.month, from: date as Date)
        let day = Calendar.current.component(.day, from: date as Date)
        let hour = Calendar.current.component(.hour, from: date as Date)
        let min = Calendar.current.component(.minute, from: date as Date)
        
        //Check ID
        if(id <= 0){
            print("Invalid UID")
            return
        }
        
        let postString = "uid=\(id)&date_year=\(year)&date_mont=\(month)&date_day=\(day)&date_hour=\(hour)&date_minu=\(min)&data_pedo=\(data.pedometer)&data_dist=\(data.distance)&data_calo=\(data.calorie)"
        
        var request = URLRequest(url: URL(string: urlUploadHistory)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Complete
            print("Task Completed")
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            completeHandler()
        })
        task.resume()
    }
    
    /*
     記録のダウンロードを行う
     引数 　- id:ユーザID, begin:取得範囲の開始日時, end: 取得範囲の終了日時, completeHandler:完了時の処理
     戻り値 - なし
     備考　 - completeHandlerの引数は取得した運動のデータ
     */
    func historyDownload(id: Int, begin: NSDate, end: NSDate, completeHandler: @escaping (_ data: activityData)->()){
        //Create Date
        let beginYear  = Calendar.current.component(.year,   from: begin as Date)
        let beginMonth = Calendar.current.component(.month,  from: begin as Date)
        let beginDay   = Calendar.current.component(.day,    from: begin as Date)
        let beginHour  = Calendar.current.component(.hour,   from: begin as Date)
        let beginMin   = Calendar.current.component(.minute, from: begin as Date)
        
        let endYear  = Calendar.current.component(.year,   from: end as Date)
        let endMonth = Calendar.current.component(.month,  from: end as Date)
        let endDay   = Calendar.current.component(.day,    from: end as Date)
        let endHour  = Calendar.current.component(.hour,   from: end as Date)
        let endMin   = Calendar.current.component(.minute, from: end as Date)
        
        //Check ID
        if(id <= 0){
            print("Invalid UID")
            return
        }
        
        //print("beg:\(begin)\n")
        //print("end:\(end)\n")
        
        let postString = "uid=\(id)&begin_year=\(beginYear)&begin_mont=\(beginMonth)&begin_day=\(beginDay)&begin_hour=\(beginHour)&begin_minu=\(beginMin)&end_year=\(endYear)&end_mont=\(endMonth)&end_day=\(endDay)&end_hour=\(endHour)&end_minu=\(endMin)"
        
        var request = URLRequest(url: URL(string: urlDownloadHistory)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            let output = String(data: data!, encoding: .utf8)!
            let outData = output.split(separator: ",")
            var actData = activityData()
            if(outData.count == 3){
                print("Task Completed")
                actData.pedometer = Double(outData[0]) != nil ? Double(outData[0])! : 0.0
                actData.distance  = Double(outData[0]) != nil ? Double(outData[1])! : 0.0
                actData.calorie   = Double(outData[0]) != nil ? Double(outData[2])! : 0.0
            }
            else{
                print("Data Error")
            }
            
            //Complete
            completeHandler(actData)
        })
        task.resume()
    }
    
    /*
     コメントの送信を行う
     引数 　- senderId:送り主(自身)のID, receiverID:受信者(相手)のID, comment:コメント本文, completeHandler:取得完了時の処理
     戻り値 - なし
     */
    func addComent(senderID: Int, receiverID: Int, date: NSDate, comment: String, completeHandler: @escaping ()->()){
        //Create Date
        let year = Calendar.current.component(.year, from: date as Date)
        let month = Calendar.current.component(.month, from: date as Date)
        let day = Calendar.current.component(.day, from: date as Date)
        let hour = Calendar.current.component(.hour, from: date as Date)
        let min = Calendar.current.component(.minute, from: date as Date)
        
        //Check ID
        if(senderID <= 0 || receiverID <= 0){
            print("Invalid UID")
            return
        }
        
        //String Formatting
        let str = comment.replacingOccurrences(of: "&", with: "%26")
        print("\(str)")
        let postString = "sender_uid=\(senderID)&receiver_uid=\(receiverID)&date_year=\(year)&date_mont=\(month)&date_day=\(day)&date_hour=\(hour)&date_minu=\(min)&comment=\(str)"
        
        var request = URLRequest(url: URL(string: urlAddComment)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Complete
            print("Task Completed")
            print("response: \(response!)")
            let output = String(data: data!, encoding: .utf8)!
            print("output: \(output)")
            
            completeHandler()
        })
        task.resume()
    }
    
    
    /*
     コメントの取得を行う
     引数　 - id:ユーザ識別ID, completeHandler:取得完了時の処理
     戻り値 - なし
     備考　 - completeHanderの引数は取得したコメントデータ構造体の配列
     */
    func getComent(id: Int, completeHandler: @escaping (_ comments: [CommentData])->()){
        //Check ID
        if(id <= 0){
            print("Invalid UID")
            return
        }
        
        var receivedComment :[CommentData] = []
        let postString = "uid=\(id)"
        
        var request = URLRequest(url: URL(string: urlGetComment)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Process JSON
            do {
                let getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let commentArray = (getJson["Comments"] as? NSArray)!
                for element in commentArray{
                    let cmt = element as! NSDictionary
                    var cmtData = CommentData()
                    
                    cmtData.senderID   = (cmt["SenderID"] as? Int)!
                    cmtData.senderName = (cmt["SenderName"] as? String)!
                    cmtData.sendDate   = (cmt["SendDate"] as? String)!
                    cmtData.Comment    = (cmt["Comment"] as? String)!
                    
                    receivedComment.append(cmtData)
                    
                }
            }
            catch {
                print ("JSON Data Error")
                return
            }
            
            //Complete
            print("Task Completed")
            print("response: \(response!)")
            let output = String(data: data!, encoding: .utf8)!
            print("output: \(output)")
            
            completeHandler(receivedComment)
        })
        task.resume()
        
    }
    /*
     func getComentAll(id: Int){
     let postString = "uid=\(id)"
     
     var request = URLRequest(url: URL(string: urlGetComment)!)
     request.httpMethod = "POST"
     request.httpBody = postString.data(using: .utf8)
     
     let task = URLSession.shared.dataTask(with: request, completionHandler: {
     (data, response, error) in
     
     if error != nil {
     print(error as Any)
     return
     }
     
     let phpOutput = String(data: data!, encoding: .utf8)!
     print("php output: \(phpOutput)")
     })
     task.resume()
     }
     */
    
    /*
     名前の取得を行う
     引数　 - id:ユーザ識別ID, completeHandler:取得完了時の処理
     戻り値 - なし
     備考　 - completeHanderの引数は取得した名前
     */
    func getName(id: Int, completeHandler: @escaping (_ name: String)->()){
        //Check ID
        if(id <= 0){
            print("Invalid UID")
            return
        }
        
        let postString = "uid=\(id)"
        
        var request = URLRequest(url: URL(string: urlGetName)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Complete
            print("Task Completed")
            //print("response: \(response!)")
            let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            completeHandler(output)
        })
        task.resume()
    }
    
    /*
     ユーザの検索を行う
     引数　 - name:名前, completeHandler:取得完了時の処理
     戻り値 - なし
     備考　 - completeHanderの引数は取得したデータ
     */
    
    func searchUser(name: String, completeHandler: @escaping (_ comments: [UsersData])->()){
        var receivedData :[UsersData] = []
        let postString = "name=\(name)"
        
        var request = URLRequest(url: URL(string: urlSearchUser)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        //Procrss Task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            //Process JSON
            do {
                let getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let usersArray = (getJson["Users"] as? NSArray)!
                for element in usersArray{
                    let cmt = element as! NSDictionary
                    var cmtData = UsersData()
                    
                    cmtData.id  = (cmt["ID"] as? Int)!
                    cmtData.name = (cmt["Name"] as? String)!
                    
                    receivedData.append(cmtData)
                    
                }
            }
            catch {
                print ("JSON Data Error")
                return
            }
            
            //Complete
            print("Task Completed")
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            completeHandler(receivedData)
        })
        task.resume()
        
    }
    
    /*
     ユーザの存在確認を行う
     引数　 - id:uid, completeHandler:取得完了時の処理
     戻り値 - exsit:Int 0なら通信エラー、1なら存在、2なら存在しない
     備考　 - なし
     */
    

    var condition = NSCondition()
    
    func exist(id: Int, completeHandler: @escaping (Int)->()) {

        let postString = "uid=\(id)"

        var request = URLRequest(url: URL(string: urlExist)!)
        var exist = 0
        // 0なら通信エラー、1なら存在、2なら存在しない

        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, res, err) in
            if data != nil {

//                self.condition.lock()

                let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                DispatchQueue.main.async(execute: {

                })

                let note = text! as String

                print(note)
                if (note == ""){
                    self.exist = 2
                }else{
                    self.exist = 1
                }

            }else{
                DispatchQueue.main.async(execute: {
                    print("ERROR")
                    //通信エラーはexistを0で返す
                })
            }

            print("exist : \(self.exist)")
            completeHandler(self.exist)

//            self.condition.signal()
//            self.condition.unlock()

        })
//        self.condition.lock()
        task.resume()
//        self.condition.wait()
//        self.condition.unlock()


    }

    var exist = 0
    
    
    
    

//    func exist(id: Int) -> (Int) {
//
//        let postString = "uid=\(id)"
//
//        var request = URLRequest(url: URL(string: urlExist)!)
//        exist = 0
//        // 0なら通信エラー、1なら存在、2なら存在しない
//
//        request.httpMethod = "POST"
//        request.httpBody = postString.data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {
//            (data, res, err) in
//            if data != nil {
//                self.condition.lock()
////
//                let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                DispatchQueue.main.async(execute: {
////                    self.condition.lock()
//
//                    let note = text! as String
//                    print(note)
//                    if (note == ""){
//                        self.exist = 2
//
//                    }else{
//                        self.exist = 1
//                        print("exist4 = \(self.exist)")
//
//                    }
//
//
//                })
//            }else{
//                DispatchQueue.main.async(execute: {
//                    print("ERROR")
//                    //通信エラーはexistを0で返す
//                })
//            }
//
//            print("exist : \(self.exist)")
//
//            self.condition.signal()
//            self.condition.unlock()
//
//        })
//        condition.lock()
//
//        task.resume()
//        condition.wait()
//        condition.unlock()
//
//        print("exist2 : \(exist)")
//        return exist
//    }
    
    
}

/*履歴登録用のデータ構造体*/
struct activityData{
    var pedometer   = 0.0
    var distance    = 0.0
    var calorie     = 0.0
    var time        = 0.0
}

/*コメントデータ構造体*/
struct CommentData{
    var senderID   = 0
    var senderName = ""
    var sendDate   = "0-1-1 00:00:00"
    var Comment    = ""
}

/*ユーザ検索用*/
struct UsersData{
    var id = 0
    var name = ""
}

