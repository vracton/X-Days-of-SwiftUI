//
//  AstronautView.swift
//  Moonshot
//
//  Created by vracto on 6/15/25.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: MissionView.CrewMember
    let missionName: String
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width*0.8
                    }
                    .clipShape(.capsule)
                    .overlay(
                        Capsule()
                            .strokeBorder(.lightBG, lineWidth: 2)
                    )
                    .padding(.top)
                
                VStack(alignment: .leading) {
                    HorizDivider()
                    Text("Biography")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(astronaut.desc)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(astronaut.name)
        .navigationSubtitle("\(missionName) - \(astronaut.role)") //ios 26 (again) !!
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBG)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let astronaut = MissionView.CrewMember(role: "Commander", astronaut: astronauts["armstrong"]!)
    
    AstronautView(astronaut: astronaut, missionName: "Apollo 11")
        .preferredColorScheme(.dark)
}
