//
//  SavedDice.swift
//  DiceRoll
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct SavedDice: View {
    @EnvironmentObject var dice: Dice
    
    var body: some View {
        List {
            ForEach(dice.values, id: \.self) { die in
                HStack {
                    Text("You rolled a \(die):")
                    Image("\(die)")
                    .resizable()
                    .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}
struct SavedDice_Previews: PreviewProvider {
    static var previews: some View {
        SavedDice()
    }
}
