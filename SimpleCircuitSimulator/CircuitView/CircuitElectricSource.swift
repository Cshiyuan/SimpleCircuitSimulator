//
//  circuitElectricSource.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/24.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import Foundation
import UIKit

class CircuitElectricSource : CircuitBaseView
{
//    var tagCircuitDelegate: TagCircuitDelegate?
    
    var voltage: Double  //电压属性
    
//    @IBOutlet weak var passCurrent: UILabel!  //经过电流
//    
//    @IBOutlet weak var assignedVoltage: UILabel!  //分配电压
    
    var passCurrent: Double //经过电流
    var assignedVoltage: Double //分配电压

    
    init(voltage: Double, frame: CGRect) {
        self.voltage = voltage
        self.assignedVoltage = 0
        self.passCurrent = 0
        super.init(frame: frame)
        self.setBackGround()  //设置背景

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.voltage = 0
        self.assignedVoltage = 0
        self.passCurrent = 0
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    //设置背景
    func setBackGround() {
        
        let backgroundImage = UIImage.init(named: "ElectricSource")
        
        let backgroundImageView = UIImageView.init(frame: self.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode  = .scaleToFill
        backgroundImageView.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        
        self.addSubview(backgroundImageView)
        self.sendSubview(toBack: backgroundImageView)
        
    }
    
    //重写根据自身的Circuit属性配置InformationView
    override func setCircuitInformationView() {
        self.circuitInformationView.circuitTypeLabel.text = "电源"
        self.circuitInformationView.circuitPropertyLabel.text = "电压:"
        
        let voltageString = String(format: "%.2f", self.voltage)
        self.circuitInformationView.circuitPropertyNumLabel.text = voltageString
        
        let passCurrentString = String(format: "%.2f", self.passCurrent)
        self.circuitInformationView.passCurrent.text = passCurrentString
        
        let assignedVoltageString = String(format: "%.2f", self.assignedVoltage)
        self.circuitInformationView.assignedVoltage.text = assignedVoltageString
        
        self.circuitInformationView.circuitPropertyUnitsLabel.text = "V"
    }

}

//MARK: - 实现CircuitDelegate
extension CircuitElectricSource : CircuitDelegate
{
    //返回元件的信息
    func getInformation () -> (CircuitType,Double)
    {
        return (CircuitType.CircuitElectricSource, self.voltage)
    }
    
    func set(property: Double) {
        self.voltage = property
    }
}

