//
//  AstronautView.swift
//  Moonshot
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let onMissions: [Mission]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    Text("Missions:")
                        .font(.headline)
                        .padding()
                    VStack {
                        ForEach(self.onMissions) { mission in
                            Image(mission.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(mission.displayName)
                                .font(.headline)
                                .accessibilityElement(children: .combine)
                        }
                    }.padding(.horizontal)
                }
            }
        }.navigationBarTitle(Text(self.astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut, onMissions: [Mission]) {
        self.astronaut = astronaut
        
        var matches = [Mission]()
        
        for mission in onMissions {
            if mission.crew.first(where: { $0.name == astronaut.id}) != nil{
                matches.append(mission)
            }
        }
        self.onMissions = matches
    }
        
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], onMissions: missions)
    }
}
