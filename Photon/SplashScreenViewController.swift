//
//  SplashScreenViewController.swift
//  Photon
//
//  Created by Steve  on 6/24/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet var p: UILabel!
    @IBOutlet var h: UILabel!
    @IBOutlet var o: UILabel!
    @IBOutlet var t: UILabel!
    @IBOutlet var o2: UILabel!
    @IBOutlet var n: UILabel!
    @IBOutlet var lightSpeedLabel: UILabel!
    
    var timer = Foundation.Timer()
    var counter = -7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        //let
        // Do any additional setup after loading the view.
        
        let ln = UILabel(frame: CGRect(x: 0, y: (323 * height/667), width: width, height: 22 * height/667))
        ln.textAlignment = NSTextAlignment.center
        ln.text = "Work at light speed"
        ln.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        ln.font = UIFont(name: "Mitr-Light", size: 13 * height/667)
        self.view.addSubview(ln)
        lightSpeedLabel = ln
        
        let pn = UILabel(frame: CGRect(x: (69 * width / 375), y: (245 * height/667), width: 49 * width/375, height: 75 * height/667))
        pn.textAlignment = NSTextAlignment.left
        pn.text = "P"
        pn.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        pn.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(pn)
        p = pn
        
        let hn = UILabel(frame: CGRect(x: (120 * width / 375), y: (245 * height/667), width: 49 * width/375, height: 75 * height/667))
        hn.textAlignment = NSTextAlignment.left
        hn.text = "h"
        hn.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        hn.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(hn)
        h = hn
        
        let on = UILabel(frame: CGRect(x: (160 * width / 375), y: (245 * height/667), width: 49 * width/375, height: 75 * height/667))
        on.textAlignment = NSTextAlignment.left
        on.text = "o"
        on.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        on.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(on)
        o = on
        
        let tn = UILabel(frame: CGRect(x: (199 * width / 375), y: (245 * height/667), width: 47 * width/375, height: 75 * height/667))
        tn.textAlignment = NSTextAlignment.left
        tn.text = "t"
        tn.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        tn.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(tn)
        t = tn
        
        let o2n = UILabel(frame: CGRect(x: (229 * width / 375), y: (245 * height/667), width: 49 * width/375, height: 75 * height/667))
        o2n.textAlignment = NSTextAlignment.left
        o2n.text = "o"
        o2n.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        o2n.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(o2n)
        o2 = o2n
        
        let nn = UILabel(frame: CGRect(x: (268 * width / 375), y: (245 * height/667), width: 49 * width/375, height: 75 * height/667))
        nn.textAlignment = NSTextAlignment.left
        nn.text = "n"
        nn.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        nn.font = UIFont(name: "Mitr-Light", size: 52 * height/667)
        self.view.addSubview(nn)
        n = nn
        
        
        timer = Foundation.Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        perform(#selector(SplashScreenViewController.showHome), with: nil, afterDelay: 2.7)
        
    }
    
    func updateTimer(){
        counter += 1
        
        if (counter == 8){
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                self.lightSpeedLabel.center = CGPoint(x: self.lightSpeedLabel.center.x, y: self.lightSpeedLabel.center.y + 1000)
            })
        }
        
        if (counter == 11){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.n.center = CGPoint(x: self.n.center.x, y: self.n.center.y + 1000)
            })
        }
        
        if (counter == 12){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.o2.center = CGPoint(x: self.o2.center.x, y: self.o2.center.y + 1000)
            })
        }
        
        if (counter == 13){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.t.center = CGPoint(x: self.t.center.x, y: self.t.center.y + 1000)
            })
        }
        
        if (counter == 14){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.o.center = CGPoint(x: self.o.center.x, y: self.o.center.y + 1000)
            })
        }
        
        if (counter == 15){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.h.center = CGPoint(x: self.h.center.x, y: self.h.center.y + 1000)
            })
        }
        
        if (counter == 16){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.p.center = CGPoint(x: self.p.center.x, y: self.p.center.y + 1000)
            })
        }
        
        if (counter == 17){
            timer.invalidate()
        }
        
    }
    
    func showHome(){
        performSegue(withIdentifier: "segueFromSplash", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
