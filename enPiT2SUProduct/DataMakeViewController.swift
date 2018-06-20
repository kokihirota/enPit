//
//  DataMakeViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2018/01/11.
//  Copyright © 2018年 enPiT2SU. All rights reserved.
//

import UIKit

class DataMakeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var resultUpload = activityData()
    
    @IBOutlet weak var uidTextField: UITextField!
    
    
    @IBOutlet weak var caloTextField: UITextField!
    
    @IBOutlet weak var pedoTExtField: UITextField!
    
    @IBOutlet weak var distTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        resultUpload.calorie = Double(caloTextField.text!)!
        resultUpload.distance = Double(distTextField.text!)!
        resultUpload.pedometer = Double(pedoTExtField.text!)!
        resultUpload.time = Double(timeTextField.text!)!
            
            
        HistoryShareMgr().historyUpload(id: Int(uidTextField.text!)!, date: Date() as NSDate, data: resultUpload, completeHandler: {
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
