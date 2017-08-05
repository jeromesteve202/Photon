//
//  Timer.swift
//  Productivity App
//
//  Created by Rishi Pochiraju on 5/17/16.
//  Copyright Â© 2016 Rishi P. All rights reserved.

import UIKit
import EventKit
import GoogleMobileAds

var angle = 0.0

var currentTimer = Foundation.Timer()
var goToSettings = Bool()

var elapsedTime = 0
var totalTime:Double = 0.0
var degrees = 0.0
class Timer: UIViewController {
    
    @IBOutlet var backTimer: backgroundTimer!
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var withinTwoHours: TimerArc!
    @IBOutlet var currentEventStatic: UILabel!
    @IBOutlet var currentEvent: UILabel!
    
    let deg = 0.01745329251
    
    var hour = 0
    var min = 0
    var sec = 0
    var timer = Foundation.Timer()
    
    var titles:[String] = []
    var start:[Date] = []
    var end:[Date] = []
    
    var alreadyStartedEvent:Bool = false
    var someBool:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-2830059983414219/1713346287"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        changeThe4sLabels()
        
        timerLabel.font = UIFont(name: "Hiragino Sans", size: self.view.frame.size.height / 18.0270270)
        
        self.tabBarController!.tabBar.barTintColor = UIColor(red:109/255.0, green: 146/255.0, blue: 155/255.0, alpha: 0.7)
        if(noAccess == false){
            currentTimer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTimer), userInfo: nil, repeats: true)
        }
        if(noAccess == true){
            let scheduledAlert = UIAlertController(title: "Photon needs access to your calendar", message: "Go to Settings > Photon to enable", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            }
            scheduledAlert.addAction(okAction)
            self.present(scheduledAlert, animated: true, completion: nil)
        }

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCalendarAuthorizationStatus()
        
        if (hasAccess == false){
            self.performSegue(withIdentifier: "segue2", sender: self)
        }
        
        changeThe4sLabels()
        
        self.tabBarController?.tabBar.tintColor = tabbartint
        let at = [NSForegroundColorAttributeName: tabbartint]
        self.tabBarItem.setTitleTextAttributes(at, for: UIControlState.selected)
        
    }
    
    func changeThe4sLabels(){
        
        if (self.view.frame.size.height == 480.0){
            currentEventStatic.removeFromSuperview()
            let nowLabel = UILabel(frame: CGRect(x: 0, y: (100/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 23))
            nowLabel.textAlignment = NSTextAlignment.center
            nowLabel.text = "Current Event:"
            nowLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            nowLabel.font = UIFont(name: "Futura", size: 17)
            self.view.addSubview(nowLabel)
            
            let adLabel = UILabel(frame: CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: 54))
            adLabel.textAlignment = NSTextAlignment.center
            adLabel.text = "None"
            adLabel.numberOfLines = 0
            adLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            adLabel.font = UIFont(name: "Futura", size: 17)
            self.view.addSubview(adLabel)
            currentEvent.removeFromSuperview()
            currentEvent = adLabel
        }
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
    
    func updateUserTimer(){
        
        sec = sec - 1
        if (sec == -1){
            sec = 59
            min = min - 1
            if (min == -1 && hour >= 1){
                min = 59
                hour = hour - 1
            }
        }
        
        updateTimerLabel()
        let elapsedTime2 = Int(end[0].timeIntervalSince(start[0]))
        
        angle += 180.0 / (Double(elapsedTime2))
        degrees += 180.0 / (Double(elapsedTime2))
        
        if(someBool == true){
            angle += 180.0 / (Double(elapsedTime2))
            degrees += 180.0 / (Double(elapsedTime2))
        }
        
        withinTwoHours.setNeedsDisplay()
        
        if (min < 0){
            timer.invalidate()
            timerLabel.text = "00:00:00"
            currentEvent.text = "None"
            angle = 0.0
            degrees = 0.0
            titles = []
            start = []
            end = []
            
            hour = 0
            min = 0
            sec = 0
            
            alreadyStartedEvent = false
            someBool = false
            
            elapsedTime = 0
            totalTime = 0.0
            degrees = 0.0
            
            // reset everything
            
            
        }
    }
    
    func updateCurrentTimer(){
        userTime = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
        var one = userTime.components(separatedBy: " ")
        var two = one[3].components(separatedBy: ":")
        var currentHour = Int(two[0])!
        //let currentMin = Int(two[1])!
        if one[4] == "PM" {
            currentHour += 12
        }
        
        
        let startReadFrom = Date(timeIntervalSinceNow: 0)
        let endReadAt = Date(timeIntervalSinceNow: 1000)
        if(hasAccess){
            let myPredecate = eventStore.predicateForEvents(withStart: startReadFrom, end: endReadAt, calendars: [userCalendar])
        
        
        var eventsToWorkWith = eventStore.events(matching: myPredecate)

        eventsToWorkWith = eventsToWorkWith.filter{$0.isAllDay == false}
        
        eventsToWorkWith = eventsToWorkWith.filter{
            (Int($0.endDate.timeIntervalSince($0.startDate))) <= 86400
        }
        
        for anEvent in eventsToWorkWith{
            titles.append(anEvent.title)
            start.append(anEvent.startDate)
            end.append(anEvent.endDate)
            
        }
        
        if eventsToWorkWith.count >= 1 {
            let newStartDate = DateFormatter.localizedString(from: start[0], dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
            
            let startAfterCurrent = Int(Date().timeIntervalSince(start[0]))
            
            let eventNotOver = Int(end[0].timeIntervalSince(Date()))
            
            if (newStartDate == userTime){
                currentEvent.text = String(titles[0])
                
                elapsedTime = Int(end[0].timeIntervalSince(start[0]))
                min = elapsedTime/60
                
                if (min >= 60){
                    hour = min / 60
                    min = min % 60
                }
                
                updateTimerLabel()
                alreadyStartedEvent = true
                
                timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUserTimer), userInfo: nil, repeats: true)
            }else if (startAfterCurrent > 0 && eventNotOver > 0){
                
                if(alreadyStartedEvent == false){
                    alreadyStartedEvent = true
                    someBool = true
                    angle = Double(360 * (Double(startAfterCurrent)/Double(startAfterCurrent + eventNotOver)))
                    degrees = Double(360 * (Double(startAfterCurrent)/Double(startAfterCurrent + eventNotOver)))
                    elapsedTime = Int(end[0].timeIntervalSince(start[0]))
                    elapsedTime = elapsedTime - startAfterCurrent
                    
                    if (elapsedTime >= 60){
                        min = elapsedTime/60
                        sec = elapsedTime % 60
                    }
                    
                    if (min >= 60){
                        hour = min / 60
                        min = min % 60
                    }
                    currentEvent.text = String(titles[0])
                    updateTimerLabel()
                    
                    timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUserTimer), userInfo: nil, repeats: true)
                }
            }
            
        }
        
    }
    
    }
    
    func updateTimerLabel(){
        if (sec > 9){
            if (min > 9){
                if (hour > 9){
                    timerLabel.text = "\(hour):\(min):\(sec)"
                }else{
                    timerLabel.text = "0\(hour):\(min):\(sec)"
                }
            }else{
                if (hour > 9){
                    timerLabel.text = "\(hour):0\(min):\(sec)"
                }else{
                    timerLabel.text = "0\(hour):0\(min):\(sec)"
                }
            }
        }else{
            if (min > 9){
                if (hour > 9){
                    timerLabel.text = "\(hour):\(min):0\(sec)"
                }else{
                    timerLabel.text = "0\(hour):\(min):0\(sec)"
                }
            }else{
                if (hour > 9){
                    timerLabel.text = "\(hour):0\(min):0\(sec)"
                }else{
                    timerLabel.text = "0\(hour):0\(min):0\(sec)"
                }
            }
        }
    }
 
}
