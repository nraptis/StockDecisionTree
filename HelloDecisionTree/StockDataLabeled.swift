//
//  StockDataLabeled.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

struct StockDataLabeled {
    
    struct StockDataLabeledNode: CustomStringConvertible {
        
        let year: Int
        let month: Int
        let day: Int
        
        let change1: Float
        let change2: Float
        let change3: Float
        let change4: Float
        let change5: Float
        
        let streakUp: Int
        let streakDown: Int
        
        let previousCloseWasUp: Bool
        let daysSincePreviousClose: Int
        
        var description: String {
            let change1String = String(format: "%.2f", change1)
            let change2String = String(format: "%.2f", change2)
            let change3String = String(format: "%.2f", change3)
            let change4String = String(format: "%.2f", change4)
            let change5String = String(format: "%.2f", change5)
            
            return "y:\(year) m:\(month) d:\(day) (c1: \(change1String) c2: \(change2String) c3: \(change3String) c4: \(change4String) c5: \(change5String)) (su: \(streakUp)) (sd: \(streakDown)) (pcu: \(previousCloseWasUp)) (dpc: \(daysSincePreviousClose))"
        }
    }
    
    var nodes = [StockDataLabeledNode]()
    
    mutating func load(fileName: String = "nasdaq_historical", fileExtension: String = "csv") {
        var stockDataRaw = StockDataRaw()
        stockDataRaw.load(fileName: fileName, fileExtension: fileExtension)
        load(stockDataRaw: stockDataRaw)
    }
    
    mutating func load(stockDataRaw: StockDataRaw) {
        clear()
        
        var index = 5
        while index < stockDataRaw.nodes.count {
            
            let back1 = stockDataRaw.nodes[index - 1]
            let back2 = stockDataRaw.nodes[index - 2]
            let back3 = stockDataRaw.nodes[index - 3]
            let back4 = stockDataRaw.nodes[index - 4]
            let back5 = stockDataRaw.nodes[index - 5]
            
            let current = stockDataRaw.nodes[index]
            
            let b1p = percentChange(start: back1.close, end: current.close)
            let b2p = percentChange(start: back2.close, end: current.close)
            let b3p = percentChange(start: back3.close, end: current.close)
            let b4p = percentChange(start: back4.close, end: current.close)
            let b5p = percentChange(start: back5.close, end: current.close)
            
            let s1p = percentChange(start: back1.close, end: current.close)
            let s2p = percentChange(start: back2.close, end: back1.close)
            let s3p = percentChange(start: back3.close, end: back2.close)
            let s4p = percentChange(start: back4.close, end: back3.close)
            let s5p = percentChange(start: back5.close, end: back4.close)
            
            var streakUp = 0
            var previousCloseWasUp = false
            if s1p > 0.0 {
                previousCloseWasUp = true
                streakUp = 1
                if s2p > 0.0 {
                    streakUp = 2
                    if s3p > 0.0 {
                        streakUp = 3
                        if s4p > 0.0 {
                            streakUp = 4
                            if s5p > 0.0 {
                                streakUp = 5
                            }
                        }
                    }
                }
            }
            
            var streakDown = 0
            if s1p < 0.0 {
                streakDown = 1
                if s2p < 0.0 {
                    streakDown = 2
                    if s3p < 0.0 {
                        streakDown = 3
                        if s4p < 0.0 {
                            streakDown = 4
                            if s5p < 0.0 {
                                streakDown = 5
                            }
                        }
                    }
                }
            }
            
            var daysSincePreviousClose = 0
            
            let dateCurrent = Calendar.current.startOfDay(for: current.date)
            let dateBack = Calendar.current.startOfDay(for: back1.date)
            
            let numberOfDays = Calendar.current.dateComponents([.day], from: dateBack, to: dateCurrent)
            if let _numberOfDays = numberOfDays.day {
                daysSincePreviousClose = _numberOfDays
            }
            
            let node = StockDataLabeledNode(year: current.dateYear,
                                            month: current.dateMonth,
                                            day: current.dateDay,
                                            change1: b1p,
                                            change2: b2p,
                                            change3: b3p,
                                            change4: b4p,
                                            change5: b5p,
                                            streakUp: streakUp,
                                            streakDown: streakDown,
                                            previousCloseWasUp: previousCloseWasUp,
                                            daysSincePreviousClose: daysSincePreviousClose)
            nodes.append(node)
            index += 1
        }
    }
    
    private func percentChange(start: Float, end: Float) -> Float {
        guard start > 0.0001 else { return 0.0 }
        guard end > 0.0001 else { return 0.0 }
        return ((end - start) / start) * 100.0
    }
    
    mutating func clear() {
        nodes.removeAll(keepingCapacity: true)
        
    }
}
