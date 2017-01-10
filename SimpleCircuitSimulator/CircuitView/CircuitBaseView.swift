//
//  CircuitBaseView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/17.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit
import RandomColorSwift

let ViewAlpha = CGFloat(1.0)  //宏定义 View的透明度

//角度和弧度的变换
func DegreesToRadians (value:Double) -> Double {
    return value * M_PI / 180.0
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

var circuitTag : NSInteger = 1000   //设置Circuit的ViewTag

class CircuitBaseView: UIView {
    
    //相关情况属性
    var inputVoltage: Double //输入电压
    var outputVoltage: Double  //输出电压
    var electricCurrent: Double //流经电流
    
    var circuitInformationView: CircuitInformationView  //显示信息
    var countArc : Double  //作为连线的辅助参数
    
    var tagCircuitDelegate: TagCircuitDelegate?
    //下面为辅助参数
    var boolSelected: Bool?
    var oldPosition: CGPoint?
    var oldFrame: CGRect?
    var oldCircuitView: CircuitBaseView?
    
    var asStartPoint: NSMutableSet = NSMutableSet.init()   //作为连接的起始点
    var asEndPoint: NSMutableSet = NSMutableSet.init()     //作为连接的结束点
    
    override init(frame: CGRect) {
        inputVoltage = 0.0
        outputVoltage = 0.0
        electricCurrent = 0.0
        countArc = 0.0  //初始化
        self.circuitInformationView = CircuitInformationView.instance()
        super.init(frame: frame)
        
        if (self.layer.borderColor != nil)
        {
            let redColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.5)
            self.layer.borderColor = redColor.cgColor  //设置边框颜色
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizers:)))
        longPressRecognizer.minimumPressDuration = 0.6
        
        let tagRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTag(gestureRecognizers:)))
        
        let panRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(gestureRecognizers:)))
        
        self.addGestureRecognizer(longPressRecognizer)
        self.addGestureRecognizer(tagRecognizer)
        self.addGestureRecognizer(panRecognizer)
        
        self.tag = circuitTag + 1
        circuitTag += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.circuitInformationView = CircuitInformationView.instance()
        inputVoltage = 0.0
        outputVoltage = 0.0
        electricCurrent = 0.0
        countArc = 0.0  //初始化
        super.init(coder: aDecoder)
        //  fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    //在哪一个点建立InformationView
    func showInformationView(position: CGPoint) {

        self.circuitInformationView.removeFromSuperview()
        self.circuitInformationView.frame.origin = position
        self.setCircuitInformationView()  //配置informationView上显示的信息
        if let superView = self.superview
        {
            superView.addSubview(self.circuitInformationView)
        }
    }
    
    //根据自身的Circuit属性配置InformationView
    func setCircuitInformationView() {
        self.circuitInformationView.circuitTypeLabel.text = "电源"
        self.circuitInformationView.circuitPropertyLabel.text = "电压:"
        self.circuitInformationView.circuitPropertyNumLabel.text = "000"
        self.circuitInformationView.circuitPropertyUnitsLabel.text = "V"
    }
    
    //MARK: -主要处理拖动事件
    func handleLongPress(gestureRecognizers:UILongPressGestureRecognizer) -> Void {
        if(gestureRecognizers.state == .began)
        {
            print(self.tag,  "LongPress began")
            self.circuitInformationView.removeFromSuperview()
            self.oldPosition = gestureRecognizers.location(in: superview!)
            self.oldFrame = self.frame
            self.alpha = 0.5
            
        }
        if(gestureRecognizers.state == .changed)
        {
            if(self.isOverSuperView())
            {
                gestureRecognizers.isEnabled = false
                return
            }
            if(self.isIntersectToTrashCan())
            {
                //如果触碰到垃圾桶，响应事件
            }
//            print(self.tag, "LongPress changed")
            var frame = self.frame
            let position = gestureRecognizers.location(in: self.superview)
            let x = position.x - (self.oldPosition!.x)
            let y = position.y - (self.oldPosition!.y)
            frame.origin.x = x + self.oldFrame!.origin.x
            frame.origin.y = y + self.oldFrame!.origin.y
            self.frame = frame
            if let superView = self.superview
            {
                //刷新绘画，使得连线跟着走
                superView.setNeedsDisplay()
            }
            
        }
        if(gestureRecognizers.state == .cancelled)
        {
            self.alpha = ViewAlpha
            gestureRecognizers.isEnabled = true
            print("self.tag, LongPress cancelled")
        }
        if(gestureRecognizers.state == .ended)
        {
            self.alpha = ViewAlpha
            print("self.tag, LongPress ended")
            if let superView = self.superview
            {
                superView.setNeedsDisplay()
            }
            
            //扔进垃圾桶
            if(self.isIntersectToTrashCan())
            {
                self.closeTrashCan()  //关闭垃圾桶盖子
                self.deleteRelation()  //删除与之相关的连接
                self.removeFromSuperview()  //移除Circuit
            }
        }
    }
    
    //MARK: -主要处理点击事件
    func handleTag(gestureRecognizers:UITapGestureRecognizer) -> Void {
        
        if(gestureRecognizers.state == .began)
        {
            print(self.tag, "Tag began")
        }
        if(gestureRecognizers.state == .changed)
        {
            print(self.tag, "Tag changed")
        }
        if(gestureRecognizers.state == .cancelled)
        {
            print(self.tag, "Tag cancelled")
        }
        if(gestureRecognizers.state == .ended)
        {
            print(self.tag, "Tag ended")
            let position = gestureRecognizers.location(in: self.superview)
            self.showInformationView(position: position)
        }
        if(gestureRecognizers.state == .recognized)
        {
            print(self.tag, "Tag recognized")
            //调用代理方法
            tagCircuitDelegate?.TagCircuit(viewTag: self.tag)
        }
    }
    
    //MARK: -主要处理连线事件
    func handlePan(gestureRecognizers:UIPanGestureRecognizer) -> Void {
        
        if(gestureRecognizers.state == .began)
        {
            print(self.tag, "Pan began")
            //            选中了显示边框
            self.layer.borderWidth = 3.0
        }
        
        if(gestureRecognizers.state == .changed)
        {
            print(self.tag, "Pan changed")
            
            let position = gestureRecognizers.location(in: self.superview)
            
            let superView = self.superview as! CircuitBackGroundView
            
            let color = randomColor(luminosity:.dark)  //生成随机颜色
            let rColor:CGColor = (color as UIColor).cgColor
            
            let line = Line.init(startPoint: self.layer.position, endPoint: position, color: rColor)
            
            superView.line = line
            superView.setNeedsDisplay()
            
            //检测是否有连接到另一个Circuit
            if let endView = superView.hitTest(position, with: nil)
            {
                //判断是否触碰到自身
                if endView.tag != self.tag
                {
                    if let endCircuit = endView as? CircuitBaseView
                    {
                        endCircuit.layer.borderWidth = 3.0
                        oldCircuitView = endCircuit
                        
                    }
                    else
                    {
                        if let oldCircuitView = oldCircuitView
                        {
                            oldCircuitView.layer.borderWidth = 0.0
                        }
                    }
                }
            }
        }
        
        if(gestureRecognizers.state == .cancelled)
        {
            print(self.tag, "Pan cancelled")
        }
        
        if(gestureRecognizers.state == .ended)
        {
            print(self.tag, "Pan ended")
            //            取消边框
            self.layer.borderWidth = 0.0
            let superView = self.superview as! CircuitBackGroundView
            superView.line = nil
            
            let position = gestureRecognizers.location(in: self.superview)
            if let endCircuit = superView.hitTest(position, with: nil)
            {
                if let endCircuit = endCircuit as? CircuitBaseView
                {
                    if(endCircuit == self || self.asEndPoint.contains(endCircuit))
                    {
                        return  //如果连接回自己，直接不连接 //或重复连接，就不连接
                    }
                    endCircuit.asStartPoint.add(self)
                    self.asEndPoint.add(endCircuit)
                    
                    endCircuit.layer.borderWidth = 0.0
                    superView.setNeedsDisplay()
                }
            }
            superView.setNeedsDisplay()
        }
    }
    
    //MARK: -触碰判断
    
    //判断是否超过了superview的范围
    func isOverSuperView() -> Bool
    {
        let point = CGPoint.init(x: (self.frame.origin.x + self.frame.width), y: (self.frame.origin.y + self.frame.height))
        
        if let superView = self.superview
        {
            if(!superView.frame.contains(point))
            {
                let newFrame = CGRect.init(origin: CGPoint.init(x: self.frame.origin.x - self.frame.width, y: self.frame.origin.y - self.frame.height), size: self.frame.size)
                self.frame = newFrame
                return true
            }
        }
        return false;
    }
    
    //判断是否触碰了垃圾箱
    func isIntersectToTrashCan() ->Bool
    {
        if let superView = self.superview
        {
            let trashCan = superView.viewWithTag(1111) as? TrashCan  //获得垃圾桶的View
            if(self.frame.intersects(trashCan!.frame))
            {
                trashCan?.openTrashCan()
                return true
            }
            else
            {
                trashCan?.closeTrashCan()
                return false
            }
        }
        
        return false
    }
    
    //关闭垃圾桶
    func closeTrashCan() -> Void {
        if let superView = self.superview
        {
            let trashCan = superView.viewWithTag(1111) as? TrashCan  //获得垃圾桶的View
            trashCan!.closeTrashCan()
        }

    }
    
    //移除与之有关的连接
    func deleteRelation() -> Void {
        circuitInformationView.removeFromSuperview()
        
        for endPoint in asEndPoint
        {
            if let endPoint = endPoint as? CircuitBaseView
            {
                endPoint.asEndPoint.remove(self);
            }
        }
        for startPoint in asStartPoint
        {
            if let startPoint = startPoint as? CircuitBaseView
            {
                startPoint.asEndPoint.remove(self);
            }
        }
    }
}
