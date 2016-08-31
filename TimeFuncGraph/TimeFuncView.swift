//
//  TimeFuncView.swift
//  TimeFuncGraph
//
//  Created by peer on 16/8/30.
//  Copyright © 2016年 peer. All rights reserved.
//

import Foundation
import UIKit

typealias XYProgress = (x:Double, y:Double)

enum TimeFuncType{
    case liner, easeIn, easeOut, easeInOut
    
    func linerFunc(percent: Double) -> Double{
        return percent
    }
    
    func easeInFunc(percent: Double) -> Double {
        return Double(1 - powf(Float((1.0-percent)), 3))
    }
    
    func easeOutFunc(percent: Double) ->Double{
        return Double(powf(Float(percent), 3))
    }
    
    func easeInOutFunc(percent: Double) -> Double{
        var sign:Double = 1.0;
        let r: Double = 3;
        if (r % 2 == 0)
        {
            sign = -1.0;
        }
        var t = percent;
        t *= 2;
        if (t < 1)
        {
            return 0.5 * Double(powf(Float(t), Float(r)));
        }
        else
        {
            return Double(sign * 0.5 * (Double(powf(Float(t-2), Float(r))) + sign*2))
        }
    }
    
    // x-> (0,1) => y->(0,1) 根据时间曲线类型由x坐标计算y
    func progressY(x: Double) -> Double{
        var y: Double = 0
        switch  self {
        case .liner:
            y = linerFunc(x)
        case .easeIn:
            y = easeInFunc(x)
        case .easeOut:
            y = easeOutFunc(x)
        case .easeInOut:
            y = easeInOutFunc(x)
        }
        return y;
    }
    
    func generateTimeFuncProgress() -> [XYProgress] {
        var proList: [XYProgress] = []
        
        //由0到1生成100个点
        for i in 0.00.stride(through: 1.0, by: 0.01) {
            proList.append((i, progressY(i)))
        }
        
        return proList;
    }
}

class TimeFuncView: UIView {
    let padding: CGFloat = 5
    
    var pointList: [CGPoint]!
    var time: TimeFuncType
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(frame:CGRect, time: TimeFuncType){
        self.time = time
        super.init(frame: frame)

        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    func convertProgressToPoints(proList: [XYProgress]){
        
        let width = frame.width - padding * 2
        let height = frame.height - padding * 2
        
        pointList = proList.map({ (x, y) -> CGPoint in
            let x = padding + CGFloat(x) * width
            let y = padding + CGFloat(y) * height
            
            return CGPoint(x: x, y: y)
        })
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        convertProgressToPoints(time.generateTimeFuncProgress())
        
        let c = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(c, 1, -1)
        CGContextTranslateCTM(c, 0, -rect.height)
        
        CGContextSetLineWidth(c, 2.0)
        CGContextSetStrokeColorWithColor(c, UIColor.redColor().CGColor)
        
        for (idx, p) in self.pointList.enumerate() {
            if (idx == 0) {
                CGContextMoveToPoint(c, p.x, p.y)
                continue
            }
            CGContextAddLineToPoint(c, p.x, p.y)
        }
        
        CGContextStrokePath(c)
        
    }
}