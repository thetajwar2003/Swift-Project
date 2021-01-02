//
//  User.swift
//  Buddy
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation

// all the properties of the json
struct User: Codable, Identifiable {
    struct Friends: Codable {
        let id: String
        let name: String
    }
    
    let id: String
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let isActive: Bool
    let registered: String
    let tags: [String]
    let friends: [User.Friends]
}
