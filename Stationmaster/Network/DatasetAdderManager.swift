//
//  DatasetAdder.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 06/07/2022.
//

import Foundation

class DatasetAdderManager: LoggableManager {
    
    override init() {
        super.init()
    }
    
    func addDataset(completion: (() -> ())? = nil) {
        let types = DatasetType.allCases
        
        types.forEach { type in
            switch type {
            case .trips:
                parseFileNamesAndUpdate([Trips].self, fileName: type.rawValue)
            case .transfer:
                parseFileNamesAndUpdate([Transfers].self, fileName: type.rawValue)
            case .stops:
                parseFileNamesAndUpdate([Stops].self, fileName: type.rawValue)
            case .stopstimes:
                parseFileNamesAndUpdate([Stoptimes].self, fileName: type.rawValue)
            case .shapes:
                parseFileNamesAndUpdate([Shapes].self, fileName: type.rawValue)
            case .routes:
                parseFileNamesAndUpdate([Routes].self, fileName: type.rawValue)
            case .feedinfo:
                parseFileNamesAndUpdate([Feedinfo].self, fileName: type.rawValue)
            case .calendar:
                parseFileNamesAndUpdate([Calendar].self, fileName: type.rawValue)
            case .calendardates:
                parseFileNamesAndUpdate([Calendardates].self, fileName: type.rawValue)
            case .attributions:
                parseFileNamesAndUpdate([Attributions].self, fileName: type.rawValue)
            case .agency:
                parseFileNamesAndUpdate([Agency].self, fileName: type.rawValue)
            }
        }
        
        persistenceController.saveContext()
        completion?()
    }
    
}

extension DatasetAdderManager {
    
    private func parseFileNamesAndUpdate<T: Decodable >(_ type: T.Type, fileName: String) {
        guard let data = readDataFromCSV(fileName: fileName, fileType: "txt") else { return }
        let cleaned = cleanRows(file: data)
        let csvRows = csv(data: cleaned)
        
        guard let titles = csvRows.first else { return }
        let remainingRows = csvRows.dropFirst()
        
        let dictionary = remainingRows.map { rowData in
            return Dictionary(uniqueKeysWithValues: zip(titles, rowData))
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else { return }
        
        let decoder = JSONDecoder()
        let _ = try? decoder.decode(T.self, from: data)
    }
    
    private func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return nil }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            logger.info("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}


enum DatasetType: String, CaseIterable {
    case trips = "trips"
    case transfer = "transfers"
    case stops = "stops"
    case stopstimes = "stop_times"
    case shapes = "shapes"
    case routes = "routes"
    case feedinfo = "feed_info"
    case calendar = "calendar"
    case calendardates = "calendar_dates"
    case attributions = "attributions"
    case agency = "agency"
}
