//
//  StockRandomForest.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/11/23.
//

import Foundation

class StockRandomForest {
    
    private let numberOfTrees = 16
    var trees = [StockDecisionTree]()
    
    func train(nodes: [LabeledNode]) {
        
        guard nodes.count > 0 else { return }
        
        let numberOfTrees = min(numberOfTrees, nodes.count)
        
        trees.removeAll(keepingCapacity: true)
        for _ in 0..<numberOfTrees {
            trees.append(StockDecisionTree())
        }
        
        var _nodes = [[LabeledNode]]()
        for _ in 0..<numberOfTrees {
            _nodes.append([LabeledNode]())
        }
        
        var slot = 0
        for node in nodes {
            _nodes[slot].append(node)
            slot += 1
            if slot == numberOfTrees {
                slot = 0
            }
        }
        
        //print("_nod = \(_nodes)")
        
        for index in 0..<numberOfTrees {
            trees[index].train(nodes: _nodes[index])
            print("tree at \(index) trained with (\(_nodes[index].count))")
            //trees[index].printTree()
        }
        
        
    }
    
    func evaluate(node: LabeledNode) -> Bool {
        
        var votesTrue = 0
        var votesFalse = 0
        
        for tree in trees {
            if tree.evaluate(node: node) {
                votesTrue += 1
            } else {
                votesFalse += 1
            }
        }
        
        return votesTrue >= votesFalse
    }
    
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
