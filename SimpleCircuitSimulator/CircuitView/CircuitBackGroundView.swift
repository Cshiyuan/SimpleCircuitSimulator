//
//  CircuitBackGroundView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/21.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit
import RandomColorSwift

struct Line {
    
    var startPoint : CGPoint?  //开始点
    var endPoint : CGPoint?   //结束点
    var color : CGColor?   //颜色
    
    init(startPoint: CGPoint,endPoint: CGPoint,color:CGColor) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.color = color
    }
}


class CircuitBackGroundView: UIView {
    
    
    var lineArray : NSMutableArray = NSMutableArray.init()  //存放每一个连接的Circuit的Line
    var line: Line?   //作为动态的Line
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        //        clearCGContext()
        if let currentContext = UIGraphicsGetCurrentContext()
        {
            //刷新每一个Circuit的相联线
            self.refreshLineArray()
            //根据LineArray和动画Line画线
            drawLines(content: currentContext, lines: self.lineArray)
        }
    }
    
    //根据LineArray和动画Line画线
    private func drawLines(content: CGContext, lines:NSMutableArray)
    {
        if let myLine = self.line {
            drawLine(startPoint: myLine.startPoint!, endPoint: myLine.endPoint!, color: myLine
            .color!)
        }
        
        for line in lines
        {
            let startPoint = (line as! Line).startPoint
            let endPoint = (line as! Line).endPoint
            let color = (line as! Line).color
            drawLine(startPoint: startPoint!, endPoint: endPoint!, color: color!)
        }
    }
    
    //根据startPoint和endPoint画线
    private func drawLine(startPoint:CGPoint,endPoint:CGPoint,color:CGColor)
    {
        if let currentContext = UIGraphicsGetCurrentContext()
        {
            currentContext.setLineWidth(1.0)

            currentContext.setStrokeColor(color)
        
            currentContext.beginPath()
            
            //画箭头
            let middlePoint = CGPoint.init(x: (startPoint.x+endPoint.x)/2, y: (startPoint.y+endPoint.y)/2)  //找出中间点
            
            currentContext.move(to: middlePoint)
            currentContext.setFillColor(color)
            
            let angleBetween = -angleBetweenPoints(first: startPoint, CGPoint: endPoint)
            
            currentContext.addArc(center: middlePoint, radius: 15, startAngle: angleBetween - CGFloat( M_PI/4), endAngle: angleBetween + CGFloat(M_PI/4), clockwise: false)
//            if(startPoint.x == endPoint.x)  //竖线
//            {
//                if(startPoint.y <= endPoint.y)
//                {
//                    currentContext.addArc(center: middlePoint, radius: 15, startAngle: CGFloat(M_PI + M_PI/4), endAngle: CGFloat(M_PI + M_PI/4 + M_PI/2), clockwise: false)
//                }
//                else
//                {
//                    currentContext.addArc(center: middlePoint, radius: 15, startAngle: CGFloat(M_PI/4 ), endAngle: CGFloat(M_PI/4 + M_PI/2), clockwise: false)
//                }
//                
//            }
//            if(startPoint.y == endPoint.y)   //横线
//            {
//                if(startPoint.x <= endPoint.x)
//                {
//                    currentContext.addArc(center: middlePoint, radius: 15, startAngle: CGFloat(M_PI/2 + M_PI/4), endAngle: CGFloat(M_PI/2 + M_PI/4 + M_PI/2), clockwise: false)
//                }
//                else
//                {
//                    currentContext.addArc(center: middlePoint, radius: 15, startAngle: CGFloat(-M_PI/4), endAngle: CGFloat(-M_PI/4 + M_PI/2), clockwise: false)
//                }
//            }
            
            currentContext.closePath()
            currentContext.drawPath(using: .fillStroke)
            currentContext.strokePath()
            
            //画线
            currentContext.beginPath()
            currentContext.move(to: CGPoint.init(x: startPoint.x, y: startPoint.y))
            currentContext.addLine(to: CGPoint.init(x: endPoint.x, y: endPoint.y))
            
            currentContext.strokePath()
        }
    }
    
//    //返回被触碰到的subview（Circuit）
//    func touchUIView(point:CGPoint) ->UIView?
//    {
//        return self.hitTest(point, with: nil)
//    }
    
    //从每一个subview(Circuit)中获取信息并放置到lineArray中
    func refreshLineArray()
    {
        
        lineArray.removeAllObjects()
        for subview in subviews
        {
            if let circuit = subview as? CircuitBaseView
            {
                circuit.countArc = 0.0
                
                for endCircuit in circuit.asEndPoint  //遍历每一个连接的点
                {
                    if let endCircuit = endCircuit as? CircuitBaseView
                    {

                        let angle = angleBetweenPoints(first: circuit.layer.position, CGPoint: endCircuit.layer.position)
                        
                        let startPoint = getPointInRound(centerPoint: circuit.layer.position, radius: circuit.frame.width/2 + 40, angle: angle - CGFloat(M_PI))
                        //获得转动后的起始点
                        
                        let endPoint = getPointInRound(centerPoint: endCircuit.layer.position, radius: circuit.frame.width/2 + 40, angle: angle)
                        //获得转动后的结束点
                        
                        endCircuit.countArc = endCircuit.countArc + 3.0
                        circuit.countArc = circuit.countArc + 3.0
                        
                        let color = randomColor(luminosity:.dark)  //生成随机颜色
                        let rColor:CGColor = (color as UIColor).cgColor
                        
                        let constStartLine = Line.init(startPoint: circuit.layer.position, endPoint: startPoint, color: rColor)
                        let constEndLine = Line.init(startPoint: endCircuit.layer.position, endPoint: endPoint, color: rColor)
                        
                        lineArray.add(constStartLine)
                        lineArray.add(constEndLine)
                        
                        if isOneLine(startPoint: startPoint, endPoint: endPoint)
                        {
                            let line = Line.init(startPoint: startPoint, endPoint: endPoint,color: rColor)
                            lineArray.add(line)
                            
                        } else {
                            let lines = RefactorLine(startPoint: startPoint, to: endPoint,color: rColor)
                            lineArray.add(lines.firstLine)
                            lineArray.add(lines.secondLine)
                            lineArray.add(lines.thirdLine)
                        }

                    }
                    
                }
            }
        }
    }
    
    //重构线条
    func RefactorLine(startPoint: CGPoint, to endPoint: CGPoint, color:CGColor) -> (firstLine : Line, secondLine : Line, thirdLine : Line) {
        
 
        let midPoint = CGPoint.init(x: (startPoint.x + endPoint.x)/2, y: (startPoint.y + endPoint.y)/2)
        
        let firstLine = Line.init(startPoint: startPoint, endPoint: CGPoint.init(x: midPoint.x, y: startPoint.y),color: color)
        let secondLine = Line.init(startPoint: CGPoint.init(x: midPoint.x, y: startPoint.y), endPoint: CGPoint.init(x: midPoint.x, y: endPoint.y),color: color)
        let thirdLine = Line.init(startPoint: CGPoint.init(x: midPoint.x, y: endPoint.y), endPoint: endPoint,color: color)
        
        return (firstLine,secondLine,thirdLine)
    }
    
    //判断是不是在一条线
    func isOneLine(startPoint:CGPoint,endPoint:CGPoint) -> Bool {
        
        if abs(startPoint.x - endPoint.x) < 80 {
            return true
        }
        
        if abs(startPoint.y - endPoint.y) < 80 {
            return true
        }
        
        return false
    }
    
    func getPointInRound(centerPoint:CGPoint, radius:CGFloat, angle:CGFloat) -> CGPoint {
        

        
        let y = radius * sin(angle);
        let x = radius * cos(angle);

        let point = CGPoint.init(x: centerPoint.x + x, y: centerPoint.y - y)
        return point
    }
    
    func angleBetweenLines(line1Start:CGPoint, line1End:CGPoint, line2Start:CGPoint, line2End:CGPoint) -> CGFloat {
    
        let a = line1End.x - line1Start.x;
        let b = line1End.y - line1Start.y;
        let c = line2End.x - line2Start.x;
        let d = line2End.y - line2Start.y;
    
        let rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));

        return CGFloat(RadiansToDegrees(value: Double(rads)))
    
    }
    
    func angleBetweenPoints(first:CGPoint, CGPoint second:CGPoint) -> CGFloat {
        let height = second.y - first.y;
        let width = first.x - second.x;
        let hypotenuse = sqrt(height*height+width*width)
        var rads = asin(height/hypotenuse)
        
        if(width < 0)
        {
            rads = CGFloat(M_PI) - rads
        }
        
        print("angle is ",height/hypotenuse)
        return rads
    }
    
}
