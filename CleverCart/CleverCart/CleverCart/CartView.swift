//
//  CartView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CartView: View {
    @Binding var screen: Int
    @State private var cart: Cart
    @ObservedObject var handler = UserHandler()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cart.cart, id: \.self) { item in
                    Text(item.name)
                    Text(item.quantity)
                }.onDelete(onAppear(perform: deleteItem))
            }
        }
    }
    func deleteItem(at offsets: IndexSet) {
        cart.cart.remove(atOffsets: offsets)
    }
}

//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartView()
//    }
//}
