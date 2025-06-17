//
//  PathStore.swift
//  Navigation
//
//  Created by Sonit Sahoo on 6/16/25.
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "savePath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        
        path = NavigationPath()
    }
    
    func save() {
        guard path.codable != nil else { return }
        do {
            try JSONEncoder().encode(path.codable).write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
