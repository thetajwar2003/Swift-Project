//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tajwar Rahman on 12/25/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

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
    @State private var correctAns = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
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
                    }
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
        }
        else{
            scoreTitle = "Incorrect"
            message = "Wrong! That's the flag of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    func askQuestion(){
        countries.shuffle()
        correctAns = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
