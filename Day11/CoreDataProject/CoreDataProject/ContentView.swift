//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import CoreData
import SwiftUI

enum beginsWith {
    case lastName
    case firstName
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @State var filterValue = "J"
    
    var body: some View {
        VStack {
            FilteredList(sort: NSSortDescriptor(keyPath: \Singer.lastName, ascending: true), predicate: .lastName, filter: filterValue)
            HStack {
            Button("Add Examples") {
                let rm = Singer(context: self.moc)
                rm.firstName = "Kim"
                rm.lastName = "Namjoon"
                
                let jin = Singer(context: self.moc)
                jin.firstName = "Kim"
                jin.lastName = "Seokjin"
                
                let suga = Singer(context: self.moc)
                suga.firstName = "Min"
                suga.lastName = "Yoongi"
                
                let jhope = Singer(context: self.moc)
                jhope.firstName = "Jeon"
                jhope.lastName = "Hoseok"
                
                let jm = Singer(context: self.moc)
                jm.firstName = "Park"
                jm.lastName = "Jimin"
                
                let v = Singer(context: self.moc)
                v.firstName = "Kim"
                v.lastName = "Taehyung"
                
                let jk = Singer(context: self.moc)
                jk.firstName = "Jeon"
                jk.lastName = "Jungkook"
                
                try? self.moc.save()
            }
            
            Button("Show J") {
                self.filterValue = "J"
            }

            Button("Show Y") {
                self.filterValue = "Y"
            }
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
