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
        
        var nodes = [Node]()
        for index in buckets.indices {
            for node in buckets[index].nodes {
                nodes.append(node)
            }
        }
        nodes.shuffle()
        
        
        //print(buckets)
        
        for comparison in comparisons {
            
            //numberList
            
            //var remainingOutcomesTrue = totalOutcomesTrue
            //var remainingOutcomesFalse = totalOutcomesFalse
            
            switch comparison {
            case .lessThan:
                
                // Right now, every data point is classified as "false" outcome...
                // So, we start out with these numbers
                
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
                    
                    
                    let sum = countTruePositives + countFalsePositives + countTrueNegatives + countFalseNegatives

                    print("LT with \(number) split:")
                    print("R countTruePositives = \(countTruePositives)")
                    print("R countFalsePositives = \(countFalsePositives)")
                    print("R countFalseNegatives = \(countTrueNegatives)")
                    print("R countTrueNegatives = \(countFalseNegatives)")
                    print("sum = \(sum)")
                    
                    
                    
                    var truePositives = [Node]()
                    var falsePositives = [Node]()
                    var trueNegatives = [Node]()
                    var falseNegatives = [Node]()
                    
                    for node in nodes {
                        if node.value < number {
                            if node.outcome {
                                truePositives.append(node)
                            } else {
                                falsePositives.append(node)
                            }
                        } else {
                            if node.outcome {
                                falseNegatives.append(node)
                            } else {
                                trueNegatives.append(node)
                            }
                        }
                    }
                    
                    print("M truePositives = \(truePositives.count)")
                    print("M falsePositives = \(falsePositives.count)")
                    print("M trueNegatives = \(trueNegatives.count)")
                    print("M falseNegatives = \(falseNegatives.count)")
                    
                    
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
                    
                    let sum = countTruePositives + countFalsePositives + countTrueNegatives + countFalseNegatives

                    print("GT with \(number) split:")
                    print("R countTruePositives = \(countTruePositives)")
                    print("R countFalsePositives = \(countFalsePositives)")
                    print("R countFalseNegatives = \(countTrueNegatives)")
                    print("R countTrueNegatives = \(countFalseNegatives)")
                    print("sum = \(sum)")
                    
                    
                    
                    var truePositives = [Node]()
                    var falsePositives = [Node]()
                    var trueNegatives = [Node]()
                    var falseNegatives = [Node]()
                    
                    for node in nodes {
                        if node.value > number {
                            if node.outcome {
                                truePositives.append(node)
                            } else {
                                falsePositives.append(node)
                            }
                        } else {
                            if node.outcome {
                                falseNegatives.append(node)
                            } else {
                                trueNegatives.append(node)
                            }
                        }
                    }
                    
                    print("M truePositives = \(truePositives.count)")
                    print("M falsePositives = \(falsePositives.count)")
                    print("M trueNegatives = \(trueNegatives.count)")
                    print("M falseNegatives = \(falseNegatives.count)")
                    
                    
                    print("=== GT")
                    
                    index -= 1
                }
            }
        }
        
        
        return Split(value: bestValue,
                     comparison: bestComparison)
    }
    
    
}
