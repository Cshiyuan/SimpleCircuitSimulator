//
//  circuitElectricResistance.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/24.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import Foundation
import UIKit

class CircuitElectricResistance : CircuitBaseView {
    
//    var tagCircuitDelegate: TagCircuitDelegate?

    var resistance : Double  //电阻属性
    
    var passCurrent: Double //经过电流
    
    var assignedVoltage: Double //分配电压
    
    init(resistance : Double, frame: CGRect) {
        self.resistance = resistance
        self.passCurrent = 0
        self.assignedVoltage = 0
        
        super.init(frame: frame)
        self.setBackGround()  //设置背景
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.resistance = 0
        self.passCurrent = 0
        self.assignedVoltage = 0
        
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    

    
    //设置背景
    func setBackGround() {
        
        let backgroundImage = UIImage.init(named: "ElectricResistance")
        
        let backgroundImageView = UIImageView.init(frame: self.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode  = .scaleToFill
        backgroundImageView.frame.origin = CGPoint.init(x: 0.0, y: 0.0)

        self.addSubview(backgroundImageView)
        self.sendSubview(toBack: backgroundImageView)
    }
    
    //重写根据自身的Circuit属性配置InformationView
    override func setCircuitInformationView() {
        self.circuitInformationView.circuitTypeLabel.text = "电阻"
        self.circuitInformationView.circuitPropertyLabel.text = "电阻:"
        self.circuitInformationView.circuitPropertyNumLabel.text = String(self.resistance)
        
        let passCurrentString = String(format: "%.2f", self.passCurrent)
        self.circuitInformationView.passCurrent.text = passCurrentString
        
        let assignedVoltageString = String(format: "%.2f", self.assignedVoltage)
        self.circuitInformationView.assignedVoltage.text = assignedVoltageString
        
        self.circuitInformationView.circuitPropertyUnitsLabel.text = "Ω"
    }
}

//MARK: - 实现CircuitDelegate
extension CircuitElectricResistance : CircuitDelegate{

    //返回元件的信息
    func getInformation () -> (CircuitType,Double)
    {
        return (CircuitType.CircuitElectricResistance ,self.resistance)
    }
    
    func set(property: Double) {
        self.resistance = property
    }
}
