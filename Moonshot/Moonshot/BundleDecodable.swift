//
//  BundleDecodable.swift
//  Moonshot
//
//  Created by vracto on 6/14/25.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to read \(file)")
        }
        
        //https://arc.net/l/quote/pyumefqt for better error management
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file)")
        }
        
        return decodedData
    }
}
