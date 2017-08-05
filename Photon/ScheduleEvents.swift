//
//  ScheduleEvents.swift
//  Productivity App
//
//  Created by Rishi Pochiraju on 6/5/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit
import EventKit

var indexTouched = 0
var itemScheduled = false

class ScheduleEvents: UIViewController, UITextFieldDelegate {
    
    var titleOfEvent = ""
    var goToSettings = Bool()

    var dateFormatter1: DateFormatter!
    var dateFormatter2: DateFormatter!
    var start: String = ""
    var end: String = ""
    var startDate:Date! = Date()
    var endDate:Date! = Date()
    
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var allDaySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        titleOfEvent = toDoItems[tag].text
        
        self.titleField.delegate = self
        
        if (height == 480.0){
            
            let allDayLabel = UILabel(frame: CGRect(x: (114 * width / 375), y: (184 * height/667), width: 70 * width/375, height: 25 * height/667))
            allDayLabel.textAlignment = NSTextAlignment.left
            allDayLabel.text = "All-day"
            allDayLabel.textColor = UIColor.black
            allDayLabel.font = UIFont(name: "Futura", size: 15)
            self.view.addSubview(allDayLabel)
            
            let switchn = UISwitch(frame: CGRect(x: (210 * width / 375), y: (175 * height/667), width: 51 * width/375, height: 31 * height/667))
            switchn.isOn = false
            switchn.setOn(false, animated: false)
            switchn.onTintColor = UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0)
            self.view.addSubview(switchn)
            allDaySwitch = switchn
            
        }else if (height == 568.0){
            
            let allDayLabel = UILabel(frame: CGRect(x: (114 * width / 375), y: (174 * height/667), width: 55 * width/375, height: 21 * height/667))
            allDayLabel.textAlignment = NSTextAlignment.left
            allDayLabel.text = "All-day"
            allDayLabel.textColor = UIColor.black
            allDayLabel.font = UIFont(name: "Futura", size: 17 * height/667)
            self.view.addSubview(allDayLabel)
            
            let switchn = UISwitch(frame: CGRect(x: (210 * width / 375), y: (165 * height/667), width: 51 * width/375, height: 31 * height/667))
            switchn.isOn = false
            switchn.setOn(false, animated: false)
            switchn.onTintColor = UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0)
            self.view.addSubview(switchn)
            allDaySwitch = switchn

        }else{
        
            let allDayLabel = UILabel(frame: CGRect(x: (114 * width / 375), y: (152 * height/667), width: 55 * width/375, height: 21 * height/667))
            allDayLabel.textAlignment = NSTextAlignment.left
            allDayLabel.text = "All-day"
            allDayLabel.textColor = UIColor.black
            allDayLabel.font = UIFont(name: "Futura", size: 17 * height/667)
            self.view.addSubview(allDayLabel)

            let switchn = UISwitch(frame: CGRect(x: (210 * width / 375), y: (147 * height/667), width: 51 * width/375, height: 31 * height/667))
            switchn.isOn = false
            switchn.setOn(false, animated: false)
            switchn.onTintColor = UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0)
            self.view.addSubview(switchn)
            allDaySwitch = switchn
        }
        
        
        let startLabel = UILabel(frame: CGRect(x: 0, y: (225/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 21))
        startLabel.textAlignment = NSTextAlignment.center
        startLabel.text = "Starts"
        startLabel.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        startLabel.font = UIFont(name: "Futura", size: 17)
        self.view.addSubview(startLabel)
        
        let endLabel = UILabel(frame: CGRect(x: 0, y: (404/667) * self.view.frame.size.height, width: self.view.frame.size.width, height: 21))
        endLabel.textAlignment = NSTextAlignment.center
        endLabel.text = "Ends"
        endLabel.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        endLabel.font = UIFont(name: "Futura", size: 17)
        self.view.addSubview(endLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScheduleEvents.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        titleField.addTarget(self, action: #selector(ScheduleEvents.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        let startDatePicker: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0.35982 * self.view.frame.size.height, width: self.view.frame.size.width,height: 0.22488756 * self.view.frame.size.height))
        startDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.view.addSubview(startDatePicker)
        startDatePicker.addTarget(self, action: #selector(ScheduleEvents.changeStart(_:)), for: UIControlEvents.valueChanged)
        dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = DateFormatter.Style.long
        dateFormatter1.timeStyle = .short
        
        
        let endDatePicker: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0.62968516 * self.view.frame.size.height, width: self.view.frame.size.width, height: 0.22488756 * self.view.frame.size.height))
        endDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.view.addSubview(endDatePicker)
        endDatePicker.addTarget(self, action: #selector(ScheduleEvents.changeEnd(_:)), for: UIControlEvents.valueChanged)
        dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.long
        dateFormatter2.timeStyle = .short
        
        titleField.text = titleOfEvent
        
        warningLabel.isHidden = true
        
        if (titleField.text == ""){
            createEventButton.isEnabled = false
        }else{
            var count = 0
            for letters in titleField.text!.characters {
                if (letters == " "){
                    count += 1
                }
            }
            if (titleField.text!.characters.count == count){
                createEventButton.isEnabled = false
            }else{
                createEventButton.isEnabled = true
                titleOfEvent = titleField.text!
            }
        }

        
        
    }

    
    @IBAction func CloseOut(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        testSegue = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        titleField.resignFirstResponder()
    }
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var createEventButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @IBAction func changeStart(_ sender: UIDatePicker){
        
        start = dateFormatter1.string(from: sender.date)
        startDate = dateFormatter1.date(from: start)!
        
        //if start date is after end date, hide the "add task" button
        
        switch startDate.compare(endDate) {
        case .orderedAscending:
            createEventButton.isEnabled = true
            warningLabel.isHidden = true
        case .orderedDescending:
            createEventButton.isEnabled = false
            warningLabel.isHidden = false
        case .orderedSame:
            createEventButton.isEnabled = true
            warningLabel.isHidden = true
        }
        
    }
    
    
    
    @IBAction func changeEnd(_ sender: UIDatePicker){
        
        end = dateFormatter2.string(from: sender.date)
        endDate = dateFormatter2.date(from: end)!
        
        //if start date is after end date, hide the "add task" button
        
        switch startDate.compare(endDate) {
        case .orderedAscending:
            createEventButton.isEnabled = true
            warningLabel.isHidden = true
        case .orderedDescending:
            createEventButton.isEnabled = false
            warningLabel.isHidden = false
        case .orderedSame:
            createEventButton.isEnabled = true
            warningLabel.isHidden = true
        }
        
    }
    
    @IBAction func scheduleEventButton(_ sender: AnyObject) {
        //the title of the event depends on what text is entered inside the cell
        //Need to find a way to get a dynamic segue from each individual task to this button
        //then schedule the events based on the event name
        //name of the task needs to be accessed inside of here
        
        createEvent(eventStore, title: titleOfEvent, startDate: startDate, endDate: endDate)
        
        toDoItems[tag].isScheduled = true
        itemScheduled = true
        
        let scheduledAlert = UIAlertController(title: "\"\(titleOfEvent)\" has been added to calendar!", message: "Go to your calendar to make any adjustments.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        scheduledAlert.addAction(okAction)
        self.present(scheduledAlert, animated: true, completion: nil)
    }

    func textFieldDidChange(_ textField: UITextField) {
        //the following code will not allow the user to make an event with no text
        if (titleField.text == ""){
            createEventButton.isEnabled = false
        }else{
            var count = 0
            for letters in titleField.text!.characters {
                if (letters == " "){
                    count += 1
                }
            }
            if (titleField.text!.characters.count == count){
                createEventButton.isEnabled = false
            }else{
                createEventButton.isEnabled = true
                titleOfEvent = titleField.text!
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        if(goToSettings == true){
            createEventButton.isEnabled = false;
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
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //self.performSegueWithIdentifier("goToSettings", sender: nil)
            goToSettings = true
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                })
                self.goToSettings = false
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
    
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        if (allDaySwitch.isOn){
            event.isAllDay = true
        }else{
            event.isAllDay = false
        }
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            
        } catch {
            
            print("Bad things happened, event wasn't scheduled")
            
        }
    }
    
    
}
