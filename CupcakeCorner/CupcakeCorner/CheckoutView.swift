//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Sonit Sahoo on 6/19/25.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    @Binding var path: [String]
    
    @State private var showingConf: Bool = false
    @State private var confMsg: String = ""
    @State private var errored: Bool = false
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key") //api endpoint seems to have changed since 100 DoSUI was written
        req.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: req, from: encoded)
            let decoded = try JSONDecoder().decode(Order.self, from: data)
            
            confMsg = "Your order for \(decoded.quantity)x \(Order.types[decoded.type]) cupcakes is on the way."
            errored = false
            showingConf = true
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
            confMsg = "Your order could not be placed."
            errored = true
            showingConf = true
        }
    }
    
    var body: some View {
        //ScrollView {
            ZStack {
                LinearGradient(stops: [
                    .init(color: Color(red: 0.902, green: 0.804, blue: 0.890), location: 0.2),
                    .init(color: .white, location: 0.8),
                ], startPoint: .top, endPoint: .bottom)
                VStack {
                    AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                        .frame(height: 233)
                    
                    Text("Your total order is \(order.cost, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).")
                        .font(.title.weight(.semibold))
                    
                    Button("Place Order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .font(.headline)
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Spacer()
                }
            }
        //}
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        //.scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea()
        .alert(!errored ? "Thank you for your order!" : "Oops!", isPresented: $showingConf) {
            if !errored {
                Button("All Set") {}
            } else {
                Button("Restart Order") {
                    path.removeAll()
                }
            }
        } message: {
            Text(confMsg)
        }
        .onAppear() {
            order.saveShippingDetails()
        }
    }
}

#Preview {
    @Previewable @State var path = [String]()
    
    CheckoutView(order: Order(), path: $path)
}
