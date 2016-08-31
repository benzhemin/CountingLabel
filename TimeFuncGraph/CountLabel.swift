//
//  CountLabel.swift
//  TimeFuncGraph
//
//  Created by peer on 16/8/31.
//  Copyright © 2016年 peer. All rights reserved.
//

import Foundation
import UIKit

class CountLabel: UILabel {
    var timer: CADisplayLink!
    var timeFunc : TimeFuncType!
    
    var beginTime: NSTimeInterval!
    var duration: NSTimeInterval!
    
    var from:Int!
    var to:Int!
    
    var formatValue : ((Int)->String) = {
        (rawValue) -> String in
        
        return String(rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func animateCounting(from :Int, to:Int, duration: NSTimeInterval,
                      timeFunc:TimeFuncType /*, formatValue:(Double)->String */){
        
        self.beginTime = NSDate().timeIntervalSince1970
        self.duration = duration
        self.timeFunc = timeFunc
        self.from = from
        self.to = to
        //self.formatValue = formatValue
        
        timer = CADisplayLink(target: self, selector: #selector(scheduleUpdateCount(_:)))
        timer.frameInterval = 1
        timer.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func scheduleUpdateCount(timer: CADisplayLink){
        let curTime = NSDate().timeIntervalSince1970
        
        let elapse = curTime - beginTime
        
        let progressX: Double = Double(elapse / duration)
        var ratio = timeFunc.progressY(progressX)
        
        if ratio > 1.0 {
            ratio = 1.0
            self.timer.invalidate()
        }
        
        let value = from + Int(ratio * Double((to - from)))
        
        let formatText = formatValue(value)
        
        self.text = formatText
    }
    
}