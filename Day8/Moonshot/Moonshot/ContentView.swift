//
//  ContentView.swift
//  Moonshot
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingDate = true
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink (destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading) {
                        Text(mission.displayName).font(.headline)
                        Text(self.showingDate ? mission.formattedLaunchDate : self.getCrewNames(mission: mission))
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button(showingDate ? "Show Crew Names" : "Show Launch Date") {
                self.showingDate.toggle()
            })
        }
    }
    func getCrewNames(mission: Mission) -> String {
        var matches = [String]()
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(match.name)
            } else {
                fatalError("Missing \(member)")
            }
        }

        return matches.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
