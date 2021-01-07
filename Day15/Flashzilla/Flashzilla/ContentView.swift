//
//  ContentView.swift
//  Flashzilla
//
//  Created by Tajwar Rahman on 1/5/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI
import CoreHaptics

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset*10))
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            // decorative hides the other cards from voice over
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) {
                            withAnimation {
                                self.removeCards(at: index)
                            }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1) // hides the cards from acccessibilities other than the one the user is looking at
                    }
                }
                // checks if user is done with cards and asks for repeat
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty {
                    Button("Start Over", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            // a button that will allow the user to create cards
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            // provides a x mark and chekc mark for users who have differentiate without color on in their settings
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        // makes the x and check accomodate to voice over
                        Button(action: {
                            withAnimation {
                                self.removeCards(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCards(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
            if timeRemaining == 0 {
                ZStack {
                    Rectangle()
                        .background(Color.red)
                        .opacity(0.8)
                    VStack {
                        Spacer()
                        Text("Sry, time's out.\nYou had \(cards.count) cards left.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Spacer(minLength: 20)
                        Button("Start Again", action: resetCards)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                       Spacer()
                   }
               }.edgesIgnoringSafeArea(.all)
               .onAppear(perform: endGame)
            }
            else if cards.isEmpty && !isActive {
               Button("Start Again", action: resetCards)
                   .padding()
                   .background(Color.white)
                   .foregroundColor(.black)
                   .clipShape(Capsule())
           }
        }
        // start the timer
        .onReceive(timer) { time in
            guard self.isActive else {return}
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
        // if the user is not on the app stop timer
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        // sontinue/resume timer if user is on the app
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCardView()
        }
        .onAppear(perform: resetCards)
    }
    
    // gets rid of each card from the stack
    func removeCards(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
