//
//  ContentView.swift
//  DiceRoll
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

class Dice: ObservableObject {
    var values = [Int]()
}

struct ContentView: View {
    var diceValues = Dice()
    var body: some View {
        TabView {
            DiceRollView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                }
            SavedDice()
                .tabItem {
                    Image(systemName: "square.stack.fill")
                }
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(Color.white)
        .environmentObject(diceValues)
    }

    
}
