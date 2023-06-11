//
//  Entropy.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/3/23.
//

import Foundation

func entropy(truePositives: Int, trueNegatives: Int, falsePositives: Int, falseNegatives: Int) -> Float {
    
    let count = truePositives + falsePositives + trueNegatives + falseNegatives
    guard count > 0 else {
        fatalError("cannot compute entropy with no classifications")
    }
    
    let p = Float(truePositives + falsePositives) / Float(count)
    let q = Float(trueNegatives + falseNegatives) / Float(count)
    
    let entropy = -p * log2(p) - q * log2(q)

    return entropy
}
