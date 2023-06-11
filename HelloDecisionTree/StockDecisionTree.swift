//
//  StockDecisionTree.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

enum Comparison: CaseIterable {
    case lessThan
    case lessThanEqual
    case equal
    case greaterThanEqual
    case greaterThan
}

class StockDecisionTree {
    
    enum ValueType {
        case float(value: Float)
        case int(value: Int)
        case bool(value: Bool)
    }
    
    class DecisionNode {
        let value: ValueType
        let criteria: Criteria
        let comparison: Comparison
        var left: DecisionNode?
        var right: DecisionNode?
        init(value: ValueType, criteria: Criteria, comparison: Comparison) {
            self.value = value
            self.criteria = criteria
            self.comparison = comparison
        }
    }
    
    var root: DecisionNode?
    
    enum CriteriaType {
        case float
        case int
        case bool
        var comparisons: [Comparison] {
            switch self {
            case .float:
                return Comparison.allCases
            case .int:
                return Comparison.allCases
            case .bool:
                return [.equal]
            }
        }
    }
    
    enum Criteria: CaseIterable {
        case streakUp
        case streakDown
        
        case change1
        case change2
        case change3
        case change4
        case change5
        
        case previousCloseWasUp
        case daysSincePreviousClose
        
        var type: CriteriaType {
            switch self {
            case .streakUp:
                return .int
            case .streakDown:
                return .int
            case .change1:
                return .float
            case .change2:
                return .float
            case .change3:
                return .float
            case .change4:
                return .float
            case .change5:
                return .float
            case .previousCloseWasUp:
                return .bool
            case .daysSincePreviousClose:
                return .int
            }
        }
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
    
    func printNode(decisionNode: DecisionNode, depth: Int) {
        var tab = ""
        for _ in 0..<depth {
            tab += "\t"
        }
        
        var _value = ""
        switch decisionNode.value {
            
        case .float(value: let value):
            _value = "Float(\(value))"
        case .int(value: let value):
            _value = "Int(\(value))"
        case .bool(value: let value):
            _value = "Bool(\(value))"
        }
        
        var _comparison = ""
        switch decisionNode.comparison {
            
        case .lessThan:
            _comparison = "<"
        case .lessThanEqual:
            _comparison = "<="
        case .equal:
            _comparison = "=="
        case .greaterThanEqual:
            _comparison = ">="
        case .greaterThan:
            _comparison = ">"
        }
        
        print("\(tab)criteria: \(decisionNode.criteria) \(_comparison) \(_value)")
    }
    
    func printTree() {
        
        print("Decision Tree:")
        guard let root = root else {
            print("{Empty}")
            return
        }
        
        var queue = [root]
        var depth = 0
        while queue.count > 0 {
            var next = [DecisionNode]()
            for decisionNode in queue {
                if let left = decisionNode.left {
                    next.append(left)
                }
                if let right = decisionNode.right {
                    next.append(right)
                }
                printNode(decisionNode: decisionNode, depth: depth)
            }
            depth += 1
            queue = next
            
        }
        
        
    }
    
    func train(nodes: [LabeledNode]) {
        
        guard nodes.count > 0 else { return }
        
        let maxDepth = 4
        
        root = bestSplit(nodes: nodes)
        if let root = root {
            build(decisionNode: root,
                  nodes: nodes,
                  depth: 1,
                  maxDepth: maxDepth)
        }
    }
    
    func build(decisionNode: DecisionNode, nodes: [LabeledNode], depth: Int, maxDepth: Int) {
        
        if depth >= maxDepth { return }
        
        var nodesTrue = [LabeledNode]()
        var nodesFalse = [LabeledNode]()
        
        for node in nodes {
            if evaluate(decisionNode: decisionNode, node: node) {
                nodesTrue.append(node)
            } else {
                nodesFalse.append(node)
            }
        }
        
        if let split = bestSplit(nodes: nodesTrue) {
            decisionNode.right = split
            build(decisionNode: split,
                  nodes: nodesTrue,
                  depth: depth + 1,
                  maxDepth: maxDepth)
        } else {
            //print("True \(decisionNode) depth: \(depth), terminate")
        }
        
        if let split = bestSplit(nodes: nodesFalse) {
            decisionNode.left = split
            build(decisionNode: split,
                  nodes: nodesFalse,
                  depth: depth + 1,
                  maxDepth: maxDepth)
        } else {
            //print("False \(decisionNode) depth: \(depth), terminate")
        }
        
        
    }
    
    func evaluate(node: LabeledNode) -> Bool {
        
        guard var decisionNode = root else { return false }
        
        while true {
            
            let testResult = evaluate(decisionNode: decisionNode, node: node)
            if testResult {
                if let right = decisionNode.right {
                    decisionNode = right
                } else {
                    return true
                }
            } else {
                if let left = decisionNode.left {
                    decisionNode = left
                } else {
                    return false
                }
            }
        }
    }
    
    func evaluate(decisionNode: DecisionNode, node: LabeledNode) -> Bool {
        switch decisionNode.value {
        case .bool(let value):
            switch decisionNode.comparison {
            case .lessThan:
                if valueBool(criteria: decisionNode.criteria, node: node) < value {
                    return true
                } else {
                    return false
                }
            case .lessThanEqual:
                if valueBool(criteria: decisionNode.criteria, node: node) <= value {
                    return true
                } else {
                    return false
                }
                
            case .equal:
                if valueBool(criteria: decisionNode.criteria, node: node) == value {
                    return true
                } else {
                    return false
                }
            case .greaterThanEqual:
                if valueBool(criteria: decisionNode.criteria, node: node) >= value {
                    return true
                } else {
                    return false
                }
            case .greaterThan:
                if valueBool(criteria: decisionNode.criteria, node: node) > value {
                    return true
                } else {
                    return false
                }
            }
        case .float(value: let value):
            switch decisionNode.comparison {
            case .lessThan:
                if valueFloat(criteria: decisionNode.criteria, node: node) < value {
                    return true
                } else {
                    return false
                }
            case .lessThanEqual:
                if valueFloat(criteria: decisionNode.criteria, node: node) <= value {
                    return true
                } else {
                    return false
                }
                
            case .equal:
                if valueFloat(criteria: decisionNode.criteria, node: node) == value {
                    return true
                } else {
                    return false
                }
            case .greaterThanEqual:
                if valueFloat(criteria: decisionNode.criteria, node: node) >= value {
                    return true
                } else {
                    return false
                }
            case .greaterThan:
                if valueFloat(criteria: decisionNode.criteria, node: node) > value {
                    return true
                } else {
                    return false
                }
            }
        case .int(value: let value):
            switch decisionNode.comparison {
            case .lessThan:
                if valueInt(criteria: decisionNode.criteria, node: node) < value {
                    return true
                } else {
                    return false
                }
            case .lessThanEqual:
                if valueInt(criteria: decisionNode.criteria, node: node) <= value {
                    return true
                } else {
                    return false
                }
                
            case .equal:
                if valueInt(criteria: decisionNode.criteria, node: node) == value {
                    return true
                } else {
                    return false
                }
            case .greaterThanEqual:
                if valueInt(criteria: decisionNode.criteria, node: node) >= value {
                    return true
                } else {
                    return false
                }
            case .greaterThan:
                if valueInt(criteria: decisionNode.criteria, node: node) > value {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    func executeSplit(decisionNode: DecisionNode, nodes: [LabeledNode]) -> (left: [LabeledNode], right: [LabeledNode]) {
        
        var left = [LabeledNode]()
        var right = [LabeledNode]()
        
        switch decisionNode.value {
        case .bool(let value):
            switch decisionNode.comparison {
            case .lessThan:
                for node in nodes {
                    if valueBool(criteria: decisionNode.criteria, node: node) < value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .lessThanEqual:
                for node in nodes {
                    if valueBool(criteria: decisionNode.criteria, node: node) <= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .equal:
                for node in nodes {
                    if valueBool(criteria: decisionNode.criteria, node: node) == value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThanEqual:
                for node in nodes {
                    if valueBool(criteria: decisionNode.criteria, node: node) >= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThan:
                for node in nodes {
                    if valueBool(criteria: decisionNode.criteria, node: node) > value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            }
        case .float(value: let value):
            switch decisionNode.comparison {
            case .lessThan:
                for node in nodes {
                    if valueFloat(criteria: decisionNode.criteria, node: node) < value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .lessThanEqual:
                for node in nodes {
                    if valueFloat(criteria: decisionNode.criteria, node: node) <= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .equal:
                for node in nodes {
                    if valueFloat(criteria: decisionNode.criteria, node: node) == value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThanEqual:
                for node in nodes {
                    if valueFloat(criteria: decisionNode.criteria, node: node) >= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThan:
                for node in nodes {
                    if valueFloat(criteria: decisionNode.criteria, node: node) > value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            }
        case .int(value: let value):
            switch decisionNode.comparison {
            case .lessThan:
                for node in nodes {
                    if valueInt(criteria: decisionNode.criteria, node: node) < value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .lessThanEqual:
                for node in nodes {
                    if valueInt(criteria: decisionNode.criteria, node: node) <= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .equal:
                for node in nodes {
                    if valueInt(criteria: decisionNode.criteria, node: node) == value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThanEqual:
                for node in nodes {
                    if valueInt(criteria: decisionNode.criteria, node: node) >= value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            case .greaterThan:
                for node in nodes {
                    if valueInt(criteria: decisionNode.criteria, node: node) > value {
                        right.append(node)
                    } else {
                        left.append(node)
                    }
                }
            }
        }
        return (left: left, right: right)
    }
    
    func bestSplit(nodes: [LabeledNode]) -> DecisionNode? {
        var result: DecisionNode?
        var bestQuality = Float(0.0)
        
        if nodes.count <= 1 { return nil }
        
        for criteria in Criteria.allCases {
            let type = criteria.type
            switch type {
            case .float:
                let splitter = DataSplitter<Float>()
                for node in nodes {
                    let float = valueFloat(criteria: criteria, node: node)
                    splitter.add(value: float, outcome: outcome(node: node))
                }
                if let split = splitter.solve(comparisons: type.comparisons) {
                    
                    if split.quality > bestQuality {
                        bestQuality = split.quality
                        result = DecisionNode(value: .float(value: split.value),
                                             criteria: criteria,
                                             comparison: split.comparison)
                    }
                    //print("Split Result [Float]: \(split.value), \(split.comparison)")
                    //print("(True +): \(split.truePositives), (True -): \(split.trueNegatives)")
                    //print("(False +): \(split.falsePositives), (False -): \(split.falseNegatives)")
                    //print("Quality: \(split.quality)")
                }
            case .int:
                let splitter = DataSplitter<Int>()
                for node in nodes {
                    let int = valueInt(criteria: criteria, node: node)
                    splitter.add(value: int, outcome: outcome(node: node))
                }
                if let split = splitter.solve(comparisons: type.comparisons) {
                    
                    if split.quality > bestQuality {
                        bestQuality = split.quality
                        result = DecisionNode(value: .int(value: split.value),
                                             criteria: criteria,
                                             comparison: split.comparison)
                    }
                    //print("Split Result [Int]: \(split.value), \(split.comparison)")
                    //print("(True +): \(split.truePositives), (True -): \(split.trueNegatives)")
                    //print("(False +): \(split.falsePositives), (False -): \(split.falseNegatives)")
                    //print("Quality: \(split.quality)")
                }
            case .bool:
                let splitter = DataSplitter<Bool>()
                for node in nodes {
                    let bool = valueBool(criteria: criteria, node: node)
                    splitter.add(value: bool, outcome: outcome(node: node))
                }
                if let split = splitter.solve(comparisons: type.comparisons) {
                    if split.quality > bestQuality {
                        bestQuality = split.quality
                        result = DecisionNode(value: .bool(value: split.value),
                                      criteria: criteria,
                                      comparison: split.comparison)
                    }
                    //print("Split Result [Bool]: \(split.value), \(split.comparison)")
                    //print("(True +): \(split.truePositives), (True -): \(split.trueNegatives)")
                    //print("(False +): \(split.falsePositives), (False -): \(split.falseNegatives)")
                    //print("Quality: \(split.quality)")
                }
            }
        }
        return result
    }
    
    /*
    struct LevelResult {
        let value: ValueType
        let criteria: Criteria
        let comparison: Comparison
    }
    */
    
    
    func outcome(node: LabeledNode) -> Bool {
        node.change > 0
    }
    
    
    func test(nodes: [LabeledNode]) {
        print("testing \(nodes.count) nodes")
        
        var numberCorrect = 0
        var numberWong = 0
        for node in nodes {
            
            let outcomeResult = outcome(node: node)
            let testResult = evaluate(node: node)
            
            if outcomeResult == testResult {
                numberCorrect += 1
            } else {
                numberWong += 1
            }
        }
        
        print("numberCorrect: \(numberCorrect)")
        print("numberWong: \(numberWong)")
        
        
        
    }
    
}
