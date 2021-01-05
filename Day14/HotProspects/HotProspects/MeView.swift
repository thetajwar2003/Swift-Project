//
//  MeView.swift
//  HotProspects
//
//  Created by Tajwar Rahman on 1/4/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var email = "you@yourside.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                TextField("Email", text:$email)
                    .textContentType(.emailAddress)
                    .font(.title)
                    .padding([.horizontal, .bottom])
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(email)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                
            }
            .navigationBarTitle("Your QRCode")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
