//
//  Entropy.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/3/23.
//

import Foundation

func entropy(countCorrectlyClassifiedAsTrue: Int, countCorrectlyClassifiedAsFalse: Int, countWronglyClassifiedAsTrue: Int, countWronglyClassifiedAsFalse: Int) -> Float {
    let totalOutcomes = Float(countCorrectlyClassifiedAsTrue + countCorrectlyClassifiedAsFalse + countWronglyClassifiedAsTrue + countWronglyClassifiedAsFalse)
        
    let pCorrectlyClassifiedAsTrue = Float(countCorrectlyClassifiedAsTrue) / totalOutcomes
    let pCorrectlyClassifiedAsFalse = Float(countCorrectlyClassifiedAsFalse) / totalOutcomes
    let pWronglyClassifiedAsTrue = Float(countWronglyClassifiedAsTrue) / totalOutcomes
    let pWronglyClassifiedAsFalse = Float(countWronglyClassifiedAsFalse) / totalOutcomes
    
    var entropyCorrectlyClassifiedAsTrue: Float = 0
    var entropyCorrectlyClassifiedAsFalse: Float = 0
    var entropyWronglyClassifiedAsTrue: Float = 0
    var entropyWronglyClassifiedAsFalse: Float = 0
    
    if pCorrectlyClassifiedAsTrue != 0 {
        entropyCorrectlyClassifiedAsTrue = -pCorrectlyClassifiedAsTrue * log2(pCorrectlyClassifiedAsTrue)
    }
    if pCorrectlyClassifiedAsFalse != 0 {
        entropyCorrectlyClassifiedAsFalse = -pCorrectlyClassifiedAsFalse * log2(pCorrectlyClassifiedAsFalse)
    }
    if pWronglyClassifiedAsTrue != 0 {
        entropyWronglyClassifiedAsTrue = -pWronglyClassifiedAsTrue * log2(pWronglyClassifiedAsTrue)
    }
    if pWronglyClassifiedAsFalse != 0 {
        entropyWronglyClassifiedAsFalse = -pWronglyClassifiedAsFalse * log2(pWronglyClassifiedAsFalse)
    }
    
    let entropy = entropyCorrectlyClassifiedAsTrue + entropyCorrectlyClassifiedAsFalse + entropyWronglyClassifiedAsTrue + entropyWronglyClassifiedAsFalse
    
    return entropy
}
