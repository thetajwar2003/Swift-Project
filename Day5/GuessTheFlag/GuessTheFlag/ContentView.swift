//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tajwar Rahman on 12/25/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// a struct that renders images of each flag
struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var correctAns = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
    @State private var opacityAmount = 1.0
    @State private var rotationAmount = 0.0
    @State private var correct = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAns]).foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                }
                ForEach (0 ..< 3){ number in
                    Button(action: {
                        self.flagTapped(number)
                    }){
                        FlagImage(name: self.countries[number])
                            .opacity(self.correct && number == self.correctAns ? self.opacityAmount : 0.25) // opacity
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    }
                    .rotation3DEffect(.degrees(number == self.correctAns ? self.rotationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                }
                Text("Score: \(score)").foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                Spacer()
            }
        }.alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message:  Text(message), dismissButton: .default(Text("Continue")){
            self.askQuestion()
            })
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAns{
            scoreTitle = "Correct"
            message = "That's correct! Keep it up!"
            score += 1
            correct = true
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                rotationAmount = 360
            }
        }
        else{
            scoreTitle = "Incorrect"
            message = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            rotationAmount = 0
            correct = false
        }
        showingScore = true
    }
    func askQuestion(){
        countries.shuffle()
        correctAns = Int.random(in: 0...2)
        rotationAmount = 0.0
        correct = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
