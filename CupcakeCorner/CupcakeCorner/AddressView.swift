//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by vracto on 6/19/25.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    @Binding var path: [String]
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.shipping.name)
                TextField("Address", text: $order.shipping.address)
                TextField("City", text: $order.shipping.city)
                TextField("Zip", text: $order.shipping.zip)
            }
            
            Section {
                NavigationLink("Checkout", value: "checkout")
                    .disabled(!order.hasValidAddress)
            }
        }
        .navigationTitle("Address Details")
    }
}

#Preview {
    @Previewable @State var path = [String]()
    
    AddressView(order: Order(), path: $path)
}
