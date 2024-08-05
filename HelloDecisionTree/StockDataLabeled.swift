//
//  StockDataLabeled.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

typealias LabeledNode = StockDataLabeled.StockDataLabeledNode
struct StockDataLabeled {
    
    struct StockDataLabeledNode: CustomStringConvertible {
        
        let year: Int
        let month: Int
        let day: Int
        
        let change: Float
        
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
            
            let changeString = String(format: "%.2f", change)
            
            let change1String = String(format: "%.2f", change1)
            let change2String = String(format: "%.2f", change2)
            let change3String = String(format: "%.2f", change3)
            let change4String = String(format: "%.2f", change4)
            let change5String = String(format: "%.2f", change5)
            
            return "y:\(year) m:\(month) d:\(day) (c: \(changeString)) (c1: \(change1String) c2: \(change2String) c3: \(change3String) c4: \(change4String) c5: \(change5String)) (su: \(streakUp)) (sd: \(streakDown)) (pcu: \(previousCloseWasUp)) (dpc: \(daysSincePreviousClose))"
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
        
        var index = 6
        while index < stockDataRaw.nodes.count {
            
            let back1 = stockDataRaw.nodes[index - 1]
            let back2 = stockDataRaw.nodes[index - 2]
            let back3 = stockDataRaw.nodes[index - 3]
            let back4 = stockDataRaw.nodes[index - 4]
            let back5 = stockDataRaw.nodes[index - 5]
            let back6 = stockDataRaw.nodes[index - 6]
            
            let current = stockDataRaw.nodes[index]
            
            let c1p = percentChange(start: back1.close, end: current.close)
            
            let b1p = percentChange(start: back2.close, end: back1.close)
            let b2p = percentChange(start: back3.close, end: back1.close)
            let b3p = percentChange(start: back4.close, end: back1.close)
            let b4p = percentChange(start: back5.close, end: back1.close)
            let b5p = percentChange(start: back6.close, end: back1.close)
            
            let s1p = percentChange(start: back2.close, end: back1.close)
            let s2p = percentChange(start: back3.close, end: back2.close)
            let s3p = percentChange(start: back4.close, end: back3.close)
            let s4p = percentChange(start: back5.close, end: back4.close)
            let s5p = percentChange(start: back6.close, end: back5.close)
            
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
                                            change: c1p,
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
        return ((end - start) / start) * 100.0
    }
    
    mutating func clear() {
        nodes.removeAll(keepingCapacity: true)
        
    }
    
    func measureOneMonthAfterCrash() {
        
        var stockDataRaw = StockDataRaw()
        stockDataRaw.load(fileName: "nasdaq_historical", fileExtension: "csv")
        
        let lengthOfCrash = 7
        let severityOfCrash = Float(-7.5)
        
        var index = lengthOfCrash
        
        var visited = stockDataRaw.nodes.map { _ in false }
        
        var count1M = 0
        var sum1M = Float(0.0)
        
        var count1W = 0
        var sum1W = Float(0.0)
        
        while index < stockDataRaw.nodes.count {
            
            let today = stockDataRaw.nodes[index]
            var nDaysBack = stockDataRaw.nodes[index - lengthOfCrash]
            if visited[index - lengthOfCrash] == false {
                
                let dip = percentChange(start: nDaysBack.close,
                                        end: today.close)
                if dip <= severityOfCrash {
                    
                    var paint = index - lengthOfCrash
                    while paint <= index {
                        visited[paint] = true
                        paint += 1
                    }
                    
                    var oneWeek = Float(0.0)
                    if index + 5 < stockDataRaw.nodes.count {
                        var nDaysForward = stockDataRaw.nodes[index + 5]
                        let delta = percentChange(start: today.close,
                                                  end: nDaysForward.close)
                        oneWeek = delta
                        count1W += 1
                        sum1W += delta
                    }
                    
                    var oneMonth = Float(0.0)
                    if index + 25 < stockDataRaw.nodes.count {
                        var nDaysForward = stockDataRaw.nodes[index + 25]
                        let delta = percentChange(start: today.close,
                                                  end: nDaysForward.close)
                        oneMonth = delta
                        count1M += 1
                        sum1M += delta
                    }
                    
                    
                    print("from \(nDaysBack.dateString) to \(today.dateString), a crash of \(dip), in 1 week \(oneWeek) change, in 1 month \(oneMonth) change")
                    
                }
                
                
            }
            index += 1
        }
        
        let averageOneWeek = sum1W / Float(count1W)
        let averageOneMonth = sum1M / Float(count1M)

        print("On Average, Changes by \(averageOneWeek)% in 5 business days")
        print("On Average, Changes by \(averageOneMonth)% in 25 business days")
        
        
        
    }
}
