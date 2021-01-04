//
//  ContentView.swift
//  Remember Em
//
//  Created by Tajwar Rahman on 1/3/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Person.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)]) var people: FetchedResults<Person>
    @State private var showAddScreen = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people, id: \.self) { person in
                    NavigationLink(destination: PersonView(imageId: person.imageId!, person: person).environment(\.managedObjectContext, self.moc) ){
                        HStack {
                            self.loadImage(uuid: person.imageId!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 48, height: 48)
                            Text("\(person.name ?? "Unknown Person")")
                        }
                    }
                }
            }
            .navigationBarTitle("Remember Em")
            .navigationBarItems(trailing: Button(action: {
                self.showAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            }).sheet(isPresented: $showAddScreen){
                AddPersonView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    // func to access the doc directory and return first doc
    func getDocumentsDirectory() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       return paths[0]
    }
    
    // retrieves the pic from the directory
    func getPic(withName name: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if let loadedImageData = try? Data(contentsOf: url) {
            return UIImage(data: loadedImageData)
        }
        return nil
    }
    
    // if the uuid's match return the pic else return system image
    func loadImage(uuid: UUID) -> Image{
        if let uiImage = getPic(withName: uuid.uuidString){
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
