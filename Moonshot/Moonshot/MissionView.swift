//
//  MissionView.swift
//  Moonshot
//
//  Created by vracto on 6/15/25.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember: Hashable {
        let role: String
        let astronaut: Astronaut
        
        var id: String { astronaut.id }
        var name: String { astronaut.name }
        var desc: String { astronaut.description }
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { a in
            if let astronaut = astronauts[a.name] {
                return CrewMember(role: a.role, astronaut: astronaut)
            } else {
                fatalError("Could not find astronaut \(a.name)")
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.imageName)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width*0.7
                    }
                    .padding(.top)
                
                VStack(alignment: .leading) {
                    HorizDivider()
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                    HorizDivider()
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { mem in
                            NavigationLink(value: mem) {
                                VStack {
                                    Image(mem.id)
                                        .resizable()
                                        .frame(width: 208, height: 144)
                                        .clipShape(.capsule)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(.lightBG, lineWidth: 2)
                                        )
                                        .padding(.bottom, 10)
                                    
                                    VStack {
                                        Text(mem.name)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        Text(mem.role)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                                .padding(.horizontal)
                            }
                            if mem.role != crew.last?.role {
                                VertDivider()
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationSubtitle(mission.formattedLaunchDate) //ios 26 !!
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBG)
        .navigationDestination(for: CrewMember.self) { mem in
            AstronautView(astronaut: mem, missionName: mission.displayName)
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
