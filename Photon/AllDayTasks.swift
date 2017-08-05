//
//  AllDayTasks.swift
//  Photon
//
//  Created by Varun Kulkarni on 6/27/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class AllDayTasks: UIViewController, UITableViewDelegate{
    
    var goToSettings = Bool()
    
    override func viewWillAppear(_ animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        if(goToSettings == true){
            performSegue(withIdentifier: "segue6", sender: self)
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

    
    
    @IBAction func CloseOut(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return allDayEventArray.count
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "allday")
        cell.textLabel?.text = allDayEventArray[(indexPath as NSIndexPath).row].title
        let font = UIFontDescriptor(name: "Futura", size: 21.0)
        cell.textLabel?.font = UIFont(descriptor: font, size: CGFloat(15.0))
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
