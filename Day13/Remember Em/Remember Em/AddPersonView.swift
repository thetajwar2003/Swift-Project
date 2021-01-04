//
//  AddPersonView.swift
//  Remember Em
//
//  Created by Tajwar Rahman on 1/3/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import CoreData
import SwiftUI
import CoreLocation

struct AddPersonView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingImagePicker = false
    
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var name = ""
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                // first show a gray circle to add a pic
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 120, height: 120, alignment: .center)
                
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120, alignment: .center)
                        .clipShape(Capsule())
                }
                else{
                    Text("Select Image")
                }
            }.onTapGesture {
                self.showingImagePicker.toggle()
            }
            
            TextField("Name:", text: $name)
            
            Button("Save") {
                let person = Person(context: self.moc)
                person.name = self.name
                person.imageId = UUID()
                self.savePic(self.inputImage!, withName: person.imageId!.uuidString)
                
                try? self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle("Add Person", displayMode: .inline)
        // prompt the image picker from gallery sheet to show and store image as input image
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // writes the pic to the directory
   func savePic(_ image: UIImage, withName name: String) {
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
           let url = getDocumentsDirectory().appendingPathComponent(name)
           try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
        }
        else {
            print("Couldn't save")
        }
    }
    
    // converts uiImage is to Image
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}
