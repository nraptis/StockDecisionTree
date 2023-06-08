//
//  Gini.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/7/23.
//

import Foundation

func gini(truePositives: Int, trueNegatives: Int, falsePositives: Int, falseNegatives: Int) -> Float {
    
    let count = truePositives + falsePositives + trueNegatives + falseNegatives
    guard count > 0 else {
        fatalError("cannot compute gini coefficient with no classifications")
    }
    
    let p = Float(truePositives + falsePositives) / Float(count)
    let q = Float(trueNegatives + falseNegatives) / Float(count)
    
    return 1.0 - (p * p + q * q)
}
