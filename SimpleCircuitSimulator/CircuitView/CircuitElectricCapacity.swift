//
//  circuitElectricCapacity.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/24.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import Foundation
import UIKit

class CircuitElectricCapacity : CircuitBaseView {
    
    var capacitance : Double  //电容属性
    
    var passCurrent: Double //经过电流
    
    var assignedVoltage: Double //分配电压
    
    init(capcaitance: Double, frame:CGRect) {
        self.capacitance = capcaitance
        self.passCurrent = 0
        self.assignedVoltage = 0
        super.init(frame: frame)
        self.setBackGround()  //设置背景
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.capacitance = 0;
        self.passCurrent = 0
        self.assignedVoltage = 0
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    //设置背景
    func setBackGround() {
        
        let backgroundImage = UIImage.init(named: "ElectricCapacity")
        
        let backgroundImageView = UIImageView.init(frame: self.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode  = .scaleToFill
        backgroundImageView.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        
        self.addSubview(backgroundImageView)
        self.sendSubview(toBack: backgroundImageView)
    }
    
    //重写根据自身的Circuit属性配置InformationView
    override func setCircuitInformationView() {
        self.circuitInformationView.circuitTypeLabel.text = "电容"
        self.circuitInformationView.circuitPropertyLabel.text = "电容:"
        self.circuitInformationView.circuitPropertyNumLabel.text = String(self.capacitance)
        
        let passCurrentString = String(format: "%.1f", self.passCurrent)
        self.circuitInformationView.passCurrent.text = passCurrentString
        
        let assignedVoltageString = String(format: "%.1f", self.assignedVoltage)
        self.circuitInformationView.assignedVoltage.text = assignedVoltageString
        
        self.circuitInformationView.circuitPropertyUnitsLabel.text = "uf"
    }
}

//MARK: - 实现CircuitDelegate
extension CircuitElectricCapacity : CircuitDelegate
{
    //返回元件的信息
    func getInformation () -> (CircuitType,Double)
    {
        return (CircuitType.CircuitElectricCapacity, self.capacitance)
    }
    
    func set(property: Double) {
        self.capacitance = property
    }
}
