
//
//  WeekViewController.swift
//  enPiT2SUProduct
//
//  Created by Atsushi Ikeda on 2017/10/21.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import Charts

class WeekViewController: UIViewController {
    
    @IBOutlet var barChartView: BarChartView!
    
    var days: NSDate = NSDate()
    let recordMgr = RecordManager()
    var weeks = ["0", "0", "0", "0", "0", "0", "0"]
    var unitsSold = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var year = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = true
        barChartView.chartDescription?.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.axisMinimum = 0.0
        
        createCharts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createCharts()
    }
    
    
    func createCharts() {
        //        for文で各配列に値を代入
        for count in 0...6 {
            let time: Double = Double(-60 * 60 * 24.0 * Double((6 - count)))
            days = NSDate(timeIntervalSinceNow: time)
            unitsSold[count] = recordMgr.loadCalorie(date: days)
            weeks[count] = String(Calendar.current.component(.day, from: days as Date))
        }
 
        /*let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        for count in (0 ... 6).reversed() {
            let date = dateFormatter.date(from: "\(year)-\(month)-\(day - count) 00:00:00")!
            days = NSDate(timeInterval: 0, since: date)
            unitsSold[count] = recordMgr.loadCalorie(date: days)
            weeks[count] = day
        }*/
        
        setChart(dataPoints: weeks, values: unitsSold)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]){
        barChartView.noDataText = "You need to provide data for the chart."
        
        //        y軸
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "カロリー(kcal)")
        barChartView.data = BarChartData(dataSet: chartDataSet)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatterWeek()
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        // x軸のラベルをボトムに表示
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.extraBottomOffset = 0.0
        
        // 横に赤いボーダーラインを描く
        let cGoal: Double = appDelegate.goalCalo
        let nowLine = ChartLimitLine(limit: cGoal)
        barChartView.rightAxis.removeAllLimitLines()
        barChartView.rightAxis.addLimitLine(nowLine)
        if cGoal == 0.0{
            barChartView.rightAxis.removeAllLimitLines()
        }
    }
    
    func sum() -> Double{
        var sum = 0.0
        for i in 0...6 {
            sum += unitsSold[i]
        }
        return sum
    }
    
}

public class BarChartFormatterWeek: NSObject, IAxisValueFormatter{
    
    // x軸のラベル
    var weeks = [String]()
    var days: NSDate = NSDate()
    // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        for count in 0...6 {
            let time: Double = Double(-60 * 60 * 24.0 * Double((6 - count)))
            days = NSDate(timeIntervalSinceNow: time)
            let a = Calendar.current.component(.day, from: days as Date)
            weeks.append(String(a))
        }
        
        return weeks[Int(value)]
    }
}
