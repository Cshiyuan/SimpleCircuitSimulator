//
//  CircuitRunController.swift
//  SimpleCircuitSimulator
//
//  Created by bb on 2016/12/1.
//  Copyright © 2016年 chenshyiuan. All rights reserved.
//

import Foundation
import UIKit

struct RecordCircuit {  //辅助结构体
    
    var circuitBase : CircuitBaseView  //开始点
    var validOutputCount : NSInteger  //有效的输出连接数  彻底无效的会被置为0
    var validInputCount: NSInteger  //有效的输入连接数
    
    var calulateInputCount: NSInteger //辅助计算值
    var calulateBetween: NSInteger //辅助计算值
    var tempRoad: NSInteger //辅助计算值
    
    var calulateCurrentCount: NSInteger //辅助计算值
    var calulateResistanceArray: NSMutableDictionary //辅助计算值
    var calulateTempCurrent: Double //辅助计算的电流合
    
    init(circuitBase: CircuitBaseView) {  //初始化
        self.circuitBase = circuitBase
        validOutputCount = circuitBase.asEndPoint.count
        validInputCount = circuitBase.asStartPoint.count
        
        calulateInputCount = validInputCount
        calulateBetween = validOutputCount - validInputCount
        tempRoad = validOutputCount
        calulateCurrentCount = validInputCount
        calulateResistanceArray = NSMutableDictionary.init()
        
        calulateTempCurrent = 0
    }
    mutating func refreshStatue() -> Void
    {
        calulateInputCount = validInputCount
        calulateBetween = validOutputCount - validInputCount
        tempRoad = validOutputCount
        calulateCurrentCount = validInputCount
    }
}

class CircuitRunController : NSObject
{
    var circuitBackGroundView : CircuitBackGroundView
//    var 
    init(circuitBackGroundView:CircuitBackGroundView) {
        self.circuitBackGroundView = circuitBackGroundView
        super.init()
    }
    
    //模拟运行
    func runCheck() -> Void
    {
//        var electricSourceArray = NSMutableArray.init()
        let electricSourceArray = getConnectedElectricSource()
        for electricSource in electricSourceArray
        {
            if let electricSource = electricSource as? CircuitElectricSource
            {
                runFrom(electricSource: electricSource)
            }
        }
        
    }
    
    //获取所有的电源
    func getElectricSource() -> NSMutableArray{
        
        let circuitMutableArray = NSMutableArray.init()
        let circuits = circuitBackGroundView.subviews
        for circuit in circuits {
            if let electricSource = circuit as? CircuitElectricSource
            {
                circuitMutableArray.add(electricSource)
            }
        }
        return circuitMutableArray
    }
    
    //判断哪些电源是连通的
    func getConnectedElectricSource() ->NSMutableArray {
        
        let connectedElectricSourceMutableArray = NSMutableArray.init()
        let electricSources = self.getElectricSource()
        for electricSource in electricSources  //遍历所有的电源
        {
            if let electricSource  = electricSource as? CircuitElectricSource
            {
                if self.isConnected(electricSource: electricSource) {
                    connectedElectricSourceMutableArray.add(electricSource)
                }
            }
        }
        return connectedElectricSourceMutableArray
    }
    
    //是否连通的电源
    func isConnected(electricSource:CircuitElectricSource) -> Bool
    {
        let asTempEndEndPoint : NSMutableSet = NSMutableSet.init()
        let asTempEndPoint: NSMutableSet = NSMutableSet.init()
//        asTempEndPoint = electricSource.asEndPoint   //临时存储
        self.copy(FromSet: electricSource.asEndPoint, toSet: asTempEndPoint) //临时存储
        
        while asTempEndPoint.count != 0 {  //遍历到结束
            
            for circuitBaseView in asTempEndPoint
            {
                
                //如果已经连接回电源，返回真
                if(circuitBaseView as! CircuitBaseView == electricSource)
                {
                    return true
                }
                //不然接着连接查询,获取下一轮的电路器件
                if let circuitBaseView = circuitBaseView as? CircuitBaseView
                {
                    for endCircuitBaseView in circuitBaseView.asEndPoint {
                        asTempEndEndPoint.add(endCircuitBaseView)
                    }
                }
            }
            
            self.copy(FromSet: asTempEndEndPoint, toSet: asTempEndPoint)
        }
        return false
    }
    
    //从单个电源出发遍历，设置属性
    func runFrom(electricSource:CircuitElectricSource) -> Void
    {
        let circuitRecordArray = NSMutableArray.init()
        let tempCircuitsSet = NSMutableSet.init()  //收集一路的电器器件
        self.copy(FromSet: electricSource.asEndPoint, toSet: tempCircuitsSet)
        circuitRecordArray.add(RecordCircuit.init(circuitBase: electricSource));
        
        var complete = false
        while(!(tempCircuitsSet.contains(electricSource) && tempCircuitsSet.count == 1)) //直到遍历回原点
        {
            //一轮
            complete = true
            for circuitBase in tempCircuitsSet
            {
                if let circuitBase = circuitBase as? CircuitBaseView
                {
                    //没有包含
                    if !contain(circuitRecordArray: circuitRecordArray, circuit: circuitBase) {
                        circuitRecordArray.add(RecordCircuit.init(circuitBase: circuitBase));
                        complete = false  //做了修改
                    }
                }
            }
            
            if complete
            {
                break  //已完成跳出
            }
            
            //复制
            let tempTempCircuitSet = NSMutableSet.init()
            self.copy(FromSet: tempCircuitsSet, toSet: tempTempCircuitSet)
            
            //清空
            tempCircuitsSet.removeAllObjects()
            
            for circuit in tempTempCircuitSet  //遍历下一轮的Circuit //往下遍历
            {
                if let circuit = circuit as? CircuitBaseView
                {
                    for tempCircuit in circuit.asEndPoint
                    {
                        tempCircuitsSet.add(tempCircuit)
                    }
                }
            }
            for circuit in tempTempCircuitSet  //遍历上一轮的Circuit  //往上遍历
            {
                if let circuit = circuit as? CircuitBaseView
                {
                    for tempCircuit in circuit.asStartPoint
                    {
                        tempCircuitsSet.add(tempCircuit)
                    }
                }
            }
            //开始下一轮
        }
        
        
        //得到有纪录的circuitRecordArray  属于连通的这么一个图
        for circuitRecord in circuitRecordArray  //遍历修改其validOutputCount
        {
            if let circuitRecord = circuitRecord as? RecordCircuit
            {
                if circuitRecord.validOutputCount == 0
                {
                    minusStartCircuit(circuitRecord: circuitRecord, circuitRecordArray: circuitRecordArray)
                }
            }
        }
        
        
        for circuitRecord in circuitRecordArray  //遍历修改其validOutputCount
        {
            if let circuitRecord = circuitRecord as? RecordCircuit
            {
                if circuitRecord.validInputCount == 0
                {
                    minusEndCircuit(circuitRecord: circuitRecord, circuitRecordArray: circuitRecordArray)
                }
            }
        }
        
        
        for record in circuitRecordArray
        {
            if var record = record as? RecordCircuit
            {
                record.refreshStatue()
                let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: record.circuitBase)
                circuitRecordArray.replaceObject(at: i, with: record)
                print("-----")
                print(record.validInputCount)
                print(record.validOutputCount)
                print(record.calulateCurrentCount)
                print("-----")
            }
        }
        
//        print(calculateResistance(position: 0, circuitRecordArray: circuitRecordArray, series: false))
        let totalElectricResistance = calculateResistance(position: 0, circuitRecordArray: circuitRecordArray, series: false).0  //总电阻
        let totalElectricCurrent = electricSource.voltage/totalElectricResistance  //总电流
        
        print(totalElectricResistance)
        print(totalElectricCurrent)
        
        runCurrentToCircuit(current: totalElectricCurrent, position: 0, circuitRecordArray: circuitRecordArray)
        
//        print("end")
        

        
    }
    
    
    //计算一个电源的外接电阻  series判断是否是从并联过来的
    func calculateResistance(position:Int, circuitRecordArray:NSMutableArray, series:Bool) -> (Double,Int,Int)
    {
        var resistance = 0.0
        if var circuit = circuitRecordArray[position] as? RecordCircuit  //取出纪录
        {
            if let circuit = circuit.circuitBase as? CircuitElectricResistance  //如果自身是电阻
            {
                resistance = resistance + circuit.resistance //直接加
            }
            if circuit.circuitBase is CircuitElectricCapacity  //如果自身是电容
            {
                resistance = resistance + 1000000
            }
            
            if circuit.validOutputCount == 1  //接下来的是串联
            {
                for nextCircuit in circuit.circuitBase.asEndPoint  //检查其下连接的器件
                {
                    if let nextCircuit = nextCircuit as? CircuitBaseView
                    {
                        if let electricSourceRecord = circuitRecordArray[0] as? RecordCircuit
                        {
                            if nextCircuit == electricSourceRecord.circuitBase
                            {
                                return (resistance, -1, 0);  //已经遍历到最后了，跳出，返回
                            }
                        }
                        
                        let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: nextCircuit)  //获得这个器件的位置
                        if var tempCircuit = circuitRecordArray[i] as? RecordCircuit
                        {
                            if tempCircuit.validOutputCount != 0 //是有效器件
                            {
                                if series {  //由并联合并
                                    if tempCircuit.validInputCount > 1
                                    {
                                        tempCircuit.calulateInputCount  = tempCircuit.calulateInputCount - 1
                                        circuitRecordArray.replaceObject(at: i, with: tempCircuit)
                                        return (resistance, i, circuit.calulateBetween)  //返回，并返回合并为之
                                    }
                                }
                                resistance = resistance + calculateResistance(position: i, circuitRecordArray: circuitRecordArray, series: series).0 //加上这个器件的电阻
                            }
                        }
                    }
                }
            }
            if circuit.validOutputCount > 1  //接下里的是并联
            {
                var position = -1
                var tempResistance = 0.0  //临时电阻存储
                for nextCircuit in circuit.circuitBase.asEndPoint  //检查其下连接的器件
                {
                    if let nextCircuit = nextCircuit as? CircuitBaseView
                    {
                        if let electricSourceRecord = circuitRecordArray[0] as? RecordCircuit
                        {
                            if nextCircuit == electricSourceRecord.circuitBase
                            {
                                return (resistance, -1,circuit.calulateBetween);  //已经遍历到最后了，跳出,直接返回
                            }
                        }
                        
                        let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: nextCircuit)  //获得这个器件的位置
                        if let tempCircuit = circuitRecordArray[i] as? RecordCircuit
                        {
                            if tempCircuit.validOutputCount != 0 //是有效器件
                            {
                                let result = calculateResistance(position: i, circuitRecordArray: circuitRecordArray, series: true) //加上这个器件的电阻的倒数
                                
                                //通向这个位置的电阻
                                circuit.calulateResistanceArray.setValue(result.0, forKey: String(i))
                                
                                circuit.tempRoad = circuit.tempRoad + result.2
                                circuit.calulateBetween = circuit.calulateBetween + result.2
                                tempResistance = tempResistance + 1/result.0
                                position = result.1  //合并点
                                
                            }
                        }
                    }
                }
                resistance = resistance + 1/tempResistance  //计算完并联点
                //接着计算
                if(position != -1)
                {
                    if let circuitRecord = circuitRecordArray[position] as? RecordCircuit
                    {
                        if circuitRecord.calulateInputCount == 0 && circuitRecord.validInputCount == circuit.tempRoad
                        {
                            let result = calculateResistance(position: position, circuitRecordArray: circuitRecordArray, series: series)
                            resistance = resistance + result.0
                            circuit.tempRoad  = circuit.tempRoad + result.2
                            circuit.calulateBetween = circuit.calulateBetween + result.2
                            if(result.1 != -1)
                            {
                                position = result.1
                            }
                        }
                    }
                }
            }

            circuitRecordArray.replaceObject(at: position, with: circuit)
        }
        //        print(resistance)
        if let circuit = circuitRecordArray[position] as? RecordCircuit  //取出纪录
        {
            return (resistance,-1,circuit.calulateBetween)
        }
        else
        {
            return (resistance,-1,0)
        }
        
    }
    
    //输入电流，接着设置相应属性
    func runCurrentToCircuit(current:Double, position:Int, circuitRecordArray:NSMutableArray) -> Void
    {
        if let tempCircuitRecord = circuitRecordArray[position] as? RecordCircuit
        {
            //电阻
            if let circuit = tempCircuitRecord.circuitBase as? CircuitElectricResistance
            {
                circuit.passCurrent = current
                circuit.assignedVoltage = current * circuit.resistance  //电压等于电流乘电阻
            }
            //电源
            if let circuit = tempCircuitRecord.circuitBase as? CircuitElectricCapacity
            {
                circuit.passCurrent = current
            }
            //电源
            if let circuit = tempCircuitRecord.circuitBase as? CircuitElectricSource
            {
                circuit.passCurrent = current
                circuit.assignedVoltage = 0
            }
            //将电流分给接下的电器件
            //遍历到包含电源部分，返回
            if tempCircuitRecord.circuitBase.asEndPoint.contains(circuitRecordArray[0]) {
                return
            }
            //接下来串联
            if tempCircuitRecord.validOutputCount == 1{
                let nextCircuit = tempCircuitRecord.circuitBase.asEndPoint.anyObject()
                if let nextCircuit = nextCircuit as? CircuitBaseView
                {
                    let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: nextCircuit) //获得接下来的位置
                    if var circuitRecord = circuitRecordArray[i] as? RecordCircuit
                    {
                        circuitRecord.calulateCurrentCount = circuitRecord.calulateCurrentCount - 1
                        circuitRecord.calulateTempCurrent = circuitRecord.calulateTempCurrent + current
                        circuitRecordArray.replaceObject(at: i, with: circuitRecord)
                        if circuitRecord.calulateCurrentCount == 0  //可以接着计算下一步
                        {
                            runCurrentToCircuit(current: circuitRecord.calulateTempCurrent, position: i, circuitRecordArray: circuitRecordArray)  //输入电流
                        }
                    }

                }
            }
            //接下来并联
            if tempCircuitRecord.validOutputCount > 1{
                for nextCircuit in tempCircuitRecord.circuitBase.asEndPoint  //遍历接下里的器件
                {
                    if let nextCircuit = nextCircuit as? CircuitBaseView
                    {
                        let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: nextCircuit) //获得接下来的位置
                        if var circuitRecord = circuitRecordArray[i] as? RecordCircuit
                        {
                           if circuitRecord.validOutputCount > 0    //属于有效电路
                           {
                            var totalResistance = 0.0  //计算总电阻
                            for resistance in tempCircuitRecord.calulateResistanceArray
                            {
                                totalResistance = totalResistance + (resistance.value as! Double)
                            }
                            
                             var nodeCurrent = 0.0
                             if let resistance = (tempCircuitRecord.calulateResistanceArray[String(i)] as? Double)//获得此电阻
                             {
                                //应该分流到这里的电流
                                nodeCurrent = ((totalResistance - resistance)/totalResistance)*current
                             }

                            circuitRecord.calulateTempCurrent = circuitRecord.calulateTempCurrent + nodeCurrent
                            circuitRecord.calulateCurrentCount = circuitRecord.calulateCurrentCount - 1
                            circuitRecordArray.replaceObject(at: i, with: circuitRecord)
                            if circuitRecord.calulateCurrentCount == 0  //可以接着计算下一步
                            {
                                runCurrentToCircuit(current: circuitRecord.calulateTempCurrent, position: i, circuitRecordArray: circuitRecordArray)  //输入电流
                            }
                            
                           }
                        }
                    }
                }
            }
        }

    }
    
    
    
    
    //MARK: -协助方法
    
    //在circuitRecordArray中找到相应circuitBaseView的位置
    func checkCircuitBaseInCircuitRecordArray(circuitRecordArray:NSMutableArray,circuitBaseView:CircuitBaseView) -> Int
    {
        for i in 0...circuitRecordArray.count-1
        {
            if let circuitRecord = circuitRecordArray[i] as? RecordCircuit
            {
                if circuitRecord.circuitBase == circuitBaseView {
                    return i
                }
            }
        }
        return -1  //找不到返回负一
    }
    
    //将当前circuitRecord的上一层减1
    func minusStartCircuit(circuitRecord:RecordCircuit,circuitRecordArray:NSMutableArray) -> Void
    {
        for tempCircuit in circuitRecord.circuitBase.asStartPoint  //找到他的上一层 遍历它的上一层
        {
            if let tempCircuit = tempCircuit as? CircuitBaseView  //转为CircuitBaseView
            {
                let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: tempCircuit)
                if i != -1 {  //找到了它的上一层的circuitBaseView的位置
                    let circuit2 = circuitRecordArray.object(at: i)
                    if var circuit2 = circuit2 as? RecordCircuit  //获取它相应的位置
                    {
                        //将上一层的减1
                        circuit2.validOutputCount = circuit2.validOutputCount - 1
                        circuitRecordArray.replaceObject(at: i, with: circuit2)
                        if circuit2.validOutputCount == 0 //如果减为0了
                        {
                            minusStartCircuit(circuitRecord: circuit2, circuitRecordArray: circuitRecordArray)  //递归接着减
                        }
                        
                    }
                }
            }
        }
    }
    
    //将当前ciruitRecord的下一层入数减1
    func minusEndCircuit(circuitRecord:RecordCircuit,circuitRecordArray:NSMutableArray) -> Void
    {
        for tempCircuit in circuitRecord.circuitBase.asEndPoint  //找到他的下一层 遍历它的下一层
        {
            if let tempCircuit = tempCircuit as? CircuitBaseView  //转为CircuitBaseView
            {
                let i = checkCircuitBaseInCircuitRecordArray(circuitRecordArray: circuitRecordArray, circuitBaseView: tempCircuit)
                if i != -1 {  //找到了它的下一层的circuitBaseView的位置
                    if var circuit2 = circuitRecordArray[i] as? RecordCircuit  //获取它相应的位置
                    {
                        //将上一层的减1
                        circuit2.validInputCount = circuit2.validInputCount - 1
                        circuitRecordArray.replaceObject(at: i, with: circuit2)
                        if circuit2.validInputCount == 0 //如果减为0了
                        {
                            minusEndCircuit(circuitRecord: circuit2, circuitRecordArray: circuitRecordArray)  //递归接着减
                        }
                    }
                }
            }
        }
    }
    
    //判断包含
    func contain(circuitRecordArray:NSMutableArray,circuit:CircuitBaseView) -> Bool
    {
        for circuitRecord in circuitRecordArray
        {
            if let circuitRecord = circuitRecord as? RecordCircuit
            {
                if circuitRecord.circuitBase == circuit
                {
                    return true
                }
            }
        }
        return false;
    }
    
    //拷贝一个NSMutableSet到了一个NSMutableSet
    func copy(FromSet:NSMutableSet, toSet:NSMutableSet) -> Void
    {
        toSet.removeAllObjects()
        for item in FromSet
        {
            toSet.add(item)
        }
    }
}
