//
//  MonthStepcountViewController.swift
//  enPiT2SUProduct
//
//  Created by Atsushi Ikeda on 2017/11/18.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import Charts

class MonthStepcountViewController: UIViewController {

    @IBOutlet var barChartView: BarChartView!
    var months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var unitsSold = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var days: NSDate = NSDate()
    let recordMgr = RecordManager()
    let thismonth = Calendar.current.component(.month, from: Date())
    let thisyear = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var year = Calendar.current.component(.year, from: Date())
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isFirstLoad = true
    var chartVIewCache: BarChartView!
    
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createCharts()
    }
    
    func createCharts() {
        
        switch month {
        case 1,3,5,7,8,10,12:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            for count in 01 ... 31 {
                let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")!
                let days = NSDate(timeInterval: 0, since: date)
                unitsSold[count - 1] = Double(recordMgr.loadStepcount(date: days))
            }
        case 4,6,9,11:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            for count in 01 ... 30 {
                let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                days = NSDate(timeInterval: 0, since: date!)
                unitsSold[count - 1] = Double(recordMgr.loadStepcount(date: days))
            }
        case 2:
            if year % 4 == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                for count in 01 ... 29 {
                    let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                    days = NSDate(timeInterval: 0, since: date!)
                    unitsSold[count - 1] = Double(recordMgr.loadStepcount(date: days))
                }
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                for count in 01 ... 28 {
                    let date = dateFormatter.date(from: "\(year)-\(month)-\(count) 00:00:00")
                    days = NSDate(timeInterval: 0, since: date!)
                    unitsSold[count - 1] = recordMgr.loadCalorie(date: days)
                }
            }
        default:
            return
        }
        
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        print("********cache:\(isFirstLoad)")
        if isFirstLoad{
            isFirstLoad = false
            chartVIewCache = barChartView
            print("****isCached****")
        }
        print("********cache:\(isFirstLoad)")
        print("********barChart:\(barChartView)")
        print("********barCache:\(chartVIewCache)")
        chartVIewCache.noDataText = "You need to provide data for the chart."
        
        //        y軸
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "歩数（歩）")
        chartVIewCache.data = BarChartData(dataSet: chartDataSet)
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatterMonth()
        chartVIewCache.xAxis.valueFormatter = xaxis.valueFormatter
        
        // x軸のラベルをボトムに表示
        chartVIewCache.xAxis.labelPosition = .bottom
        
        // 横に赤いボーダーラインを描く
        let sGoal: Double = Double(appDelegate.goalPedo)
        let nowLine = ChartLimitLine(limit: sGoal)
        barChartView.rightAxis.removeAllLimitLines()
        barChartView.rightAxis.addLimitLine(nowLine)
        if sGoal == 0.0{
            barChartView.rightAxis.removeAllLimitLines()
        }
 
    }
    
    func monthPrevBtn() {
        if month == 1 {
            year -= 1
            month = 12
            createCharts()
        } else {
            month -= 1
            createCharts()
        }
    }
    
    func monthNextBtn() {
        if month == 12 {
            year += 1
            month = 1
            createCharts()
        } else {
            month += 1
            createCharts()
        }
    }
    
    func sum() -> Double{
        var sum = 0.0
        for i in 0...30 {
            sum += unitsSold[i]
        }
        return sum
    }
}


