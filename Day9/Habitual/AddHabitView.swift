//
//  AddHabitView.swift
//  Habitual
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// a sheet that pops up from the bottom to add a new habit
struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habit
    @State private var name = ""
    @State private var desc = ""
    @State private var completion = 1
    var body: some View {
        NavigationView{
            Form {
                TextField("Habit Name", text: $name)
                TextField("Short description of habit", text: $desc)
            }
            .navigationBarTitle("Add new habit")
            .navigationBarItems(trailing:
                Button("Save") {
                    let item = HabitItem(name: self.name, desc: self.desc, completion: self.completion)
                    self.habits.items.append(item)
                    self.presentationMode.wrappedValue.dismiss() // the sheet closes itself after pressing save
                }
            )
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habit())
    }
}
