//
//  AccessToCalendar.swift
//  Photon
//
//  Created by Srinivas Pochiraju on 6/26/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit
import EventKit

class AccessToCalendar: UIViewController {
    
    var goToSettings = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCalendarAuthorizationStatus()
        
        if (goToSettings == false){
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func accessCalendarSettings(_ sender: AnyObject) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(openSettingsUrl!)
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

}
