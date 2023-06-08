//
//  Bool+Comparable.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/7/23.
//

import Foundation

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        return lhs == false && rhs == true
    }
}
