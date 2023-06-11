//
//  DataSplitter.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/3/23.
//

import Foundation

class DataSplitter<Type: Comparable & Hashable & Defaultable> {
    
    struct Split {
        let value: Type
        let comparison: Comparison
        
        let truePositives: Int
        let falsePositives: Int
        let trueNegatives: Int
        let falseNegatives: Int
        let quality: Float
    }
    
    struct Node {
        let value: Type
        let outcome: Bool
    }
    
    struct Bucket {
        var nodes = [Node]()
        let value: Type
        var numberOutcomesTrue = 0
        var numberOutcomesFalse = 0
    }
    
    var bucketDict = [Type: Bucket]()
    
    func add(value: Type, outcome: Bool) {
        let node = Node(value: value,
                        outcome: outcome)
        bucketDict[value, default: Bucket(value: value)].nodes.append(node)
    }
    
    func solve(comparisons: [Comparison]) -> Split? {
        
        var bestValue = Type.defaultValue
        var bestQuality = Float(-100_000_000_000_000_000_000_000_000_000_000_000_000.0)
        var bestComparison = Comparison.equal
        
        var bestCountTruePositives = 0
        var bestCountFalsePositives = 0
        var bestCountTrueNegatives = 0
        var bestCountFalseNegatives = 0
        
        
        var buckets = [Bucket]()
        for bucket in bucketDict.values {
            buckets.append(bucket)
        }
        
        guard buckets.count > 1 && comparisons.count > 0 else {
            return nil
        }
        
        buckets.sort {
            $0.value < $1.value
        }
        
        let numberList = buckets.map { $0.value }
        
        var totalOutcomesTrue = 0
        var totalOutcomesFalse = 0
        
        for index in buckets.indices {
            buckets[index].numberOutcomesTrue = 0
            buckets[index].numberOutcomesFalse = 0
            for node in buckets[index].nodes {
                if node.outcome {
                    buckets[index].numberOutcomesTrue += 1
                } else {
                    buckets[index].numberOutcomesFalse += 1
                }
            }
            totalOutcomesTrue += buckets[index].numberOutcomesTrue
            totalOutcomesFalse += buckets[index].numberOutcomesFalse
        }
        
        for comparison in comparisons {
            
            switch comparison {
            case .lessThan:
                var countTruePositives = 0
                var countFalsePositives = 0
                var countTrueNegatives = totalOutcomesFalse
                var countFalseNegatives = totalOutcomesTrue
                
                var index = 1
                while index < numberList.count {
                    let number = numberList[index]
                    
                    
                    countTruePositives += buckets[index - 1].numberOutcomesTrue
                    countFalsePositives += buckets[index - 1].numberOutcomesFalse
                    
                    countFalseNegatives -= buckets[index - 1].numberOutcomesTrue
                    countTrueNegatives -= buckets[index - 1].numberOutcomesFalse
                    
                    
                    let _quality = quality(truePositives: countTruePositives,
                                           trueNegatives: countTrueNegatives,
                                           falsePositives: countFalsePositives,
                                           falseNegatives: countFalseNegatives)
                    if _quality > bestQuality {
                        bestQuality = _quality
                        bestComparison = .lessThan
                        bestValue = number
                        bestCountTruePositives = countTruePositives
                        bestCountTrueNegatives = countTrueNegatives
                        bestCountFalsePositives = countFalsePositives
                        bestCountFalseNegatives = countFalseNegatives
                    }
                    
                    index += 1
                }
                
                break
            case .lessThanEqual:
                
                // Right now, every data point is classified as "false" outcome...
                // So, we start out with these numbers
                
                var countTruePositives = 0
                var countFalsePositives = 0
                var countTrueNegatives = totalOutcomesFalse
                var countFalseNegatives = totalOutcomesTrue
                
                var index = 0
                while index < numberList.count {
                    let number = numberList[index]
                    
                    countTruePositives += buckets[index].numberOutcomesTrue
                    countFalsePositives += buckets[index].numberOutcomesFalse
                    
                    countFalseNegatives -= buckets[index].numberOutcomesTrue
                    countTrueNegatives -= buckets[index].numberOutcomesFalse

                    let _quality = quality(truePositives: countTruePositives,
                                           trueNegatives: countTrueNegatives,
                                           falsePositives: countFalsePositives,
                                           falseNegatives: countFalseNegatives)
                    if _quality > bestQuality {
                        bestQuality = _quality
                        bestComparison = .lessThanEqual
                        bestValue = number
                        bestCountTruePositives = countTruePositives
                        bestCountTrueNegatives = countTrueNegatives
                        bestCountFalsePositives = countFalsePositives
                        bestCountFalseNegatives = countFalseNegatives
                    }
                    
                    index += 1
                }
                
            case .equal:
                var index = 0
                while index < numberList.count {
                    let number = numberList[index]
                    
                    var countTruePositives = 0
                    var countFalsePositives = 0
                    var countTrueNegatives = totalOutcomesFalse
                    var countFalseNegatives = totalOutcomesTrue
                    
                    countTruePositives += buckets[index].numberOutcomesTrue
                    countFalsePositives += buckets[index].numberOutcomesFalse
                    
                    countFalseNegatives -= buckets[index].numberOutcomesTrue
                    countTrueNegatives -= buckets[index].numberOutcomesFalse
                    
                    let _quality = quality(truePositives: countTruePositives,
                                           trueNegatives: countTrueNegatives,
                                           falsePositives: countFalsePositives,
                                           falseNegatives: countFalseNegatives)
                    if _quality > bestQuality {
                        bestQuality = _quality
                        bestComparison = .equal
                        bestValue = number
                        bestCountTruePositives = countTruePositives
                        bestCountTrueNegatives = countTrueNegatives
                        bestCountFalsePositives = countFalsePositives
                        bestCountFalseNegatives = countFalseNegatives
                    }
                    
                    index += 1
                }
                
                
            case .greaterThanEqual:
                
                var countTruePositives = 0
                var countFalsePositives = 0
                var countTrueNegatives = totalOutcomesFalse
                var countFalseNegatives = totalOutcomesTrue
                
                var index = numberList.count - 1
                while index >= 0 {
                    let number = numberList[index]

                    countTruePositives += buckets[index].numberOutcomesTrue
                    countFalsePositives += buckets[index].numberOutcomesFalse
                    
                    countFalseNegatives -= buckets[index].numberOutcomesTrue
                    countTrueNegatives -= buckets[index].numberOutcomesFalse
                    
                    let _quality = quality(truePositives: countTruePositives,
                                           trueNegatives: countTrueNegatives,
                                           falsePositives: countFalsePositives,
                                           falseNegatives: countFalseNegatives)
                    if _quality > bestQuality {
                        bestQuality = _quality
                        bestComparison = .greaterThanEqual
                        bestValue = number
                        bestCountTruePositives = countTruePositives
                        bestCountTrueNegatives = countTrueNegatives
                        bestCountFalsePositives = countFalsePositives
                        bestCountFalseNegatives = countFalseNegatives
                    }
                    
                    index -= 1
                }
                
            case .greaterThan:
                
                var countTruePositives = 0
                var countFalsePositives = 0
                var countTrueNegatives = totalOutcomesFalse
                var countFalseNegatives = totalOutcomesTrue
                
                var index = numberList.count - 2
                while index >= 0 {
                    let number = numberList[index]

                    countTruePositives += buckets[index + 1].numberOutcomesTrue
                    countFalsePositives += buckets[index + 1].numberOutcomesFalse
                    
                    countFalseNegatives -= buckets[index + 1].numberOutcomesTrue
                    countTrueNegatives -= buckets[index + 1].numberOutcomesFalse
                    
                    
                    let _quality = quality(truePositives: countTruePositives,
                                     trueNegatives: countTrueNegatives,
                                     falsePositives: countFalsePositives,
                                     falseNegatives: countFalseNegatives)
                    if _quality > bestQuality {
                        bestQuality = _quality
                        bestComparison = .greaterThan
                        bestValue = number
                        bestCountTruePositives = countTruePositives
                        bestCountTrueNegatives = countTrueNegatives
                        bestCountFalsePositives = countFalsePositives
                        bestCountFalseNegatives = countFalseNegatives
                    }
                    
                    index -= 1
                }
            }
        }
        
        return Split(value: bestValue,
                     comparison: bestComparison,
                     truePositives: bestCountTruePositives,
                     falsePositives: bestCountFalsePositives,
                     trueNegatives: bestCountTrueNegatives,
                     falseNegatives: bestCountFalseNegatives,
                     quality: bestQuality)
        
    }
    
}
