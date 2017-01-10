//
//  CircuitConditionView.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/23.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit

class CircuitConditionView: UIView {
    
//    
//    @IBOutlet weak var circuitConditionView: UIView!
    
    
    @IBOutlet weak var InformationLabel: UILabel!
    
    @IBOutlet weak var voltageLabel: UILabel!

    @IBOutlet weak var electricCurrent: UILabel!
   
    
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

    static func instance() -> CircuitConditionView {
        
        let className = "CircuitConditionView"
        let mainBundle = Bundle.main
        let nibView = mainBundle.loadNibNamed(className, owner: self, options: nil)
        let circuitConditionView = nibView![0] as! CircuitConditionView
        //设置框架大小
        circuitConditionView.frame.size = CGSize.init(width: 80, height: 80)
        return circuitConditionView
        
    }
 
    
    
}
