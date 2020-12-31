//
//  HabitView.swift
//  Habitual
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// gives the description of the habit and allows the user to increment or decrement the completion amount
struct HabitView: View {
    @ObservedObject var habits: Habit // all the habits of the user
    @State var selected: HabitItem // the habit selected
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20){
                Text("\(selected.desc)").font(.title).padding(20)
                Text("Completed \(selected.completion) times").font(.headline)
                Stepper("Update",
                    onIncrement: {
                       self.selected.completion += 1
                       self.updateCompletion()
                    },
                    onDecrement: {
                       self.selected.completion -= 1
                       self.updateCompletion()
                    }
                )
                Spacer(minLength: 25)
            }
            .padding(.horizontal)
            .navigationBarTitle(selected.name)
        }
    }
    // makes sure that the completion amount in the habit selected is updated in the list of all habits
    func updateCompletion() {
        guard let index = habits.items.firstIndex(where: {$0.id == selected.id }) else { return }
        habits.items[index].completion = selected.completion
    }
}

// this part was not need
//struct HabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitView(habits: Habit, selected: HabitItem)
//    }
//}
