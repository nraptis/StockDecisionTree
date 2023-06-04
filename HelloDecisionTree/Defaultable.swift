//
//  Defaultable.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/3/23.
//

import Foundation

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue = false
}

extension Int: Defaultable {
    static var defaultValue = 0
}

extension Int16: Defaultable {
    static var defaultValue: Int16 = 0
}

extension Int32: Defaultable {
    static var defaultValue: Int32 = 0
}

extension Int64: Defaultable {
    static var defaultValue: Int64 = 0
}

extension UInt16: Defaultable {
    static var defaultValue: UInt16 = 0
}

extension UInt32: Defaultable {
    static var defaultValue: UInt32 = 0
}

extension UInt64: Defaultable {
    static var defaultValue: UInt64 = 0
}

extension Float: Defaultable {
    static var defaultValue = Float(0.0)
}

extension CGFloat: Defaultable {
    static var defaultValue = CGFloat(0.0)
}

extension Float16: Defaultable {
    static var defaultValue = Float16(0.0)
}

extension Double: Defaultable {
    static var defaultValue = 0.0
}
