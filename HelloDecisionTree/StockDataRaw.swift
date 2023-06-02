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
        let open: Float
        let high: Float
        let low: Float
        let close: Float
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
    
    mutating private func load(dataString: String) {
        clear()

        let linesNL = dataString.split(separator: "\n")
            .map {
                $0
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter {
                $0
                    .count > 0
            }
        
        var lines = [String]()
        for line in linesNL {
            let linesCR = line.split(separator: "\r")
                .map {
                    $0
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }.filter {
                    $0
                        .count > 0
                }
            for innerLine in linesCR {
                lines.append(innerLine)
            }
        }
        
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
            
            guard let dateMonth = Int(dateChunks[0]) else { continue }
            guard let dateDay = Int(dateChunks[1]) else { continue }
            guard var dateYear = Int(dateChunks[2]) else { continue }
            dateYear += 2000
            
            let dateComponents = DateComponents(calendar: .current, year: dateYear, month: dateMonth, day: dateDay)
            guard let date = Calendar.current.date(from: dateComponents) else { continue }
            
            guard let open = Float(lineChunks[1]) else { continue }
            guard let high = Float(lineChunks[2]) else { continue }
            guard let low = Float(lineChunks[3]) else { continue }
            guard let close = Float(lineChunks[4]) else { continue }

            let node = StockDataRawNode(date: date,
                                        dateYear: dateYear,
                                        dateMonth: dateMonth,
                                        dateDay: dateDay,
                                        open: open,
                                        high: high,
                                        low: low,
                                        close: close)
            nodes.append(node)
        }
        nodes.reverse()
    }
    
    mutating func clear() {
        nodes.removeAll(keepingCapacity: true)
    }
}
