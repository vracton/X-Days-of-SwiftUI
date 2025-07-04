//
//  Entry.swift
//  Renameber
//
//  Created by vracto on 7/3/25.
//

import Foundation
import SwiftData

@Model
class Entry: Identifiable {
    var id: UUID = UUID()
    @Attribute(.externalStorage) var photo: Data
    var name: String
    var addDate: Date = Date.now
    
    init(photo: Data, name: String) {
        self.photo = photo
        self.name = name
    }
}
