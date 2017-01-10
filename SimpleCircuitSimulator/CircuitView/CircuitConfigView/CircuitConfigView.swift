//
//  CircuitConfigView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/23.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit

class CircuitConfigView: UIView, TagCircuitDelegate {
    
    @IBOutlet var circuitConfigView: UIView!
    
    @IBOutlet weak var configPropertyUnitsLabel: UILabel!
    
    @IBOutlet weak var configPropertyTextField: UITextField!
    
    @IBOutlet weak var configPropertyLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    var circuitBackGround : CircuitBackGroundView?
    var viewTag : Int?
    
    //从xib中载人
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
        let className = "CircuitConfigView"
        let mainBundle = Bundle.main
        mainBundle.loadNibNamed(className, owner: self, options: nil)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.addSubview(self.circuitConfigView)
        var subRect = self.frame
        subRect.origin.x = 0
        subRect.origin.y = 0
        self.circuitConfigView.frame = subRect
        
        self.configPropertyTextField.keyboardType = .numbersAndPunctuation
        self.configPropertyTextField.clearButtonMode = .whileEditing
    }
    
    func setBackGround(backgroundView : CircuitBackGroundView)
    {
        self.circuitBackGround = backgroundView
    }
    
    
    @IBAction func setConfigToCircuit(_ sender: Any) {
        if let circuitBackGround = self.circuitBackGround
        {
            let circuitView = circuitBackGround.viewWithTag(self.viewTag!) as! CircuitDelegate
            let numText = self.configPropertyTextField.text;
            if let numText = numText
            {
                circuitView.set(property: NSString(string: numText).doubleValue)  //设置
            }
            
        }
        
        
    }
    
    //MARK: -实现了
    func TagCircuit(viewTag: Int) {
        
        self.viewTag = viewTag
        
        if let circuitBackGround = self.circuitBackGround
        {
            let circuitView = circuitBackGround.viewWithTag(viewTag) as! CircuitDelegate
            let information = circuitView.getInformation()
            setConfigType(circuitType: information.0,value: information.1)
        }
        
        self.setNeedsDisplay()
    }
    
    func setConfigType(circuitType:CircuitType, value:Double) {
        
        switch circuitType {
        case CircuitType.CircuitElectricSource:
            self.typeLabel.text = "电源"
            if value == 0.0
            {
                self.configPropertyTextField.text = "0.0"
            }
            else
            {
                self.configPropertyTextField.text = String(format: "%.5f", value)
            }
            self.configPropertyLabel.text = "(电压)伏特"
            self.configPropertyUnitsLabel.text = "V"
            
        case CircuitType.CircuitElectricResistance:
            self.typeLabel.text = "电阻"
            self.configPropertyTextField.text = String(format: "%.5f", value)
            self.configPropertyLabel.text = "(电阻)欧姆"
            self.configPropertyUnitsLabel.text = "Ω"
            
        case CircuitType.CircuitElectricCapacity:
            self.typeLabel.text = "电容"
            if value == 0.0
            {
                self.configPropertyTextField.text = "0.0"
            }
            else
            {
                self.configPropertyTextField.text = String(format: "%.5f", value)
            }
            self.configPropertyLabel.text = "(电容量)法拉"
            self.configPropertyUnitsLabel.text = "uf"
        }
        
    }
}
