//
//  ViewModel.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

actor ViewModel: ObservableObject {
    
    private(set) var stockDataLabeled = StockDataLabeled()
    
    init() {
        stockDataLabeled.load()
        
    }
    
    
    
}
