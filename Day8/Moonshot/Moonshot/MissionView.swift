//
//  MissionView.swift
//  Moonshot
//
//  Created by Tajwar Rahman on 12/30/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    
    let mission: Mission
    let astronauts: [CrewMember]
    let allMissions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { geometry in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geo.size.width * 0.7)
                            .padding(.top)
                            .frame(maxWidth: geometry.size.width)
                            .padding()
                            .scaleEffect((geo.frame(in: .global).midY) / (geo.frame(in: .global).maxY) * 0.8)
                    }
                    Text("Launch Date: \(self.mission.formattedLaunchDate)")
                        .font(.headline)
                        .fontWeight(.black)
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role){ crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, onMissions: self.allMissions)){
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 82, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                VStack(alignment: .leading){
                                    Text(crewMember.astronaut.name).font(.headline)
                                    Text(crewMember.role).foregroundColor(.secondary)
                                }
                                Spacer()
                            }.padding(.horizontal)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew{
            if let match = astronauts.first(where: { $0.id == member.name }){
                matches.append(CrewMember(role: member.role, astronaut: match))
            }
            else {
                fatalError("Missing member")
            }
        }
        
        self.astronauts = matches
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
