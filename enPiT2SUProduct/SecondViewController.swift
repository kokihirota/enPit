//
//  SecondViewController.swift
//  enPiT2SUProduct
//
//  Created by s15ti050 on 2017/10/13.
//  Copyright © 2017年 enPiT2SU. All rights reserved.
//

import UIKit
import Charts


class SecondViewController: UIViewController, ChartViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
   
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let tableView = UITableView()
    
    let weekIdList: [String] = ["WeekViewController", "WeekDistanceViewController", "WeekStepcountViewController"]
    let monthIdList: [String] = ["MonthViewController", "MonthDistanceViewController", "MonthStepcountViewController"]
    let yearIdList: [String] = ["YearViewController", "YearDistanceViewController", "YearStepcountViewController"]
    
    var weekPageViewController: UIPageViewController!
    var monthPageViewController: UIPageViewController!
    var yearPageViewController: UIPageViewController!
    var weekViewControllers: [UIViewController] = []
    var monthViewControllers: [UIViewController] = []
    var yearViewControllers: [UIViewController] = []
    
    var nowViewController: UIViewController!
    
    var nowView = 0
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var kyori: UILabel!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var hosuu: UILabel!
    @IBOutlet weak var headerPrevBtn: UIBarButtonItem!
    @IBOutlet weak var headerNextBtn: UIBarButtonItem!
    @IBOutlet weak var headerTitle: UINavigationItem!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var headerBarTitle: UINavigationItem!
    @IBOutlet weak var headerBar: UINavigationBar!
    
    var containers: Array<UIView> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        super.didReceiveMemoryWarning()
//        kyori.text  =  "300km"
//        calorie.text =  "100000kcal"
//        hosuu.text =    "5"
        
        containers = [weekView, monthView, yearView]
        containerView.bringSubview(toFront: weekView)
        
        
        
        for id in weekIdList {
            weekViewControllers.append((storyboard?.instantiateViewController(withIdentifier: id))!)
            _ = weekViewControllers.last!.view
        }
        for id in monthIdList {
            monthViewControllers.append((storyboard?.instantiateViewController(withIdentifier: id))!)
            _ = monthViewControllers.last!.view
        }
        for id in yearIdList {
            yearViewControllers.append((storyboard?.instantiateViewController(withIdentifier: id))!)
            _ = yearViewControllers.last!.view
        }
        
        weekPageViewController = childViewControllers[0] as! UIPageViewController
        monthPageViewController = childViewControllers[1] as! UIPageViewController
        yearPageViewController = childViewControllers[2] as! UIPageViewController
        weekPageViewController.setViewControllers([weekViewControllers[0]], direction: .forward, animated: true, completion: nil)
        monthPageViewController.setViewControllers([monthViewControllers[0]], direction: .forward, animated: true, completion: nil)
        yearPageViewController.setViewControllers([yearViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        weekPageViewController.dataSource = self
        weekPageViewController.delegate = self
        monthPageViewController.dataSource = self
        monthPageViewController.delegate = self
        yearPageViewController.dataSource = self
        yearPageViewController.delegate = self
        
        headerBarTitle.title = String("週")
        headerPrevBtn.customView?.alpha = 0
        headerNextBtn.customView?.alpha = 0
        
        changeLabel()
        
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarBackgroundColor(color: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        nowViewController = viewController
        
        switch nowView {
        case 0:
            let weekIndex = weekIdList.index(of: viewController.restorationIdentifier!)!
            if (weekIndex > 0) {
                return weekViewControllers[weekIndex - 1]
            }
            
        case 1:
            let monthIndex = monthIdList.index(of: viewController.restorationIdentifier!)!
            if (monthIndex > 0) {
                return monthViewControllers[monthIndex - 1]
            }
            
        case 2:
            let yearIndex = yearIdList.index(of: viewController.restorationIdentifier!)!
            if (yearIndex > 0) {
                return yearViewControllers[yearIndex - 1]
            }
            
        default:
            return nil
        }
        return nil
    }

    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nowViewController = viewController
        
        switch nowView {
        case 0:
            let weekIndex = weekIdList.index(of: viewController.restorationIdentifier!)!
            if (weekIndex < weekIdList.count - 1) {
                return weekViewControllers[weekIndex + 1]
            }
            
            
        case 1:
            let monthIndex = monthIdList.index(of: viewController.restorationIdentifier!)!
            if (monthIndex < monthIdList.count - 1) {
                return monthViewControllers[monthIndex + 1]
            }
            
        case 2:
            let yearIndex = yearIdList.index(of: viewController.restorationIdentifier!)!
            if (yearIndex < yearIdList.count - 1) {
                return yearViewControllers[yearIndex + 1]
            }
            
        default:
            return nil
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let currentContainerView = containers[sender.selectedSegmentIndex]
        containerView.bringSubview(toFront: currentContainerView)
        
        
        let weekview0 = weekViewControllers[0] as! WeekViewController
        let weekview1 = weekViewControllers[1] as! WeekDistanceViewController
        let weekview2 = weekViewControllers[2] as! WeekStepcountViewController
        let monthview0 = monthViewControllers[0] as! MonthViewController
        let monthview1 = monthViewControllers[1] as! MonthDistanceViewController
        let monthview2 = monthViewControllers[2] as! MonthStepcountViewController
        let yearview0 = yearViewControllers[0] as! YearViewController
        let yearview1 = yearViewControllers[1] as! YearDistanceViewController
        let yearview2 = yearViewControllers[2] as! YearStepcountViewController
        
        weekview0.view.alpha = 0
        weekview1.view.alpha = 0
        weekview2.view.alpha = 0
        monthview0.view.alpha = 0
        monthview1.view.alpha = 0
        monthview2.view.alpha = 0
        yearview0.view.alpha = 0
        yearview1.view.alpha = 0
        yearview2.view.alpha = 0
        headerPrevBtn.customView?.alpha = 0
        headerNextBtn.customView?.alpha = 0
        
        switch sender.selectedSegmentIndex {
        case 0:
            changeLabel()
            weekPageViewController.setViewControllers([weekViewControllers[0]], direction: .forward, animated: false, completion: nil)
            nowView = 0
            headerBarTitle.title = String("週")
            
            weekview0.view.alpha = 1
            weekview1.view.alpha = 1
            weekview2.view.alpha = 1
            
        case 1:
            changeLabel()
            monthPageViewController.setViewControllers([monthViewControllers[0]], direction: .forward, animated: false, completion: nil)
            nowView = 1
            headerBarTitle.title = "\(monthview0.headerYearTitle())年\(monthview0.headerMonthTitle())月"
            
            monthview0.view.alpha = 1
            monthview1.view.alpha = 1
            monthview2.view.alpha = 1
            headerPrevBtn.customView?.alpha = 1
            headerNextBtn.customView?.alpha = 1
            
        case 2:
            changeLabel()
            yearPageViewController.setViewControllers([yearViewControllers[0]], direction: .forward, animated: false, completion: nil)
            nowView = 2
            headerBarTitle.title = "\(yearview0.headerTitle())年"
            
            yearview0.view.alpha = 1
            yearview1.view.alpha = 1
            yearview2.view.alpha = 1
            headerPrevBtn.customView?.alpha = 1
            headerNextBtn.customView?.alpha = 1
            
        default: break
 
        }
    }
    
    @IBAction func prevButton(_ sender: UIButton) {
        switch segmentedController.selectedSegmentIndex {
        case 1:
            let view0 = monthViewControllers[0] as! MonthViewController
            let view1 = monthViewControllers[1] as! MonthDistanceViewController
            let view2 = monthViewControllers[2] as! MonthStepcountViewController
            view0.monthPrevBtn()
            view1.monthPrevBtn()
            view2.monthPrevBtn()
            changeLabel()
            headerBarTitle.title = "\(view0.headerYearTitle())年\(view0.headerMonthTitle())月"
            
        case 2:
            let view0 = yearViewControllers[0] as! YearViewController
            view0.yearPrevBtn()
            let view1 = yearViewControllers[1] as! YearDistanceViewController
            view1.yearPrevBtn()
            let view2 = yearViewControllers[2] as! YearStepcountViewController
            view2.yearPrevBtn()
            changeLabel()
            headerBarTitle.title = "\(view0.headerTitle())年"
            
        default:
            return
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            changeLabel()
            
        case 1:
            let view0 = monthViewControllers[0] as! MonthViewController
            let view1 = monthViewControllers[1] as! MonthDistanceViewController
            let view2 = monthViewControllers[2] as! MonthStepcountViewController
            view0.monthNextBtn()
            view1.monthNextBtn()
            view2.monthNextBtn()
            changeLabel()
            headerBarTitle.title = "\(view0.headerYearTitle())年\(view0.headerMonthTitle())月"
            
        case 2:
            
            let view0 = yearViewControllers[0] as! YearViewController
            view0.yearNextBtn()
            let view1 = yearViewControllers[1] as! YearDistanceViewController
            view1.yearNextBtn()
            let view2 = yearViewControllers[2] as! YearStepcountViewController
            view2.yearNextBtn()
            changeLabel()
            headerBarTitle.title = "\(view0.headerTitle())年"
            
        default:
            return
        }
    }
    
    func changeLabel() {
        let weekview0 = weekViewControllers[0] as! WeekViewController
        let weekview1 = weekViewControllers[1] as! WeekDistanceViewController
        let weekview2 = weekViewControllers[2] as! WeekStepcountViewController
        let monthview0 = monthViewControllers[0] as! MonthViewController
        let monthview1 = monthViewControllers[1] as! MonthDistanceViewController
        let monthview2 = monthViewControllers[2] as! MonthStepcountViewController
        let yearview0 = yearViewControllers[0] as! YearViewController
        let yearview1 = yearViewControllers[1] as! YearDistanceViewController
        let yearview2 = yearViewControllers[2] as! YearStepcountViewController
        
        print("ChangeLabel:\(segmentedController.selectedSegmentIndex)")
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            let view0: String = NSString(format: "%.2f", weekview0.sum()) as String
            let view1: String = NSString(format: "%.2f", weekview1.sum()) as String
            let view2: String = NSString(format: "%.0f", weekview2.sum()) as String
            kyori.text  =  "\(view1)"
            calorie.text =  "\(view0)"
            hosuu.text =    "\(view2)"
            
        case 1:
            let view0: String = NSString(format: "%.2f", monthview0.sum()) as String
            let view1: String = NSString(format: "%.2f", monthview1.sum()) as String
            let view2: String = NSString(format: "%.0f", monthview2.sum()) as String
            kyori.text  =  "\(view1)"
            calorie.text =  "\(view0)"
            hosuu.text =    "\(view2)"
            
        case 2:
            let view0: String = NSString(format: "%.2f", yearview0.sum()) as String
            let view1: String = NSString(format: "%.2f", yearview1.sum()) as String
            let view2: String = NSString(format: "%.0f", yearview2.sum()) as String
            kyori.text  =  "\(view1)"
            calorie.text =  "\(view0)"
            hosuu.text =    "\(view2)"
            
        default:
            return
        }
        return
    }
}
