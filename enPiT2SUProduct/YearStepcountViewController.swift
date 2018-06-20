//
//  YearStepcountViewController.swift
//  enPiT2SUProduct
//
//  Created by Atsushi Ikeda on 2017/11/18.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import Charts
import Foundation

class YearStepcountViewController: UIViewController {

    @IBOutlet var barChartView: BarChartView!
    let years = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    var unitsSold = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var days: NSDate = NSDate()
    let recordMgr = RecordManager()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let thismonth = Calendar.current.component(.month, from: Date())
    let thisyear = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var year = Calendar.current.component(.year, from: Date())
    
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
        
        for month in 1...12 {
            switch month {
            case 1,3,5,7,8,10,12:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                var sum = 0
                for count in 01 ... 31 {
                    let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")!
                    let days = NSDate(timeInterval: 0, since: date)
                    sum += recordMgr.loadStepcount(date: days)
                }
                unitsSold[month - 1] = Int(sum)
            case 4,6,9,11:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                var sum = 0
                for count in 01 ... 30 {
                    let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                    days = NSDate(timeInterval: 0, since: date!)
                    sum += recordMgr.loadStepcount(date: days)
                }
                unitsSold[month - 1] = Int(sum)
            case 2:
                if year % 4 == 0 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    var sum = 0
                    for count in 01 ... 29 {
                        let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                        days = NSDate(timeInterval: 0, since: date!)
                        sum += recordMgr.loadStepcount(date: days)
                    }
                    unitsSold[month - 1] = Int(sum)
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    var sum = 0
                    for count in 1 ... 28 {
                        let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                        days = NSDate(timeInterval: 0, since: date!)
                        sum += recordMgr.loadStepcount(date: days)
                    }
                    unitsSold[month - 1] = Int(sum)
                }
            default:
                return
            }
        }
        setChart(dataPoints: years, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Int]){
        barChartView.noDataText = "You need to provide data for the chart."
        
        //        y軸
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "歩数（歩）")
        barChartView.data = BarChartData(dataSet: chartDataSet)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatterYear()
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        // x軸のラベルをボトムに表示
        barChartView.xAxis.labelPosition = .bottom
        
        // 横に赤いボーダーラインを描く
        let sGoal: Double = Double(appDelegate.goalPedo) * 31
        let nowLine = ChartLimitLine(limit: sGoal)
        barChartView.rightAxis.removeAllLimitLines()
        barChartView.rightAxis.addLimitLine(nowLine)
        if sGoal == 0.0{
            barChartView.rightAxis.removeAllLimitLines()
        }
    }
    func yearPrevBtn() {
        year -= 1
        createCharts()
    }
    
    func yearNextBtn() {
        year += 1
        createCharts()
    }
    
    func sum() -> Int{
        var sum = 0
        for i in 0...11 {
            sum += unitsSold[i]
        }
        return sum
    }
}
