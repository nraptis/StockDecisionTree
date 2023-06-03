//
//  BestSplitterInt.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

class BestSplitterInt<Element> {
    
    struct Split {
        let value: Int
        let comparison: Comparison
    }
    
    struct Node {
        let value: Int
        let outcome: Bool
    }
    
    struct Bucket {
        var nodes = [Node]()
        let value: Int
        var numberOutcomesTrue = 0
        var numberOutcomesFalse = 0
    }
    
    var bucketDict = [Int: Bucket]()
    
    func add(value: Int, outcome: Bool) {
        let node = Node(value: value,
                        outcome: outcome)
        bucketDict[value, default: Bucket(value: value)].nodes.append(node)
    }
    
    func solve(comparisons: [Comparison]) -> Split? {
        
        var bestValue = 0
        var bestComparison = Comparison.equal
        
        var buckets = [Bucket]()
        for bucket in bucketDict.values {
            buckets.append(bucket)
        }
        
        guard buckets.count > 1 && comparisons.count > 1 else {
            return nil
        }
        
        buckets.sort {
            $0.value < $1.value
        }
        
        var numberList = [Int]()
        
        for bucket in buckets {
            print("bucket: \(bucket.value), \(bucket.nodes.count) nodes")
            numberList.append(bucket.value)
        }
        
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
        
        //print(buckets)
        
        for comparison in comparisons {
            
            //numberList
            
            //var remainingOutcomesTrue = totalOutcomesTrue
            //var remainingOutcomesFalse = totalOutcomesFalse
            
            switch comparison {
            case .lessThan:
                
                
                // Right now, every data point is classified as "true" outcome...
                // So, we start out with these numbers
                
                var countCorrectlyClassifiedAsTrue = totalOutcomesTrue
                var countCorrectlyClassifiedAsFalse = 0
                var countWronglyClassifiedAsTrue = totalOutcomesFalse
                var countWronglyClassifiedAsFalse = 0
                
                var index = 1
                while index < numberList.count {
                    let number = numberList[index]
                    
                    countCorrectlyClassifiedAsTrue -= buckets[index - 1].numberOutcomesTrue
                    countWronglyClassifiedAsFalse += buckets[index - 1].numberOutcomesTrue
                    
                    countCorrectlyClassifiedAsFalse += buckets[index - 1].numberOutcomesFalse
                    countWronglyClassifiedAsTrue -= buckets[index - 1].numberOutcomesFalse
                    
                    let sum = countCorrectlyClassifiedAsTrue + countWronglyClassifiedAsFalse + countCorrectlyClassifiedAsFalse + countWronglyClassifiedAsTrue
                    
                    let e = entropy(countCorrectlyClassifiedAsTrue: countCorrectlyClassifiedAsTrue,
                                    countCorrectlyClassifiedAsFalse: countCorrectlyClassifiedAsFalse,
                                    countWronglyClassifiedAsTrue: countWronglyClassifiedAsTrue,
                                    countWronglyClassifiedAsFalse: countWronglyClassifiedAsFalse)
                    
                    print("LT with \(number) split:")
                    print("countCorrectlyClassifiedAsTrue = \(countCorrectlyClassifiedAsTrue)")
                    print("countWronglyClassifiedAsFalse = \(countWronglyClassifiedAsFalse)")
                    print("countCorrectlyClassifiedAsFalse = \(countCorrectlyClassifiedAsFalse)")
                    print("countWronglyClassifiedAsTrue = \(countWronglyClassifiedAsTrue)")
                    print("entropy: \(e)")
                    
                    print("sum = \(sum)")
                    print("=== LT")
                    
                    
                    index += 1
                }
                
                break
            case .lessThanEqual:
                break
            case .equal:
                break
            case .greaterThanEqual:
                break
            case .greaterThan:
                
                // Right now, every data point is classified as "false" outcome...
                // So, we start out with these numbers
                
                var countCorrectlyClassifiedAsTrue = 0
                var countCorrectlyClassifiedAsFalse = totalOutcomesFalse
                var countWronglyClassifiedAsTrue = totalOutcomesTrue
                var countWronglyClassifiedAsFalse = 0
                
                print("GT with NIL split:")
                print("countCorrectlyClassifiedAsTrue = \(countCorrectlyClassifiedAsTrue)")
                print("countWronglyClassifiedAsFalse = \(countWronglyClassifiedAsFalse)")
                print("countCorrectlyClassifiedAsFalse = \(countCorrectlyClassifiedAsFalse)")
                print("countWronglyClassifiedAsTrue = \(countWronglyClassifiedAsTrue)")

                print("=== GT")
                
                var index = 1
                while index < numberList.count {
                    let number = numberList[index]
                    
                    //buckets[index - 1].numberOutcomesTrue
                    //buckets[index - 1].numberOutcomesFalse
                    
                    countWronglyClassifiedAsTrue -= buckets[index - 1].numberOutcomesTrue
                    countCorrectlyClassifiedAsFalse -= buckets[index - 1].numberOutcomesFalse
                    
                    
                    countCorrectlyClassifiedAsTrue += buckets[index - 1].numberOutcomesTrue
                    countWronglyClassifiedAsFalse += buckets[index - 1].numberOutcomesFalse
                    
                    let sum = countCorrectlyClassifiedAsTrue + countWronglyClassifiedAsFalse + countCorrectlyClassifiedAsFalse + countWronglyClassifiedAsTrue
                    
                    let e = entropy(countCorrectlyClassifiedAsTrue: countCorrectlyClassifiedAsTrue,
                                    countCorrectlyClassifiedAsFalse: countCorrectlyClassifiedAsFalse,
                                    countWronglyClassifiedAsTrue: countWronglyClassifiedAsTrue,
                                    countWronglyClassifiedAsFalse: countWronglyClassifiedAsFalse)
                    
                    print("GT with \(number) split:")
                    print("countCorrectlyClassifiedAsTrue = \(countCorrectlyClassifiedAsTrue)")
                    print("countWronglyClassifiedAsFalse = \(countWronglyClassifiedAsFalse)")
                    print("countCorrectlyClassifiedAsFalse = \(countCorrectlyClassifiedAsFalse)")
                    print("countWronglyClassifiedAsTrue = \(countWronglyClassifiedAsTrue)")
                    print("entropy: \(e)")
                    
                    print("sum = \(sum)")
                    print("=== GT")
                    
                    
                    index += 1
                }
                
            }
            
            
            
        }
        
        
        return Split(value: bestValue,
                     comparison: bestComparison)
    }
    
    
}
