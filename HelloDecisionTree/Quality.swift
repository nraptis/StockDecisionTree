//
//  Quality.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/7/23.
//

import Foundation

func quality(truePositives: Int, trueNegatives: Int, falsePositives: Int, falseNegatives: Int) -> Float {
    let count = truePositives + falsePositives + trueNegatives + falseNegatives
    guard count > 0 else {
        fatalError("cannot compute quality with no classifications")
    }
    let correct = truePositives + trueNegatives
    return Float(correct) / Float(count)
}
