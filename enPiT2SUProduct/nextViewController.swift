
import UIKit

class nextViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var dataList = [""]
    var dataList2 = [""]
    var dataList3 = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.goalType = 0
        
        dataList = createDate(from: 0, to: 100)
        dataList2 = createDate(num1: 0, num2: 5)
        dataList3 = createUnit()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(appDelegate.rowInt, inComponent: 0, animated: false)
        pickerView.selectRow(appDelegate.rowDouble, inComponent: 1, animated: false)
        pickerView.selectRow(appDelegate.rowUnit, inComponent: 2, animated: false)

        
        
        let hStr = UILabel()
        hStr.text = "."
        hStr.sizeToFit()
        hStr.frame = CGRectMake(pickerView.bounds.width/4 + 13 * hStr.bounds.width, pickerView.bounds.height + 2 * hStr.bounds.height , hStr.bounds.width, hStr.bounds.height)
            self.view.addSubview(hStr)
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))



    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return dataList.count
        }
        else if component == 1 {
            return dataList2.count
        }
        else {
            return dataList3.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return dataList[row]
        }
        else if component == 1 {
            return dataList2[row]
        }
        else {
            return dataList3[row]
        }
    }
    
    
    
    var row1 = Int()
    var row2 = Double()
    var row3 = Int()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            row3 = row
//            appDelegate.rowInt = row
        }
        else if component == 1 {
            row2 = Double(row) * 0.5
//            appDelegate.rowDouble = row
        }
        else {
            row1 = row
            appDelegate.goalType = row
//            appDelegate.rowUnit = row
        }
        print("row3 : ", row3)
        print("row2 : ", row2)
        print("row1 : ", row1)
        
        appDelegate.goalNum = Double(row3) + row2
        
//        if(row3 == 0 && row2 == 0.0){
//            pickerView.selectRow(1, inComponent: 1, animated: true)
//        }
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func createDate (from: Int,to :Int) -> [String]{
        var data = [String]()
        for num in from...to {
            data.append(String(num))
        }
        return data
    }
    
    func createDate (num1: Int,num2 :Int) -> [String]{
        var data = [String]()
        
        data.append(String(num1))
        data.append(String(num2))
        
        return data
    }
    
    
    func createUnit () -> [String]{
        var data = [String]()
        data.append("km")
        data.append("kcal")
        data.append("千步")
        return data
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }

    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
    
    
}



    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

