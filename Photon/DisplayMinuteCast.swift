import Foundation
import UIKit
import EventKit
import GLKit

var globalTitles:[String] = []
let TESTnumEvents = 3
let TESTminPerEvent = 60

let userCalendar:EKCalendar! = eventStore.defaultCalendarForNewEvents


class DisplayMinuteCast:UIView{
    var allDayArc:Bool = false
    var startAngle:CGFloat = CGFloat((M_PI/2) * 3)
    
    var startAng:[Float] = []
    var endAng:[Float] = []
    
    override func draw(_ rect: CGRect) {
        calculateDurationsOfEvents()
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        let theCenter:CGPoint = CGPoint(x: centerX, y: centerY)
        var myRadius:CGFloat = max(bounds.width, bounds.height) / 2.9
        if (bounds.height == 174.0){
            myRadius = max(bounds.width, bounds.height) / 4.0
        }
        let thickness:CGFloat = (max(bounds.width, bounds.height) / 2.9) / 16.7175905
        
        let startBack = CGFloat(3 * M_PI / 2)
        let endBack = CGFloat(7 * M_PI / 2)
        let backgroundPath = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: startBack, endAngle: endBack, clockwise: true)
        let backCol = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 0.7)
        backCol.setStroke()
        backgroundPath.lineWidth = thickness
        backgroundPath.stroke()
        
        var pathArray:[UIBezierPath] = []
        for (ang1, ang2) in zip(startAng, endAng){
            let ang1f = CGFloat(ang1)
            let ang2f = CGFloat(ang2)
            let nextPath = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: ang1f, endAngle: ang2f, clockwise: true)
            pathArray.append(nextPath)
        }
        
        
        var mult = 0
        for path in pathArray{
            let redC = CGFloat(28) / 255
            let greenC = CGFloat(200 - mult) / 255
            let blueC = CGFloat(255) / 255
            //print("(\(redC), \(greenC), \(blueC))")
            let randomColor:UIColor = UIColor(red: redC, green: greenC, blue: blueC, alpha: 1.0)
            randomColor.setStroke()
            path.lineWidth = thickness
            path.stroke()
            mult += (200 / pathArray.count)
        }
        
        if(allDayArc == true){
            let allDayColor = UIColor(red: 181/255.0, green: 210/255.0, blue: 207/255.0, alpha: 1.0)
            allDayColor.setStroke()
            let allPath = UIBezierPath(arcCenter: theCenter, radius: myRadius-11, startAngle: startBack, endAngle: endBack, clockwise: true)
            allPath.lineWidth = thickness/2
            allPath.stroke()
        }
        startAng.removeAll()
        endAng.removeAll()
        
        let startPH = CGFloat((3 * M_PI/2) - (M_PI/270))
        let endPH = CGFloat((3 * M_PI/2) + (M_PI/270))
        let phPath = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: startPH, endAngle: endPH, clockwise: true)
        let phCol = UIColor.black
        phCol.setStroke()
        phPath.lineWidth = thickness
        phPath.stroke()
        let inp = CGFloat (angleArc * M_PI/180)
        let startMover = CGFloat((3 * M_PI)/2 - (M_PI/270)) + inp
        let endMover =   CGFloat((3 * M_PI)/2 + (M_PI/270)) + inp
        let moverPath = UIBezierPath(arcCenter: theCenter, radius: myRadius, startAngle: startMover, endAngle: endMover, clockwise: true)
        let moverCol = UIColor.green
        moverCol.setStroke()
        moverPath.lineWidth = thickness
        moverPath.stroke()
        
    }
    
    fileprivate func calculateAngleFromEventDurationMins(_ duration:Int) -> Float{
        let angle =  ( (120.0 * Float(duration)) / 60)
        
        if(angle > 360){return GLKMathDegreesToRadians(360.0)}
        else{return GLKMathDegreesToRadians(angle)}
    }
    
    
    
    func calculateDurationsOfEvents(){
        if(hasAccess){
        var one = userTime.components(separatedBy: " ")
        var two = one[3].components(separatedBy: ":")
        var currentHour = Int(two[0])!
        let currentMin = Int(two[1])!
        if one[4] == "PM" {
            currentHour += 12
        }
        
        var titles:[String] = []
        var start:[Date] = []
        var end:[Date] = []
        
        var stringStartTimeH:[Int] = []
        var stringStartTimeM:[Int] = []
        var stringEndTimeH:[Int] = []
        var stringEndTimeM:[Int] = []
        
        let startReadFrom = Date(timeIntervalSinceNow: 0)
        let endReadAt = Date(timeIntervalSinceNow: 10800)//3 hours = 3600 * 3 = 10800 seconds
        
        let myPredecate = eventStore.predicateForEvents(withStart: startReadFrom, end: endReadAt, calendars: [userCalendar])
        
        var eventsToWorkWith = eventStore.events(matching: myPredecate)

        eventsToWorkWith = eventsToWorkWith.filter{
            (Int($0.endDate.timeIntervalSince($0.startDate))) <= 86400
        }
        
        
        var ct:Int = 0
        for anEvent in eventsToWorkWith{
            titles.append(anEvent.title)
            start.append(anEvent.startDate)
            end.append(anEvent.endDate)
            if(anEvent.isAllDay == true){
                ct += 1
                titles.removeLast()
                start.removeLast()
                end.removeLast()
            }
        }
        if(ct > 0){
            allDayArc = true
        }
        globalTitles = titles
        
        for startTimes in start {
            
            let localFormatter: DateFormatter = DateFormatter()
            localFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            localFormatter.timeZone = TimeZone.autoupdatingCurrent
            let localDateString = localFormatter.string(from: startTimes)
            
            let one = String(localDateString)
            let two = one?.components(separatedBy: " ")
            let three = two?[1].components(separatedBy: ":")
            let four = Int((three?[0])!)!
            //CONVERTING FROM GMT TO EST - MUST CONVERT HERE TO THE USER'S ACTUAL TIME ZONE
            let five = Int((three?[1])!)!
            stringStartTimeH.append(four)
            stringStartTimeM.append(five)
            
        }
        
        for endTimes in end {
            
            let localFormatter: DateFormatter = DateFormatter()
            localFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            localFormatter.timeZone = TimeZone.autoupdatingCurrent
            let localDateString = localFormatter.string(from: endTimes)
            
            let one = String(localDateString)
            let two = one?.components(separatedBy: " ")
            let three = two?[1].components(separatedBy: ":")
            let four = Int((three?[0])!)!
            let five = Int((three?[1])!)!
            stringEndTimeH.append(four)
            stringEndTimeM.append(five)
        }
        

        for i in 0..<stringStartTimeM.count{
            var stringStartTimeHNew = stringStartTimeH[i]
            var stringStartTimeMNew = stringStartTimeM[i]
            if stringStartTimeMNew < currentMin {
                stringStartTimeHNew -= 1
                stringStartTimeMNew += 60
            }
            
            let hourDiff = stringStartTimeHNew - currentHour
            let minDiff = stringStartTimeMNew - currentMin
            let totDiffStart = (hourDiff * 60) + minDiff
            let start = Float((M_PI/2) * 3)
            var totDiffFloat = Float(totDiffStart * 2)
            let convertToRad = Float(M_PI/180)
            if (stringStartTimeH[i] <= currentHour){
                if (stringStartTimeH[i] == currentHour){
                    if (stringStartTimeM[i] < currentMin){
                        totDiffFloat = Float(0)
                    }
                }else{
                    totDiffFloat = Float(0)
                }
            }
            
            startAng.append(start + (totDiffFloat * convertToRad))
            
        }
        
        for i in 0 ..< stringEndTimeM.count {
            if stringEndTimeM[i] < currentMin {
                stringEndTimeH[i] -= 1
                stringEndTimeM[i] += 60
            }
            
            let hourDiff = stringEndTimeH[i] - currentHour
            let minDiff = stringEndTimeM[i] - currentMin
            let totDiffEnd = (hourDiff * 60) + minDiff
            let start = Float((M_PI/2) * 3)
            var totDiffFloat = Float(totDiffEnd * 2)
            let convertToRad = Float(M_PI/180)
            if (stringEndTimeH[i] >= currentHour + 3){
                if (stringEndTimeH[i] == currentHour + 3){
                    if (stringEndTimeM[i] > currentMin){
                        totDiffFloat = Float(360)
                    }
                }else{
                    totDiffFloat = Float(360)
                }
            }
            
            endAng.append(start + (totDiffFloat * convertToRad))
        }
        
    }
    
    func calcAngleFromMins(_ mins:Int) -> Float{
        let ang = (120 * Float(mins)) / 60.0
        if(angle > 360){
            return GLKMathDegreesToRadians(360.0)
        }
        else{
            return GLKMathDegreesToRadians(ang)
        }
        
    }
    }
}
