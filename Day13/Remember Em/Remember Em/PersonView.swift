//
//  PersonView.swift
//  Remember Em
//
//  Created by Tajwar Rahman on 1/3/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct PersonView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var imageId: UUID
    @State var person: Person
    @State private var image: Image?
    
    @State var currentUserLocation: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 125, height: 125, alignment: .center)
                self.loadImage(uuid: imageId)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
            }
            
            Text("\(person.name ?? "Unknown Person")")
            
            Group {
                CompactMapView(currentUserLocation: currentUserLocation ?? CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13))
            }
            
        }.navigationBarTitle("Detailed View", displayMode: .inline)
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


