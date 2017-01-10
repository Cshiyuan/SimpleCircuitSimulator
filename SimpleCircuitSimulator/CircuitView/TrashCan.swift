//
//  TrashCan.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/30.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit

class TrashCan: UIImageView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var backgroundImageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.initBackGround()
        self.closeTrashCan()  //默认为关闭的
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.initBackGround()
        self.closeTrashCan()
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.closeTrashCan()   //默认为关闭的
//        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
//    func initBackGround()
//    {
//        self.backgroundImageView = UIImageView.init(frame: self.frame)
//        self.backgroundImageView?.contentMode  = .scaleToFill
//        self.backgroundImageView?.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
//    }
    
    //MARK: -设置垃圾桶打开的图片
    func closeTrashCan()
    {
        self.setBackGround(imageName: "TrashCan_Close")
    }
    
    func openTrashCan()
    {
        self.setBackGround(imageName: "TrashCan_Open")
    }
    
    //设置背景
    func setBackGround(imageName:String) {
//        let image = UIImage.init(named: imageName)
//        self.backgroundImageView?.image = image
        self.image = UIImage.init(named: imageName)
    }
}
