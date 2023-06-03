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
            
            var remainingOutcomesTrue = totalOutcomesTrue
            var remainingOutcomesFalse = totalOutcomesFalse
            
            
            
            switch comparison {
            case .lessThan:
                
                var splitOutcomesFalse = totalOutcomesTrue + totalOutcomesFalse
                var splitOutcomesTrue = 0
                
                var index = 1
                while index < numberList.count {
                    let number = numberList[index]
                    
                    remainingOutcomesTrue -= buckets[index - 1].numberOutcomesTrue
                    remainingOutcomesFalse -= buckets[index - 1].numberOutcomesFalse
                    
                    splitOutcomesFalse -= buckets[index - 1].nodes.count
                    splitOutcomesTrue += buckets[index - 1].nodes.count
                    
                    print("with \(number) split, remaining (t: \(totalOutcomesTrue), f: \(totalOutcomesFalse)), split: (t: \(splitOutcomesTrue) f: \(splitOutcomesFalse))")
                    
                    
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
                break
            }
            
            
            
        }
        
        
        return Split(value: bestValue,
                     comparison: bestComparison)
    }
    
    
}
