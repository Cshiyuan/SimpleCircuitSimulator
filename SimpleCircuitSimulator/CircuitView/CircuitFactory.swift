//
//  circuitFactory.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/11/30.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import Foundation
import UIKit


//电路器件的枚举
enum CircuitType {
    case CircuitElectricSource
    case CircuitElectricResistance
    case CircuitElectricCapacity
}

protocol TagCircuitDelegate {
    
    func TagCircuit(viewTag:Int)
}

protocol CircuitDelegate {
    
    func getInformation() -> (CircuitType, Double)
    func set(property:Double) -> Void
//    var tagCircuitDelegate: TagCircuitDelegate? {get set} //协议设置的代理
}

//工厂方法
class CircuitFactory {
    
    static func create(circuitType:CircuitType, frame:CGRect) -> CircuitBaseView
    {
        switch circuitType {
        case .CircuitElectricSource:
            return CircuitElectricSource.init(voltage: 0, frame: frame)
        case .CircuitElectricResistance:
            return CircuitElectricResistance.init(resistance: 100.0, frame: frame)
        case .CircuitElectricCapacity:
            return CircuitElectricCapacity.init(capcaitance: 0, frame: frame)
        }
    }
    
}
