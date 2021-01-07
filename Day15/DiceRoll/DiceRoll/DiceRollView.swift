//
//  DiceRollView.swift
//  DiceRoll
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct DiceRollView: View {
    
    @State private var diceValue = Int.random(in: 1...6)
    @EnvironmentObject var dice: Dice
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("\(diceValue)")
                    .scaledToFit()
                    Spacer()
                Button("Roll The Dice") {
                    self.roll()
                }
                    .padding()
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(30)
                    .font(.headline)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    private func roll() {
        let newRoll = Int.random(in: 1...6)
        diceValue = newRoll
        dice.values.append(newRoll)
    }
}
