//
//  CartView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach {
                    // item
                }.onDelete(onAppear(perform: deleteItem))
            }
        }
    }
    func deleteItem() {
        //
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
