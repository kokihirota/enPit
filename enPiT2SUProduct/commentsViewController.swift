//
//  commentsViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/12/21.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit

class commentsViewController: UIViewController {
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsLabel.text = ""
        HistoryShareMgr().getComent(id: Int(appDelegate.uid)!, completeHandler: {(receivedComment) in
            
            for comment in receivedComment {
                self.commentsLabel.text = self.commentsLabel.text! + "Name : \(comment.senderName) \nUID : \(comment.senderID)\nComment : \(comment.Comment) \n\n"
                self.commentsLabel.numberOfLines += 4
                
            }
            
            
            
        })
        
        // Do any additional setup after loading the view.
    }

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    
 
    /*
//     let urlGetComment      = "http://192.168.0.9/ihonki/getcomment.php"
    
    let urlGetComment      = "http://ihonki.sytes.net/ihonki/getcomment.php"
    
    func getComent(uid: Int, completeHandler: @escaping (_ comments: [CommentData])->()){
        //Check ID
        if(uid <= 0){
            print("Invalid UID")
            return
        }
        
        var receivedComment :[CommentData] = []
        let postString = "uid=\(uid)"
        
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
            //print("response: \(response!)")
            //let output = String(data: data!, encoding: .utf8)!
            //print("output: \(output)")
            
            completeHandler(receivedComment)
        })
        task.resume()
        
    }
    
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
