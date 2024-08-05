//
//  StockData.swift
//  HelloDecisionTree
//
//  Created by Screwy Uncle Louie on 6/2/23.
//

import Foundation

struct StockDataRaw {
    
    struct StockDataRawNode: CustomStringConvertible {
        let date: Date
        let dateYear: Int
        let dateMonth: Int
        let dateDay: Int
        
        let close: Float
        let volume: Int
        
        let open: Float
        let high: Float
        let low: Float
        
        var dateString: String {
            return "y:\(dateYear) m:\(dateMonth) d:\(dateDay)"
        }
        
        var description: String {
            let openString = String(format: "%.2f", open)
            let highString = String(format: "%.2f", high)
            let lowString = String(format: "%.2f", low)
            let closeString = String(format: "%.2f", close)
            return "y:\(dateYear) m:\(dateMonth) d:\(dateDay) (O: \(openString)) (H: \(highString)) (L: \(lowString)) (C: \(closeString))"
        }
    }
    
    var nodes = [StockDataRawNode]()
    
    mutating func load(fileName: String = "nasdaq_historical", fileExtension: String = "csv") {
        clear()
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Error Locating File: \"\(fileName).\(fileExtension)\"")
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            if let dataString = String(data: data, encoding: .utf8) {
                load(dataString: dataString)
            }
        } catch let error {
            print("Error Loading File: \(error.localizedDescription)")
        }
    }
    
    func getInt(string: String) -> Int? {
        let result = string.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        return Int(result)
    }
    
    func getFloat(string: String) -> Float? {
        let result = string.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
        return Float(result)
    }
    
    func splitManually(dataString: String) -> [String] {
        var result = [String]()
        let array = Array(dataString)
        var partial = [Character]()
        
        for character in array {
            if character == "\n" || character == "\r" {
                
            }
            
        }
        
        
        
        return result
    }
    
    mutating private func load(dataString: String) {
        clear()

        let lines = dataString.split(whereSeparator: \.isNewline)
        
        for line in lines {
            
            let lineChunks = line.split(separator: ",")
                .map {
                    $0
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }.filter {
                    $0
                        .count > 0
                }
            guard lineChunks.count >= 5 else { continue }
            
            let dateChunks = lineChunks[0].split(separator: "/")
            guard dateChunks.count > 2 else { continue }
            
            guard let dateMonth = getInt(string: String(dateChunks[0])) else { continue }
            guard let dateDay = getInt(string: String(dateChunks[1])) else { continue }
            guard var dateYear = getInt(string: String(dateChunks[2])) else { continue }
            
            let dateComponents = DateComponents(calendar: .current, year: dateYear, month: dateMonth, day: dateDay)
            guard let date = Calendar.current.date(from: dateComponents) else { continue }
            
            
            guard let close = getFloat(string: lineChunks[1]) else { continue }
            
            guard let volume = getInt(string: lineChunks[2]) else { continue }
            
            guard let open = getFloat(string: lineChunks[3]) else { continue }
            guard let high = getFloat(string: lineChunks[4]) else { continue }
            guard let low = getFloat(string: lineChunks[5]) else { continue }
            
            let node = StockDataRawNode(date: date,
                                        dateYear: dateYear,
                                        dateMonth: dateMonth,
                                        dateDay: dateDay,
                                        close: close,
                                        volume: volume,
                                        open: open,
                                        high: high,
                                        low: low)
            
            nodes.append(node)
        }
        nodes.reverse()
    }
    
    mutating func clear() {
        nodes.removeAll(keepingCapacity: true)
    }
}
