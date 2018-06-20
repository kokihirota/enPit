//
//  FifthViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/11/14.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//


import UIKit

struct UserInfo {
    var uid: String
    var name: String
    var pedo: String
    var dist: String
    var time: String
    var calo: String
    var pedo1: String
    var dist1: String
    var time1: String
    var calo1: String
    
}

class FifthViewController: UIViewController, UITableViewDataSource {
    
    let button = UIButton()
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {
        tableView.reloadData()
        
    }
    
    @IBAction func goNext(_ sender:UIButton) {
        let next = storyboard!.instantiateViewController(withIdentifier: "commentsView")
        self.present(next,animated: true, completion: nil)
    }
    
    let defaults = UserDefaults.standard
    var friendsUid = [""]
    var registReserveID = -1
    //データ更新のタイミング調整
    var condition = NSCondition()
    
  
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var items : [UserInfo] = []
    var comment :[CommentData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate();

        // Do any additional setup after loading the view, typically from a nib.
        

        tableView.dataSource = self
        
        //inputText.delegate = self as? UITextFieldDelegate
        
        //表示されるテキスト
        button.setTitle("＋", for: .normal)
        //テキストの色
        button.setTitleColor(UIColor.white, for: .normal)
        //位置
        button.frame = CGRect.init(x: 250, y: 450, width: 50, height: 50)
        //背景色
        button.backgroundColor = UIColor(red: 0.4, green: 0.95, blue: 0.9, alpha: 1)
        //角丸
        button.layer.cornerRadius = 25
        //ボタンタイトルのフォントサイズ
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        //ボタンをタップした時に実行するメソッドを指定
        button.addTarget(self, action: #selector(FifthViewController.buttonTapped(sender: )), for: .touchUpInside)
        //viewにボタンを追加する
        self.view.addSubview(button)

        user()
        print(friendsUid)

        allHistoryLoad()

 
        self.tableView.reloadData()
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
        
    }
    
    //画面再表示時
    override func viewWillAppear(_ animated: Bool) {
        //もし登録予約がいたらとうろくする
        if(registReserveID != -1){
            addFriendToTable(id: registReserveID)
            registReserveID = -1
        }
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //全てのフレンドの履歴再読み込み
    func allHistoryLoad(){
        var i = 0
        var k = 0
        var j = 0
        
        items.removeAll()
        for friendUid in friendsUid {
            if (friendUid == "" || Int(friendUid) == nil){
                continue
                //break
            }
            
            self.items += [UserInfo(uid: friendUid, name: "", pedo: "", dist: "", time: "", calo: "",pedo1: "", dist1: "", time1: "", calo1: "" )]
            
            HistoryShareMgr().getName(id: Int(friendUid)!, completeHandler: {(newName) in
                print(i)
                self.condition.lock()
                self.items[i].name = newName
                self.condition.signal()
                self.condition.unlock()
                i += 1
            })
            
            condition.wait()
            condition.unlock()
            
            HistoryShareMgr().historyDownload(id: Int(friendUid)!, begin: Date(timeInterval: -31 * 24 * 60 * 60, since: Date()) as NSDate , end: Date() as NSDate, completeHandler: {(actData) in
                print(k)
                self.items[k].calo = String(actData.calorie)
                self.items[k].pedo = String(actData.pedometer)
                self.items[k].dist = String(actData.distance)
                self.items[k].time = String(actData.time)
                k += 1
            })
            
            HistoryShareMgr().historyDownload(id: Int(friendUid)!, begin: Date(timeInterval: -7 * 24 * 60 * 60, since: Date()) as NSDate , end: Date() as NSDate, completeHandler: {(actData) in
                print(k)
                self.items[j].calo1 = String(actData.calorie)
                self.items[j].pedo1 = String(actData.pedometer)
                self.items[j].dist1 = String(actData.distance)
                self.items[j].time1 = String(actData.time)
                j += 1
            })
            
        }
        tableView.reloadData()
    }
    
    //フレンド一覧を保存値から読み込む
    func user() {
        if let aaa = defaults.object(forKey: "friendsUid"){
            friendsUid = aaa as! [String]
            print("aaa")
        }
    }
    
    //ユーザを追加保存する
    func usersave(friendUid : String) {
        friendsUid += [friendUid]
        defaults.set(friendsUid, forKey: "friendsUid")
        defaults.synchronize()
    }
    
    func usersave(friendsUid : [String]){
        defaults.set(friendsUid, forKey: "friendsUid")
        defaults.synchronize()
    }
    
    @objc func buttonTapped(sender : AnyObject) {
        // テキストフィールド付きアラート表示
        let alert = UIAlertController(title: "登録したい人の名前を入力してください。", message: "", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            var text = ""
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    print(textField.text!)
                    text += textField.text!
                    
                }
                self.addFrfiend(inputText: text)
            }
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "名前"
        })
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NameCell")
        let item = items[indexPath.row]
        cell.textLabel?.text = "  \(item.name)"
        return cell
    }
    
    //削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            friendsUid.remove(at: indexPath.row)
            usersave(friendsUid: friendsUid)
        }

    }
    
    //削除ボタンの色の設定
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DetailViewController
            controller.info = items[selectedRow.row]
        }
    }
    
    
    
    //PHP
    @IBOutlet weak var resultLabel: UILabel!

    //download
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        var i = 0
        var k = 0
        var j = 0
        for item in items {
            
            HistoryShareMgr().getName(id: Int(item.uid)!, completeHandler: {(newName) in
                self.condition.lock()
                self.items[i].name = newName
                self.condition.signal()
                self.condition.unlock()
                i += 1
            })
            
            condition.wait()
            condition.unlock()
            
            //一ヶ月分のデータ
            HistoryShareMgr().historyDownload(id: Int(item.uid)!, begin: Date(timeInterval: -31 * 24 * 60 * 60, since: Date()) as NSDate , end: Date() as NSDate, completeHandler: {(actData) in
                print(k)
                self.items[k].calo = String(actData.calorie)
                self.items[k].pedo = String(actData.pedometer)
                self.items[k].dist = String(actData.distance)
                self.items[k].time = String(actData.time)
                k += 1
            })
            
//            一週間分のデータ
            HistoryShareMgr().historyDownload(id: Int(item.uid)!, begin: Date(timeInterval: -7 * 24 * 60 * 60, since: Date()) as NSDate , end: Date() as NSDate, completeHandler: {(actData) in
                print(k)
                self.items[j].calo1 = String(actData.calorie)
                self.items[j].pedo1 = String(actData.pedometer)
                self.items[j].dist1 = String(actData.distance)
                self.items[j].time1 = String(actData.time)
                j += 1
            })
            
            print("aaaaaa")

            tableView.reloadData()
        }
        self.tableView.reloadData()
        alert("Update", messageString: "データを更新しました。", buttonString: "OK")
    }
    
    func reloadTable() {
        tableView.reloadData()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //Close keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func addFriendToTable(id: Int){
        var existCheck = false
        var name = ""
        
        //多重フレンド登録防止
        for i in items{
            let uid = Int(i.uid)
            if (uid == id){
                existCheck = true
                name = i.name
            }
        }
        if(existCheck){
            alert("Already exist", messageString: "\(name)さんはすでに登録済みです！", buttonString: "OK")
            return
        }
        
        //登録実行するよ
        usersave(friendUid: String(id))
        tableView.reloadData()
        allHistoryLoad()
        
        name = items[items.count - 1].name
        alert("Exist", messageString: "\(name)さんを登録しました。", buttonString: "OK")
    }
    
    func addFrfiend(inputText :String) {
        var resultList: [UsersData] = []

        if(inputText == ""){//空白はやめて
            alert("Empty", messageString: "名前が未入力です。", buttonString: "OK")
            return
        }
        
        //サーバまで探しに行って
        HistoryShareMgr().searchUser(name: inputText, completeHandler: {
            (userList) in
                
            self.condition.lock()
                
            resultList = userList

            self.condition.signal()
            self.condition.unlock()
        })
            
        condition.wait()
        condition.unlock()
            
        if(resultList.count == 0){//見つからなかったよ
            self.alert("Not found", messageString: "\(inputText)さんが見つかりませんでした。", buttonString: "OK")
            return
        }
            
        if(resultList.count == 1){//1人見つかったよ
            self.addFriendToTable(id: resultList[0].id)
            return
        }
            
        if(resultList.count > 1){//たくさん見つかったよ
            //self.alert("Exist", messageString: "\(inputText)がたくさん見つかりました。", buttonString: "OK")
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "searchResultView")
            (nextView as! SelectSearchResultViewController).addList(list: resultList)
            present(nextView, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
 
}


