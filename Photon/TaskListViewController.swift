//
//  TaskListViewController.swift
//  Productivity App
//
//  Created by Rishi Pochiraju on 3/27/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit
import EventKit

var hasAccess = false
var tag = -1

let eventStore = EKEventStore()
let pinchRecognizer = UIPinchGestureRecognizer()

var toDoItems = [ToDoItem]()
var indexSelected = 0
var firstRun = Bool()
let defaults = UserDefaults.standard

let tabbartint = UIColor(red: 28/255.0, green: 66/255.0, blue: 112/255.0, alpha: 1.0)

let placeHolderCell = TableViewCell(style: .default, reuseIdentifier: "cell")

var noAccess = false

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate  {
    var goToSettings:Bool = false
    var checkingTimer = Foundation.Timer()
    
    @IBOutlet weak var tableView: UITableView!
    
/******************************************************************************/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (goToSettings == true){
            //performSegueWithIdentifier("goToSettings", sender: self)
            noAccess = true
        }
        
        self.tableView.reloadData()
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "abackground.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        self.tabBarController?.tabBar.tintColor = tabbartint
        let at = [NSForegroundColorAttributeName: tabbartint]
        self.tabBarItem.setTitleTextAttributes(at, for: UIControlState.selected)
        
    }
/******************************************************************************/
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if(noAccess == true){
            let scheduledAlert = UIAlertController(title: "Photon needs access to your calendar", message: "Go to Settings > Photon to enable", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            }
            scheduledAlert.addAction(okAction)
            self.present(scheduledAlert, animated: true, completion: nil)
        }
        checkCalendarAuthorizationStatus()
        if (goToSettings == true){
            performSegue(withIdentifier: "goToSettings", sender: self)
        }
        
        for item in (self.tabBarController?.tabBar.items)!{
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
        let backgroundImage = UIImage(named: "abackground.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        tableView.backgroundColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        
        pinchRecognizer.addTarget(self, action: #selector(TaskListViewController.handlePinch(_:)))
        tableView.addGestureRecognizer(pinchRecognizer)
        
        self.tabBarController!.tabBar.barTintColor = UIColor(red: 109/255.0, green: 146/255.0, blue: 155/255.0, alpha: 0.7)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 50.0
        tableView.dataSource = self
        tableView.delegate = self
        
        if toDoItems.count > 0 {
            return
        }
        
        if (firstRun == true){
            toDoItems.append(ToDoItem(text: "Welcome to Photon!"))
            toDoItems.append(ToDoItem(text: "Pull down to add a task"))
            toDoItems.append(ToDoItem(text: "Pinch to add a task in between"))
            toDoItems.append(ToDoItem(text: "Swipe left to delete a task"))
            toDoItems.append(ToDoItem(text: "Tap the calendar icon to schedule"))
            
            let cal = EKCalendar(for: EKEntityType.event, eventStore: eventStore)
            cal.title = "Photon Events"
            cal.source = eventStore.defaultCalendarForNewEvents.source
            
            print("VSKI_OK")
            do {
                try eventStore.saveCalendar(cal, commit: true)
                UserDefaults.standard.set(cal.calendarIdentifier, forKey: "PhotonKey")
                print("VSKI_DO")
            } catch {
                
                let alertView = UIAlertController(title: "Photon could not make a calendar", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(OKAction)
                
                self.present(alertView, animated: true, completion: nil)
                print("VSKI_CATCH")
            }
        }else{
            let copySavedItems = defaults.object(forKey: "myItems")
            if copySavedItems != nil {
                let countOfItems = defaults.object(forKey: "numberOfTasks")
                let newCountOfItems = countOfItems as! NSInteger
                
                if (newCountOfItems > 0){
                    for obj in (copySavedItems! as! [AnyObject]){
                        let appendString = obj as! String
                        //let appendString = (copySavedItems! as AnyObject).object(i)
                        toDoItems.append(ToDoItem(text: appendString))
                    }
                }
                
            }
        }
        
        //Do any additional setup after loading the view, typically from a nib
    }
/**************************************************************************************/
    
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        //print("Status = \(status)")
        print("Status is Authorised = \(status == EKAuthorizationStatus.authorized)")
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
            firstRun = true
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            goToSettings = false
            firstRun = false
            hasAccess = true
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            goToSettings = true
            firstRun = false
            hasAccess = false
        }
        //firstRun=true
    }
/**************************************************************************************/
    
    func handle(granted:Bool, error:Error? ){
        if granted{
            self.goToSettings = false;
            hasAccess = true;
        }
        else{
            self.goToSettings = true;
            DispatchQueue.main.async(execute:{
                let scheduledAlert = UIAlertController(title: "Photon needs access to your calendar", message: "Go to Settings > Photon to enable", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
                }
                scheduledAlert.addAction(okAction)
                self.present(scheduledAlert, animated: true, completion: nil)

            });
        }
    }
/**************************************************************************************/
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: handle)
    }
    
    
    
    

    
/**************************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.addTarget(self, action: #selector(TaskListViewController.accessoryButtonTapped(_:)), for: .touchUpInside)
        button.setImage(UIImage(named:"CalendarFilled2.png"), for: UIControlState())
        button.contentMode = .scaleAspectFit
        button.tag = (indexPath as NSIndexPath).row
        if(noAccess == true){
            button.isEnabled = false
        }
        cell.accessoryView = button as UIView
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.tintColor = UIColor.white
        
        if (itemScheduled == true){
            print("item is scheduled")
            cell.backgroundColor = UIColor.cyan
            itemScheduled = false
        }
        
        let item = toDoItems[(indexPath as NSIndexPath).row]
        //cell.textLabel?.text = item.text
        
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    func accessoryButtonTapped(_ sender : UIButton){
        tag = sender.tag
        if(noAccess == true){
            let scheduledAlert = UIAlertController(title: "Error", message: "Photon needs access to your calendar", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            scheduledAlert.addAction(okAction)
            self.present(scheduledAlert, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "showDetail", sender: self)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    
    func colorForIndex(_ index: Int) -> UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0 , alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        indexSelected = (indexPath as NSIndexPath).row
        tag = indexSelected
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = toDoItems.remove(at: (sourceIndexPath as NSIndexPath).row)
        toDoItems.insert(item, at: (destinationIndexPath as NSIndexPath).row)
    }
    
    
    // MARK: - TableViewCellDelegate methods
    
    func toDoItemDeleted(_ toDoItem: ToDoItem) {
        let index = (toDoItems as NSArray).index(of: toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.remove(at: index)
        
        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animate(withDuration: 0.3, delay: delay, options: UIViewAnimationOptions(),
                                           animations: {() in
                                            cell.frame = cell.frame.offsetBy(dx: 0.0,
                                                dy: -cell.frame.size.height)},
                                           
                                           completion: {(finished: Bool) in
                                            if (cell == lastView) {
                                                self.tableView.reloadData()
                                            }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.isHidden = true
            }
        }
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPathForRow], with: .fade)
        tableView.endUpdates()
    }
    
    func cellDidBeginEditing(_ editingCell: TableViewCell) {
        let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(_ editingCell: TableViewCell) {
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell: TableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        
        if editingCell.toDoItem!.text == "" {
            toDoItemDeleted(editingCell.toDoItem!)
            placeHolderCell.removeFromSuperview()
        }
        
        
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and other methods, to keep track of dragging the scrollView
    
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    //let placeHolderCell = TableViewCell(style: .Default, reuseIdentifier: "cell")
    
    
    // indicates the state of this behavior
    var pullDownInProgress = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.clear
        placeHolderCell.tintColor = UIColor.white
        placeHolderCell.textLabel?.font = UIFont(name: "Futura", size: 12)
        
        //        cell.backgroundColor = .clearColor()
        //        cell.tintColor = UIColor.whiteColor()
        
        if pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, at: 0)
            
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        placeHolderCell.textLabel?.font = UIFont(name: "Futura", size: 12)
        
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.textLabel?.font = UIFont(name: "Futura", size: 12)
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                                           width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            toDoItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    // MARK: - add, delete, edit methods
    
    func toDoItemAdded() {
        toDoItemAddedAtIndex(0)
    }
    
    func toDoItemAddedAtIndex(_ index: Int) {
        let toDoItem = ToDoItem(text: "")
        toDoItems.insert(toDoItem, at: index)
        tableView.reloadData()
        // enter edit mode
        var editCell: TableViewCell
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell in visibleCells {
            if (cell.toDoItem === toDoItem) {
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
    }
    
    
    // MARK: - pinch-to-add methods
    
    struct TouchPoints {
        var upper: CGPoint
        var lower: CGPoint
    }
    // the indices of the upper and lower cells that are being pinched
    var upperCellIndex = -100
    var lowerCellIndex = -100
    // the location of the touch points when the pinch began
    var initialTouchPoints: TouchPoints!
    // indicates that the pinch was big enough to cause a new item to be added
    var pinchExceededRequiredDistance = false
    
    // indicates that the pinch is in progress
    var pinchInProgress = false
    
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            pinchStarted(recognizer)
        }
        if recognizer.state == .changed && pinchInProgress && recognizer.numberOfTouches == 2 {
            pinchChanged(recognizer)
        }
        if recognizer.state == .ended {
            pinchEnded(recognizer)
        }
    }
    
    func pinchStarted(_ recognizer: UIPinchGestureRecognizer) {
        // find the touch-points
        initialTouchPoints = getNormalizedTouchPoints(recognizer)
        
        // locate the cells that these points touch
        upperCellIndex = -100
        lowerCellIndex = -100
        let visibleCells = tableView.visibleCells  as! [TableViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if viewContainsPoint(cell, point: initialTouchPoints.upper) {
                upperCellIndex = i
                // highlight the cell – just for debugging!
                cell.backgroundColor = UIColor.clear
                cell.tintColor = UIColor.white
            }
            if viewContainsPoint(cell, point: initialTouchPoints.lower) {
                lowerCellIndex = i
                // highlight the cell – just for debugging!
                cell.backgroundColor = UIColor.clear
                cell.tintColor = UIColor.white
            }
        }
        // check whether they are neighbors
        if abs(upperCellIndex - lowerCellIndex) == 1 {
            // initiate the pinch
            pinchInProgress = true
            // show placeholder cell
            let precedingCell = visibleCells[upperCellIndex]
            placeHolderCell.frame = precedingCell.frame.offsetBy(dx: 0.0, dy: tableView.rowHeight / 2.0)
            placeHolderCell.backgroundColor = UIColor.white
            placeHolderCell.backgroundColor = precedingCell.backgroundColor
            tableView.insertSubview(placeHolderCell, at: 0)
            
        }
        
        if (recognizer.state == .changed && pinchInProgress && recognizer.numberOfTouches == 2) {
            pinchChanged(recognizer)
        }
    }
    
    func pinchChanged(_ recognizer: UIPinchGestureRecognizer) {
        // find the touch points
        let currentTouchPoints = getNormalizedTouchPoints(recognizer)
        
        // determine by how much each touch point has changed, and take the minimum delta
        let upperDelta = currentTouchPoints.upper.y - initialTouchPoints.upper.y
        let lowerDelta = initialTouchPoints.lower.y - currentTouchPoints.lower.y
        let delta = -min(0, min(upperDelta, lowerDelta))
        
        // offset the cells, negative for the cells above, positive for those below
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if i <= upperCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: -delta)
            }
            if i >= lowerCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: delta)
            }
        }
        
        // scale the placeholder cell
        let gapSize = delta * 2
        let cappedGapSize = min(gapSize, tableView.rowHeight)
        placeHolderCell.textLabel?.font = UIFont(name: "Futura", size: 12)
        placeHolderCell.transform = CGAffineTransform(scaleX: 1.0, y: cappedGapSize / tableView.rowHeight)
        placeHolderCell.label.text = gapSize > tableView.rowHeight ? "Release to add item" : "Pull apart to add item"
        placeHolderCell.alpha = min(1.0, gapSize / tableView.rowHeight)
        
        // has the user pinched far enough?
        pinchExceededRequiredDistance = gapSize > tableView.rowHeight
    }
    
    func pinchEnded(_ recognizer: UIPinchGestureRecognizer) {
        pinchInProgress = false
        
        // remove the placeholder cell
        placeHolderCell.transform = CGAffineTransform.identity
        placeHolderCell.removeFromSuperview()
        
        if pinchExceededRequiredDistance {
            pinchExceededRequiredDistance = false
            
            // Set all the cells back to the transform identity
            let visibleCells = self.tableView.visibleCells as! [TableViewCell]
            for cell in visibleCells {
                cell.transform = CGAffineTransform.identity
            }
            
            // add a new item
            let indexOffset = Int(floor(tableView.contentOffset.y / tableView.rowHeight))
            toDoItemAddedAtIndex(lowerCellIndex + indexOffset)
        } else {
            // otherwise, animate back to position
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {() in
                let visibleCells = self.tableView.visibleCells as! [TableViewCell]
                for cell in visibleCells {
                    cell.transform = CGAffineTransform.identity
                }
                }, completion: nil)
        }
    }
    
    // returns the two touch points, ordering them to ensure that
    // upper and lower are correctly identified.
    func getNormalizedTouchPoints(_ recognizer: UIGestureRecognizer) -> TouchPoints {
        var pointOne = recognizer.location(ofTouch: 0, in: tableView)
        var pointTwo = recognizer.location(ofTouch: 1, in: tableView)
        // ensure pointOne is the top-most
        if pointOne.y > pointTwo.y {
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    
    func viewContainsPoint(_ view: UIView, point: CGPoint) -> Bool {
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    
    @IBOutlet var EditButton: UIBarButtonItem!
    
    @IBAction func EditPressed(_ sender: AnyObject) {
        tableView.isEditing = !tableView.isEditing
        if(tableView.isEditing == true){
            EditButton.image = UIImage(named: "Checkmark Filled-500.png")
        }
        else{
            EditButton.image = UIImage(named: "Sorting Arrows-30.png")
        }
    }
}
