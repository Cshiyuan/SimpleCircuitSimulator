//
//  CircuitBaseView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/7.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit
import UIView_draggable
import SnapKit


class CircuitControlsView: UIView {
    //@property (assign, nonatomic) CGPoint beginpoint;
    var beginpoint : CGPoint?
    var oldFrame : CGRect?
    
    var circuitBackGroundView : CircuitBackGroundView? //存放活动的View
    var circuitConfigView : CircuitConfigView?         //方便传递代理
    
    var changeX : CGFloat?
    var changeY : CGFloat?
    var backGroundUIImageView : UIImageView?
    
    var oldCircuitBase : CircuitBaseView?
    
    var circuitType : CircuitType? //记录电路器件的类型
    {
        //设置之后立即调用方法设置背景
        didSet{
            self.setBackGround()
        }
    }
    
    func add(view: CircuitBackGroundView)
    {
        self.circuitBackGroundView = view;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //  fatalError("init(coder:) has not been implemented")
    }
    
    //设置背景
    func setBackGround() {

        if let circuitType = self.circuitType
        {
            //根据circuitType设置电路器件的类型
            var backgroundImage : UIImage
            switch circuitType {
            case .CircuitElectricCapacity:
                backgroundImage = UIImage.init(named: "ElectricCapacity")!
            case .CircuitElectricResistance:
                backgroundImage = UIImage.init(named: "ElectricResistance")!
            case .CircuitElectricSource:
                backgroundImage = UIImage.init(named: "ElectricSource")!

            }
            
            let backgroundImageView = UIImageView.init(frame: self.frame)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode  = .scaleToFill
            backgroundImageView.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
            
            self.backGroundUIImageView = backgroundImageView
            //        backgroundImageView.alpha = 0.6
            
            self.addSubview(backgroundImageView)
            self.sendSubview(toBack: backgroundImageView)
           
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        if let touch = touches.first
        {
            self.beginpoint = touch.location(in: self);
            self.oldFrame = self.frame
            self.changeX = 0.0
            self.changeY = 0.0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchMoved")
        super.touchesMoved(touches, with: event)
        if let touch = touches.first
        {
            let currentLocation = touch.location(in: self)
            var frame = self.frame
            print(currentLocation)
            
            //累积计算x和y的变化值
            self.changeX! += (currentLocation.x - self.beginpoint!.x)
            self.changeY! += (currentLocation.y - self.beginpoint!.y)
            
            frame.origin.x = frame.origin.x + (currentLocation.x - self.beginpoint!.x);
            frame.origin.y = frame.origin.y + (currentLocation.y - self.beginpoint!.y);
            self.frame = frame
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        if let touch = touches.first{
            
            let currentLocation = touch.location(in: self)
            
            print(currentLocation)
            
            //动画返回到原来的位置
            UIView.animate(withDuration: 0.3, animations: {
                
                self.layer.setAffineTransform(CGAffineTransform.init(translationX: -self.changeX!, y: -self.changeY!))
                
            }) { (Bool) in
                
                self.layer.setAffineTransform(CGAffineTransform.identity)
                self.frame = self.oldFrame!
                
            }
        }
        
        if let touch = touches.first
        {
            let currentLocation = touch.location(in: circuitBackGroundView)
            print("currentLocation",currentLocation)
            //判断是否到了CircuitBackGroundView内部
            if circuitBackGroundView!.frame.contains(currentLocation) {
                let frame = CGRect.init(x: currentLocation.x, y: currentLocation.y, width: self.frame.width , height: self.frame.height)
                let circuitView = CircuitFactory.create(circuitType:self.circuitType!, frame: frame)
                circuitView.tagCircuitDelegate = circuitConfigView
                self.circuitBackGroundView?.addSubview(circuitView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let backgroundImageView = self.backGroundUIImageView
        {
            backgroundImageView.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(2)
                make.left.equalTo(self).offset(2)
                make.bottom.equalTo(self).offset(-2)
                make.right.equalTo(self).offset(-2)
            }
        }
        
    }
    //    override func l
}
