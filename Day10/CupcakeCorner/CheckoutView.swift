//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Tajwar Rahman on 12/31/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var alertTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.orderInfo.cost, specifier: "%.2f")").font(.title)
                    
                    Button("Place the order") {
                        self.placeOrder()
                    }.padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(alertTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        // encodes our order to a json object
        guard let encoded = try? JSONEncoder().encode(order.orderInfo) else {
            print("Failed to encode order")
            return
        }
        
        // send that json object to the link and wait for a message back
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "COntent-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(OrderInfo.self, from: data) {
                self.alertTitle = "Thank you!"
                self.confirmationMessage = "Your order for \(decodedOrder.quantity) \(OrderInfo.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            }
            else {
                self.alertTitle = "Uh oh :("
                self.confirmationMessage = "There seems to be an error with the interwebs"
                self.showingConfirmation = true
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
