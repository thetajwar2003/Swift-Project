//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct FilteredList: View {
    
    var fetchRequest: FetchRequest<Singer>
    var singers: FetchedResults<Singer> { fetchRequest.wrappedValue }
    
    init(sort: NSSortDescriptor, predicate: beginsWith, filter: String) {
        
        var predicateValue : String {
            switch predicate {
            case .lastName:
                return "lastName"
            case .firstName:
                return "firstName"
            }
        }
        
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [sort], predicate: NSPredicate(format: "%K BEGINSWITH %@", predicateValue, filter))
    }
    
    var body: some View {
        List(singers, id: \.self) { singer in
            Text("\(singer.wrappedLastName) \(singer.wrappedFirstName)")
        }
    }
}
