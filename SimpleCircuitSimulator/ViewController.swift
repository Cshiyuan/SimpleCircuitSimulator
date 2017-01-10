//
//  ViewController.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/6.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import UIKit
import UIView_draggable

class ViewController: UIViewController {

    @IBOutlet weak var runButton: UIButton!

    @IBOutlet weak var hintLabel: UILabel! //提示
    
    var circuitRunController : CircuitRunController!
    
    @IBOutlet weak var circuitBackGroundView: CircuitBackGroundView!
    
    @IBOutlet weak var clearCircuit: UIButton!
    
    @IBOutlet weak var electricSourceCircuitView: CircuitControlsView!
    
    @IBOutlet weak var electricResistanceCircuitView: CircuitControlsView!
    
    @IBOutlet weak var electricCapacityCircuitView: CircuitControlsView!
    
    @IBOutlet weak var circuitConfigView: CircuitConfigView!
    
    //模拟运行电路
    @IBAction func circuitRunAction(_ sender: Any) {
//        print(circuitBackGroundView.subviews.count)
        let connectedESs = circuitRunController.getConnectedElectricSource();
//        print(connectedESs.count)
        if connectedESs.count == 0
        {
            hintLabel.text = "没有发现连接成功的电路，请检查是否有连通电路"
        }
        
        circuitRunController.runCheck()
        
        for view in circuitBackGroundView.subviews
        {
            if let view = view as? CircuitBaseView
            {
                view.showInformationView(position: view.layer.position)
            }
        }
    }
    //显示所有器件信息
    @IBAction func showAllCircuitInfo(_ sender: Any) {
        for view in circuitBackGroundView.subviews
        {
            if let view = view as? CircuitBaseView
            {
                view.showInformationView(position: view.layer.position)
            }
        }
        
    }
    //清空电路
    @IBAction func clearCircuitAction(_ sender: Any) {
        
        print(circuitBackGroundView.subviews.count)
        for circuit in circuitBackGroundView.subviews
        {
            if let circuit = circuit as? CircuitBaseView
            {
                circuit.deleteRelation()
                circuit.removeFromSuperview()
            }
        }
        
        circuitBackGroundView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setConfigToCircuirControlsView()
        circuitRunController = CircuitRunController.init(circuitBackGroundView: circuitBackGroundView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //配置Circuit代码
    func setConfigToCircuirControlsView ()
    {
        electricSourceCircuitView.add(view: circuitBackGroundView)
        electricResistanceCircuitView.add(view: circuitBackGroundView)
        electricCapacityCircuitView.add(view: circuitBackGroundView)
        
        electricSourceCircuitView.circuitType = .CircuitElectricSource
        electricResistanceCircuitView.circuitType = .CircuitElectricResistance
        electricCapacityCircuitView.circuitType = .CircuitElectricCapacity
        
        electricSourceCircuitView.circuitConfigView = circuitConfigView
        electricResistanceCircuitView.circuitConfigView = circuitConfigView
        electricCapacityCircuitView.circuitConfigView = circuitConfigView
        
        circuitConfigView.circuitBackGround = circuitBackGroundView

    }
}

