//
//  ContentView.swift
//  Remember Em
//
//  Created by Tajwar Rahman on 1/3/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import CoreData
import SwiftUI
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Person.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true)]) var people: FetchedResults<Person>
    @State private var showAddScreen = false
    
    let locationFetcher = LocationFetcher()
    @State private var currentLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people, id: \.self) { person in
                    NavigationLink(destination: PersonView(imageId: person.imageId!, person: person, currentUserLocation: self.currentLocation).environment(\.managedObjectContext, self.moc) ){
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
            .onAppear(perform: getLocation) // starts the get location when the screen is loaded
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
    
    func getLocation() {
        self.locationFetcher.start()
        self.currentLocation = self.locationFetcher.lastKnownLocation
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
