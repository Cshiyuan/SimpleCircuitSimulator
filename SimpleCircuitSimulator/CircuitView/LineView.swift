//
//  LineView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/20.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    /*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.
     
     */
    
    override func draw(_ rect: CGRect) {
        if let currentContext = UIGraphicsGetCurrentContext()
        {
            currentContext.setLineWidth(1.0)
            currentContext.setStrokeColor(UIColor.red.cgColor)
            currentContext.beginPath()
            currentContext.move(to: CGPoint.init(x: 0, y: 0))
            currentContext.addLine(to: CGPoint.init(x: self.frame.width, y: self.frame.height))
            currentContext.strokePath()
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        self.backgroundColor = UIColor.black
        //        super.init(frame: CGRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //  fatalError("init(coder:) has not been implemented")
    }
    

    func setMaskWithUIBezierPath(bezierPath: UIBezierPath) ->Void {
        
        //蒙板
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.frame = self.frame;
        self.layer.mask = maskLayer;
        
        //边框面板
        let maskBorderLayer = CAShapeLayer.init()
        maskBorderLayer.path = bezierPath.cgPath
        maskBorderLayer.fillColor = UIColor.black.cgColor
        maskBorderLayer.strokeColor = UIColor.black.cgColor
        maskBorderLayer.lineWidth = 4
        self.layer.addSublayer(maskBorderLayer)
    }
}
