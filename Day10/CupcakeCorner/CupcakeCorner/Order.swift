//
//  Order.swift
//  CupcakeCorner
//
//  Created by Tajwar Rahman on 12/31/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import Foundation

// this class is now much smaller by wrapping a struct with all the information in an ObservableObject
class Order: ObservableObject {
    @Published var orderInfo: OrderInfo
    enum CodingKeys: CodingKey {
        case orderInfo
    }
    
    init() {
        self.orderInfo = OrderInfo()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderInfo, forKey: .orderInfo)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        orderInfo = try container.decode(OrderInfo.self, forKey: .orderInfo)
    }
    
    

}
 
// simple struct that contains all the info about the order
struct OrderInfo: Codable {
    static let types = ["Vanilla", "Chocolate", "Coffee", "Red Velvet", "Rainbow"]
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name  = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
}
