//
//  ContentView.swift
//  Habitual
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// a struct that will hold the habit info
struct HabitItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var desc: String
    var completion: Int
}

// class that encodes and decodes the habit info
class Habit: ObservableObject {
    @Published var items = [HabitItem]() {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    // an initializer that decodes the users habits
    init() {
        if let items = UserDefaults.standard.data(forKey: "Habits"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([HabitItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}
struct ContentView: View {
    @ObservedObject var habits = Habit()
    @State private var showingAddHabit = false
    var body: some View {
        NavigationView {
            List {
                // lists out each habit, the description, and number of times completed
                ForEach(habits.items) { item in
                    // each habit is like a button that takes the user to the habitview screen
                    NavigationLink(destination: HabitView(habits: self.habits, selected: item)){
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(item.desc)
                            }
                            Spacer()
                            Text(item.completion == 1 ? "\(item.completion) time" : "\(item.completion) times")
                        }
                    }
                }.onDelete(perform: removeHabits)
            }
            .navigationBarTitle("Habitual")
            .navigationBarItems(leading: EditButton(),
                trailing: Button(action: {
                    self.showingAddHabit = true
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddHabit){
                    AddHabitView(habits: self.habits)
            }
        }
    }
    // allows the user to get rid of whatever habits they want
    func removeHabits(at offsets: IndexSet) {
        habits.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
