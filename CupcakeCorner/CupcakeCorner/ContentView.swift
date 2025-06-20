//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by vracto on 6/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    @State private var path: [String] = [String]()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section {
                    Picker("Select Your Cake Type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text("\(Order.types[$0])")
                        }
                    }
                    
                    Stepper("**\(order.quantity)** Cupcakes", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Special Options", isOn: $order.specialsEnabled)
                    
                    if order.specialsEnabled {
                        Toggle("Extra Sprinkles", isOn: $order.extraSprinkles)
                        Toggle("Extra Frosting", isOn: $order.extraFrosting)
                    }
                }
                
                Section {
                    NavigationLink("Delivery Details", value: "address")
                }
            }
            .navigationTitle("Cupcake Corner")
            .navigationDestination(for: String.self) { dest in
                if dest == "address" {
                    AddressView(order: order, path: $path)
                } else if dest == "checkout" {
                    CheckoutView(order: order, path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
