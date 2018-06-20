//
//  DetailViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/11/28.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var Label2: UILabel!
    
    var info: UserInfo!
    
    

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if (textField.text != ""){
            HistoryShareMgr().addComent(senderID: Int(appDelegate.uid)!, receiverID: Int(info.uid)!, date: Date() as NSDate, comment: textField.text!, completeHandler:{
            })
            alert("Complete", messageString: "送信完了しました。", buttonString: "OK")
        }else{
            alert("Empty!", messageString: "メッセージが未入力です。", buttonString: "OK")
        }
    }
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = info.name

        label.text = "今月のデータ\n歩数 　　　　: " + info.pedo + " 步 \n距離 　　　　: " + String(format: "%.02f" , Double(info.dist)!) + " km \n消費カロリー : " + String(format: "%.02f" , Double(info.calo)!) + " kcal"

        
        Label2.text = "今週のデータ\n歩数 　　　　: " + info.pedo1 + " 步 \n距離 　　　　: " + String(format: "%.02f" , Double(info.dist1)!) + " km \n消費カロリー : " + String(format: "%.02f" , Double(info.calo1)!) + " kcal"

        textField.placeholder = "送信したいメッセージを入力"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(_ titleString: String, messageString: String, buttonString: String){
        //Create UIAlertController
        let alert: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        //Create action
        let action = UIAlertAction(title: buttonString, style: .default) { action in
            NSLog("\(titleString):Push button!")
        }
        //Add action
        alert.addAction(action)
        //Start
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        outputText.text = inputText.text
        self.view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    
}
