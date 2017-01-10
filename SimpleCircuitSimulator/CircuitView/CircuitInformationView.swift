//
//  CircuitInformation.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/12/1.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit

class CircuitInformationView: UIView {

    
//    @IBOutlet weak var circuitConditionView: UIView!
    
    @IBOutlet weak var circuitTypeLabel: UILabel!
    
    @IBOutlet weak var passCurrent: UILabel!  //经过电流
    
    @IBOutlet weak var assignedVoltage: UILabel!  //经过电压
    
    @IBOutlet weak var circuitPropertyLabel: UILabel!
    
    @IBOutlet weak var circuitPropertyNumLabel: UILabel!
    
    @IBOutlet weak var circuitPropertyUnitsLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    
    //从xib中载人
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    static func instance() -> CircuitInformationView {
        
        let className = "CircuitInformationView"
        let mainBundle = Bundle.main
        let nibView = mainBundle.loadNibNamed(className, owner: self, options: nil)
        let circuitInformationView = nibView![0] as! CircuitInformationView
        //设置框架大小
        circuitInformationView.frame.size = CGSize.init(width: 100, height: 100)
        return circuitInformationView
        
    }

}
