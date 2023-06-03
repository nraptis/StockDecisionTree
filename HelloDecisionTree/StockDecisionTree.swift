//
//  StockDecisionTree.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

enum Comparison {
    case lessThan
    case lessThanEqual
    case equal
    case greaterThanEqual
    case greaterThan
}

class StockDecisionTree {
    
    enum CriteriaType {
        case Float
        case Int
        case Bool
    }
    
    
    
    enum Criteria {
        case streakUp
        case streakDown
        
        case change1
        case change2
        case change3
        case change4
        case change5
        
        case previousCloseWasUp
        case daysSincePreviousClose
    }
    
    private func valueBool(criteria: Criteria, node: LabeledNode) -> Bool {
        switch criteria {
        case .previousCloseWasUp:
            return node.previousCloseWasUp
        default:
            return false
        }
    }
    
    private func valueInt(criteria: Criteria, node: LabeledNode) -> Int {
        switch criteria {
        case .streakUp:
            return node.streakUp
        case .streakDown:
            return node.streakDown
        case .daysSincePreviousClose:
            return node.daysSincePreviousClose
        default:
            return 0
        }
    }
    
    private func valueFloat(criteria: Criteria, node: LabeledNode) -> Float {
        switch criteria {
        case .change1:
            return node.change1
        case .change2:
            return node.change2
        case .change3:
            return node.change3
        case .change4:
            return node.change4
        case .change5:
            return node.change5
        default:
            return 0.0
        }
    }
    
    func train(nodes: [LabeledNode]) {
        
        guard nodes.count > 0 else { return }
        
        
        let intSplitter = BestSplitterInt<LabeledNode>()
        
        for node in nodes {
            intSplitter.add(value: node.streakUp, outcome: outcome(node: node))
        }
        
        if let split = intSplitter.solve(comparisons: [.greaterThan, .lessThan]) {
            print("Best Split: \(split.value), \(split.comparison)")
        }
        
        /*
        // For testing purpose... we will evaluate the best possible split just for "change1 > x"
        var minVal = nodes[0].change1
        var maxVal = nodes[0].change1
        for node in nodes {
            minVal = min(minVal, node.change1)
            maxVal = max(maxVal, node.change1)
        }
        
        print("searching in range [\(minVal) to \(maxVal)]")
        
        var bestAccurateClassificationCount = 0
        var bestSplit = Float(0.0)
        var bestPercent = Float(0.0)
        
        var steps = 100
        for iteration in 0..<steps {
            let percent = Float(iteration) / Float(steps - 1)
            let split = minVal + (maxVal - minVal) * percent
            print("split[\(iteration)] on \(split)")
            
            var segmentLeft = [LabeledNode]()
            var segmentRight = [LabeledNode]()
            
            for node in nodes {
                if node.change1 > split {
                    segmentRight.append(node)
                } else {
                    segmentLeft.append(node)
                }
            }
            
            var numberClassifiedCorrectly = 0
            for node in segmentLeft {
                if !outcome(node: node) {
                    numberClassifiedCorrectly += 1
                }
            }
            for node in segmentRight {
                if outcome(node: node) {
                    numberClassifiedCorrectly += 1
                }
            }
            print("numberClassifiedCorrectly = \(numberClassifiedCorrectly)")
            if numberClassifiedCorrectly > bestAccurateClassificationCount {
                bestAccurateClassificationCount = numberClassifiedCorrectly
                bestSplit = split
                
                bestPercent = Float(numberClassifiedCorrectly) / Float(nodes.count)
            }
        }
        print("Best Split: \(bestSplit)")
        print("Best Count: \(bestAccurateClassificationCount)")
        print("Best Percent: \(bestPercent)")
        */
    }
    
    func outcome(node: LabeledNode) -> Bool {
        node.change > 0
    }
    
    
}
