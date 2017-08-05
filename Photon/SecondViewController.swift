//
//  SecondViewController.swift
//
//  Created by Rishi Pochiraju on 3/19/16.
//  Copyright © 2016 Rishi P. All rights reserved.

import UIKit
import EventKit
import GoogleMobileAds

var userTime = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
var tableViewEvents:[EKEvent] = []
var aTime:String = ""

var angleArc = 0.0

var allDayEventArray:[EKEvent] = []
class SecondViewController: UIViewController {
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var minuteCast: DisplayMinuteCast!
    @IBOutlet var displayHandTime: UILabel!
    
    @IBOutlet weak var screenEventLabel: UILabel!
    @IBOutlet var DisplayOtherEventsButton: UIButton!
    
    @IBOutlet var AllDayEventLabel: UILabel!
    @IBOutlet var MoreAllDayEventsButton: UIButton!
    
    let pi = M_PI
    let deg = M_PI/180
    
    var cent:CGPoint = CGPoint()
    let radius = 130.5 //on an iPhone 6/6s, shouldn't matter
    var a = 0.0 //center x
    var b = 0.0 //center y
    var c = 0.0 //top x
    var d = 0.0 //top y
    
    var calendar: EKCalendar!
    var events: [EKEvent]?
    
    var userEnteredViewAt:String = userTime
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(noAccess == true){
            let scheduledAlert = UIAlertController(title: "Photon needs access to your calendar", message: "Go to Settings > Photon to enable", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            }
            scheduledAlert.addAction(okAction)
            self.present(scheduledAlert, animated: true, completion: nil)
        }
        
        bannerView.adUnitID = "ca-app-pub-2830059983414219/1713346287"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        changeLabelPositions()
        self.tabBarController!.tabBar.barTintColor = UIColor(red:109/255.0, green: 146/255.0, blue: 155/255.0, alpha: 0.7)
        
        let nowLabel = UILabel(frame: CGRect(x: 0, y: (170/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 21))
        if (self.view.frame.size.height == 480.0){
            nowLabel.frame = CGRect(x: 0, y: (190/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 21)
        }
        nowLabel.textAlignment = NSTextAlignment.center
        nowLabel.text = "Now"
        nowLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        nowLabel.font = UIFont(name: "Futura", size: 17)
        self.view.addSubview(nowLabel)
        
        let tLabel = UILabel(frame: CGRect(x: 0, y: (304/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 56))
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.text = "Current Time"
        tLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        tLabel.font = UIFont(name: "Futura", size: self.view.frame.size.height / 27.7916667)
        self.view.addSubview(tLabel)
        
        displayHandTime = tLabel
        
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCalendarAuthorizationStatus()
        
        changeLabelPositions()
        initialize()
        self.tabBarController?.tabBar.tintColor = tabbartint
        let at = [NSForegroundColorAttributeName: tabbartint]
        self.tabBarItem.setTitleTextAttributes(at, for: UIControlState.selected)
    }
    
    func changeLabelPositions() {
        let height:Double = Double(self.view.frame.size.height)
        
        if (height == 519.0 || height == 568.0){
            
            let nowLabel = UILabel(frame: CGRect(x: 0, y: 85, width: self.view.frame.size.width, height: 21))
            nowLabel.textAlignment = NSTextAlignment.center
            nowLabel.text = "No Events"
            nowLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            nowLabel.font = UIFont(name: "Gill Sans", size: 19)
            self.view.addSubview(nowLabel)
            screenEventLabel.removeFromSuperview()
            screenEventLabel = nowLabel
            
            let seeTasks: UIButton = UIButton(frame: CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: 15))
            seeTasks.setTitle("Show More", for: UIControlState())
            seeTasks.titleLabel?.font = UIFont(name: "Futura", size: 15)
            seeTasks.setTitleColor(UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0), for: UIControlState())
            seeTasks.addTarget(self, action: #selector(SecondViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(seeTasks)
            DisplayOtherEventsButton.removeFromSuperview()
            DisplayOtherEventsButton = seeTasks
            
            let adLabel = UILabel(frame: CGRect(x: 0, y: 420, width: self.view.frame.size.width, height: 21))
            adLabel.textAlignment = NSTextAlignment.center
            adLabel.text = "No All Day Events"
            adLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            adLabel.font = UIFont(name: "Futura", size: 15)
            self.view.addSubview(adLabel)
            AllDayEventLabel.removeFromSuperview()
            AllDayEventLabel = adLabel
            
            let seeAD: UIButton = UIButton(frame: CGRect(x: 0, y: 443, width: self.view.frame.size.width, height: 15))
            seeAD.setTitle("Show More", for: UIControlState())
            seeAD.titleLabel?.font = UIFont(name: "Futura", size: 15)
            seeAD.setTitleColor(UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0), for: UIControlState())
            seeAD.addTarget(self, action: #selector(SecondViewController.buttonActionAD(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(seeAD)
            MoreAllDayEventsButton.removeFromSuperview()
            MoreAllDayEventsButton = seeAD
            
        }else if (height == 431.0 || height == 480.0){
            
            let nowLabel = UILabel(frame: CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: 21))
            nowLabel.textAlignment = NSTextAlignment.center
            nowLabel.text = "No Events"
            nowLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            nowLabel.font = UIFont(name: "Gill Sans", size: 19)
            self.view.addSubview(nowLabel)
            screenEventLabel.removeFromSuperview()
            screenEventLabel = nowLabel
            
            let seeTasks: UIButton = UIButton(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 15))
            seeTasks.setTitle("Show More", for: UIControlState())
            seeTasks.titleLabel?.font = UIFont(name: "Futura", size: 15)
            seeTasks.setTitleColor(UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0), for: UIControlState())
            seeTasks.addTarget(self, action: #selector(SecondViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(seeTasks)
            DisplayOtherEventsButton.removeFromSuperview()
            DisplayOtherEventsButton = seeTasks
            
            let adLabel = UILabel(frame: CGRect(x: 0, y: 340, width: self.view.frame.size.width, height: 21))
            adLabel.textAlignment = NSTextAlignment.center
            adLabel.text = "No All Day Events"
            adLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            adLabel.font = UIFont(name: "Futura", size: 15)
            self.view.addSubview(adLabel)
            AllDayEventLabel.removeFromSuperview()
            AllDayEventLabel = adLabel
            
            let seeAD: UIButton = UIButton(frame: CGRect(x: 0, y: 363, width: self.view.frame.size.width, height: 15))
            seeAD.setTitle("Show More", for: UIControlState())
            seeAD.titleLabel?.font = UIFont(name: "Futura", size: 15)
            seeAD.setTitleColor(UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0), for: UIControlState())
            seeAD.addTarget(self, action: #selector(SecondViewController.buttonActionAD(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(seeAD)
            MoreAllDayEventsButton.removeFromSuperview()
            MoreAllDayEventsButton = seeAD
        }
    }
    
    func buttonAction(_ sender: UIButton){
        self.performSegue(withIdentifier: "seeMore", sender: UIButton())
    }
    
    func buttonActionAD(_ sender: UIButton){
        self.performSegue(withIdentifier: "seeMoreAD", sender: UIButton())
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            goToSettings = false
            hasAccess = true
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //self.performSegueWithIdentifier("goToSettings", sender: nil)
            goToSettings = true
            hasAccess = false
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                })
                goToSettings = false
            } else {
                DispatchQueue.main.async(execute: {
                })
            }
        } as! EKEventStoreRequestAccessCompletionHandler)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEvents(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh-mm"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position:CGPoint = touch.preciseLocation(in: view)
            let x = Double(position.x)
            let y = Double(position.y)
            
            let center1 = (a - x)*(a - x)
            let center2 = (b - y)*(b - y)
            let distanceFromCenter = sqrt(center1 + center2)
            
            let top1 = (c - x)*(c - x)
            let top2 = (d - y)*(d - y)
            let distanceFromTop = sqrt(top1 + top2)
            
            let numerator = (radius * radius) + (distanceFromCenter * distanceFromCenter) - (distanceFromTop * distanceFromTop)
            let denominator = 2 * radius * distanceFromCenter
            let divide = numerator/denominator
            
            angleArc = acos(divide) * 180/pi
            
            
            if (x < Double(self.view.center.x)){
                angleArc = 360 - angleArc
            }
            
            if (angleArc >= 359){
                angleArc = 0
            }
            
            minuteCast.setNeedsDisplay()
            
            updateTimeText()
            if(goToSettings == false){
                findEvent()
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position:CGPoint = touch.preciseLocation(in: view)
            let x = Double(position.x)
            let y = Double(position.y)
            
            let center1 = (a - x)*(a - x)
            let center2 = (b - y)*(b - y)
            let distanceFromCenter = sqrt(center1 + center2)
            
            let top1 = (c - x)*(c - x)
            let top2 = (d - y)*(d - y)
            let distanceFromTop = sqrt(top1 + top2)
            
            let numerator = (radius * radius) + (distanceFromCenter * distanceFromCenter) - (distanceFromTop * distanceFromTop)
            let denominator = 2 * radius * distanceFromCenter
            let divide = numerator/denominator
            
            angleArc = acos(divide) * 180/pi
            
            if (x < Double(self.view.center.x)){
                angleArc = 360 - angleArc
            }
            
            if (angleArc >= 359){
                angleArc = 0
            }
            
            minuteCast.setNeedsDisplay()
            
            
            updateTimeText()
            if(goToSettings == false){
                findEvent()
            }
        }
        
    }
    
    func updateTimeText(){
        userTime = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        let first = userTime.components(separatedBy: " ")
        let next = first[3].components(separatedBy: ":")
        var amOrPm = first[4]
        
        
        var hours =  Int(next[0])!
        var minutes = Int(angleArc/2) + Int(next[1])!
        
        if (minutes >= 60){
            hours += 1
            minutes = minutes - 60
            if (minutes >= 60){
                hours = hours + 1
                minutes = minutes - 60
                if (minutes >= 60){
                    hours = hours + 1
                    minutes = minutes - 60
                }
            }
        }
        
        if (Int(next[0])! != 12){
            if (hours >= 12){
                if (amOrPm == "AM"){
                    amOrPm = "PM"
                }else{
                    amOrPm = "AM"
                }
                if (hours > 12){
                    hours = hours - 12
                }
            }
        }
        
        if (hours == Int(next[0])! && minutes == Int(next[1])! - 1){
            hours = hours + 3
            if (hours >= 12){
                if (amOrPm == "AM"){
                    amOrPm = "PM"
                }else{
                    amOrPm = "AM"
                }
                if (hours > 12){
                    hours = hours - 12
                }
            }
        }
        
        if (hours > 12){
            hours = hours - 12
        }
        
        if (minutes < 10){
            displayHandTime.text = String(hours) + ":0" + String(minutes) + " " + amOrPm
        }else{
            displayHandTime.text = String(hours) + ":" + String(minutes) + " " + amOrPm
        }
        aTime = displayHandTime.text!
    }
    
    func findEvent(){
        
        let startReadFrom = Date(timeIntervalSinceNow: 30 * angleArc)
        let endReadAt = Date(timeIntervalSinceNow: (30 * angleArc) + 1)
        
        let myPredecate = eventStore.predicateForEvents(withStart: startReadFrom, end: endReadAt, calendars: [userCalendar])
        
        var eventsToWorkWith = eventStore.events(matching: myPredecate)
        
        var i = 0
        for event in eventsToWorkWith{
            let startDate = event.startDate
            let endDate = event.endDate
            let elapsedTime = (Int(endDate.timeIntervalSince(startDate)))
            
            if (elapsedTime >= 86400){
                eventsToWorkWith.remove(at: i)
                i -= 1
            }
            i += 1

        }
        
        if(eventsToWorkWith.count <= 0){
            screenEventLabel.text = "No Events"
            DisplayOtherEventsButton.isHidden = true
            DisplayOtherEventsButton.isEnabled = false
        }
        else{
            var allDayEvents:[EKEvent] = []
            var ind = 0
            for event in eventsToWorkWith{
                if event.isAllDay == true{
                    allDayEvents.append(event)
                    eventsToWorkWith.remove(at: ind)
                    ind -= 1
                }
                ind += 1
            }
            
            
            if eventsToWorkWith.count <= 0{
                screenEventLabel.text = "No Events"
                DisplayOtherEventsButton.isHidden = true
                DisplayOtherEventsButton.isEnabled = false
                AllDayEventLabel.isHidden = true
                AllDayEventLabel.isEnabled = false
            }
            else{
                screenEventLabel.isHidden = false
                screenEventLabel.text = eventsToWorkWith[0].title
                if eventsToWorkWith.count == 1{
                    DisplayOtherEventsButton.isHidden = true
                    DisplayOtherEventsButton.isEnabled = false

                }
                else if eventsToWorkWith.count > 1 {
                    DisplayOtherEventsButton.isHidden = false
                    DisplayOtherEventsButton.isEnabled = true
                }
            }
            
            
            if allDayEvents.count <= 0 {
                AllDayEventLabel.isHidden = true
                MoreAllDayEventsButton.isHidden = true
                MoreAllDayEventsButton.isEnabled = false
            }
            else{
                AllDayEventLabel.isHidden = false
                if allDayEvents.count > 1{
                    AllDayEventLabel.text = "\(allDayEvents.count) All-Day Events"
                    MoreAllDayEventsButton.isHidden = false
                    MoreAllDayEventsButton.isEnabled = true
                }
                else{
                    AllDayEventLabel.text = "All-Day Event: " + allDayEvents[0].title
                    if(allDayEvents.count != 1){
                        MoreAllDayEventsButton.isHidden = false
                        MoreAllDayEventsButton.isEnabled = true
                    }
                    else{
                        MoreAllDayEventsButton.isHidden = true
                        MoreAllDayEventsButton.isEnabled = false
                    }
                }
            }
            allDayEventArray = allDayEvents
        }
        tableViewEvents = eventsToWorkWith
        
    }
    
    func initialize(){
        
        AllDayEventLabel.isHidden = true
        MoreAllDayEventsButton.isHidden = true
        MoreAllDayEventsButton.isEnabled = false
        DisplayOtherEventsButton.isHidden = true
        DisplayOtherEventsButton.isEnabled = false
        
        userTime = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        
        var one = userTime.components(separatedBy: " ")
        var two = one[3].components(separatedBy: ":")
        displayHandTime.text = two[0] + ":" + two[1] + " " + one[4]

        updateTimeText()
        if(hasAccess == true){
            findEvent()
        }
        
        /**Set minute cast to show events**/
        minuteCast.setNeedsDisplay()
        
        let myc = self.view.center
        cent = myc
        a = Double(myc.x)
        b = Double(myc.y)
        c = a
        d = Double(myc.y) - radius
    }
}
