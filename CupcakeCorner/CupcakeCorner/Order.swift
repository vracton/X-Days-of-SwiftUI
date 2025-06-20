//
//  Order.swift
//  CupcakeCorner
//
//  Created by vracto on 6/18/25.
//

import SwiftUI

struct ShippingDetails: Codable {
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var zip: String = ""
    
//    init(name: String = "", address: String = "", city: String = "", zip: String = "") {
//        self.name = name
//        self.address = address
//        self.city = city
//        self.zip = zip
//    }
    
    var hasValidAddress: Bool {
        !(name.trimmed.isEmpty||address.trimmed.isEmpty||city.trimmed.isEmpty||zip.trimmed.isEmpty)
    }
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialsEnabled = "specialsEnabled"
        case _extraFrosting = "extraFrosting"
        case _extraSprinkles = "extraSprinkles"
//        case _name = "name"
//        case _address = "address"
//        case _city = "city"
//        case _zip = "zip"
        case _shipping = "shipping"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type: Int = 0
    var quantity: Int = 3
    
    var specialsEnabled: Bool = false {
        didSet {
            if !specialsEnabled {
                extraFrosting = false
                extraSprinkles = false
            }
        }
    }
    var extraFrosting: Bool = false
    var extraSprinkles: Bool = false
    
    var cost: Decimal {
        Decimal(quantity) * (2+(extraFrosting ? 1 : 0)+(extraSprinkles ? 0.5 : 0))
    }
    
    var shipping: ShippingDetails = ShippingDetails() {
        didSet {
            //only save when user continues to checkout
            //saveShippingDetails()
        }
    }
    
    var hasValidAddress: Bool {
        shipping.hasValidAddress
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "shipping") {
            if let decoded = try? JSONDecoder().decode(ShippingDetails.self, from: data) {
                shipping = decoded
            }
        }
    }
    
    func saveShippingDetails() {
        if let encoded = try? JSONEncoder().encode(shipping) {
            UserDefaults.standard.set(encoded, forKey: "shipping")
        }
    }
}

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
