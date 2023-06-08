//
//  ViewModel.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

actor ViewModel: ObservableObject {
    
    private(set) var stockDataLabeled = StockDataLabeled()
    private var decisionTree = StockDecisionTree()
    
    init() {
        stockDataLabeled.load()
        
        print("loaded: \(stockDataLabeled.nodes.count) nodes...")
        
        var nodes = stockDataLabeled.nodes.shuffled()
        
        var training = [LabeledNode]()
        var testing = [LabeledNode]()
        
        var index = 0
        while index < nodes.count {
            for _ in 0..<10 {
                if index < nodes.count {
                    training.append(nodes[index])
                    index += 1
                }
            }
            for _ in 0..<10 {
                if index < nodes.count {
                    testing.append(nodes[index])
                    index += 1
                }
            }
        }
        
        print("\(training.count) training nodes \(testing.count) testing nodes")
        
        decisionTree.train(nodes: training)
        decisionTree.test(nodes: training)
        
        
    }
    
    
    
}
