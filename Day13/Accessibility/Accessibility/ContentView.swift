//
//  ContentView.swift
//  Accessibility
//
//  Created by Tajwar Rahman on 1/3/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View {
        VStack{
            Image(pictures[selectedPicture])
                .resizable()
                .accessibility(label: Text(labels[selectedPicture]))
                .accessibility(addTraits: .isButton)
                .scaledToFit()
                .onTapGesture {
                    self.selectedPicture = Int.random(in: 0...3)
                }
            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            .accessibilityElement(children: .combine)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
