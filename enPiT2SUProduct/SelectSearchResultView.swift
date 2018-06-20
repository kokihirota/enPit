//
//  SelectSearchResultView.swift
//  enPiT2SUProduct
//
//  Created by kimihiro on 2017/12/28.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import Foundation
import UIKit

class SelectSearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var resultListTable: UITableView!
    @IBOutlet weak var buttonBack: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultListTable.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var secondViewController:SecondViewController = segue.destination as! SecondViewController
        //secondViewController.param = self.paramText.text
        if (sender is UITableViewCell){
            let selectUser = sender as! UITableViewCell
            
            if(segue.destination is FifthViewController){
                let view = segue.destination as! FifthViewController
                //view.addFriendToTable(id: selectUser.tag)
                view.registReserveID = selectUser.tag
            }
        }
        
    }
    
    var userList: [UsersData] = []
    
    func addList(list: [UsersData]){
        for l in list{
            userList.append(l)
            print(l)
        }
    }
    
    func clearList(){
        userList.removeAll()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let item = userList[indexPath.row]
        cell.textLabel?.text = "\(item.name)  (id:\(item.id))"
        cell.tag = item.id
        return cell
    }
 
}
