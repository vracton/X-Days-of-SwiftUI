//
//  AstronautView.swift
//  Moonshot
//
//  Created by vracto on 6/15/25.
//

import SwiftUI


struct AstronautView: View {
    let astronaut: Astronaut
    let role: String
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
                    Text(astronaut.description)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(astronaut.name)
        .navigationSubtitle("\(missionName) - \(role)") //ios 26 (again) !!
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBG)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    AstronautView(astronaut: astronauts["armstrong"]!, role: "Commander", missionName: "Apollo 11")
        .preferredColorScheme(.dark)
}
