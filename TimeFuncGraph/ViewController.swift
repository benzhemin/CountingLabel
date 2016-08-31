//
//  ViewController.swift
//  TimeFuncGraph
//
//  Created by peer on 16/8/30.
//  Copyright © 2016年 peer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var countLabel: CountLabel!
    var timeFuncView: TimeFuncView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timeFrame = CGRect(x: 0, y: 0, width: 200, height: 200);
        timeFuncView = TimeFuncView(frame: timeFrame, time: .easeInOut)
        view.addSubview(timeFuncView);
        
        timeFuncView.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        
        let countFrame = CGRect(x: 0, y: 0, width: 100, height: 40)
        countLabel = CountLabel(frame: countFrame)
        countLabel.textColor = UIColor.redColor()
        countLabel.font = UIFont.boldSystemFontOfSize(20)
        countLabel.textAlignment = .Center
        view.addSubview(countLabel)
        
        countLabel.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView(_:))))
    }
    
    override func viewDidAppear(animated: Bool) {
        countLabel.animateCounting(0, to: 1000, duration: 2.0, timeFunc: .easeInOut)
    }
    
    var i = 0;
    func tapView(tap: UITapGestureRecognizer){
        var times : [TimeFuncType] = [.liner, .easeIn, .easeOut, .easeInOut]
        
        i += 1
        timeFuncView.time = times[i % times.count]
        
        timeFuncView.setNeedsDisplay()
        countLabel.animateCounting(0, to: 1000, duration: 2.0, timeFunc: .easeInOut)
    }
}

