//
//  ContentView.swift
//  Moonshot
//
//  Created by vracto on 6/14/25.
//

import SwiftUI


struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let layout = [GridItem(.adaptive(minimum: 150))]
    
    @State private var isGrid: Bool = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isGrid {
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(missions) { m in
                                NavigationLink(value: m) {
                                    VStack {
                                        Image(m.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        VStack {
                                            Text(m.displayName)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text(m.formattedLaunchDate)
                                                .font(.caption)
                                                .foregroundStyle(.white.opacity(0.5))
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(.lightBG)
                                    }
                                    .clipShape(.rect(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(.lightBG, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 7)
                    }
                } else {
                    List {
                        ForEach(missions) { m in
                            NavigationLink {
                                MissionView(mission: m, astronauts: astronauts)
                            } label: {
                                HStack {
                                    Image(m.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .padding(.trailing, 10)
                                    VStack(alignment: .leading) {
                                        Text(m.displayName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(m.formattedLaunchDate)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(m.displayName), \(m.formattedLaunchDate)")
                            .accessibilityInputLabels([m.displayName, String(m.id)])
                        }
                        .listRowBackground(Color.darkBG)
                        .padding(.bottom, 7)
                    }
                    .listStyle(.plain)
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .bottom)
            .navigationTitle("Moonshot")
            .background(.darkBG)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarSpacer(.flexible, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    Menu("Sort", systemImage: isGrid ? "square.grid.2x2" : "list.bullet") {
                        Button("List", systemImage: "list.bullet") {
                            isGrid = false
                        }
                        Button("Grid", systemImage: "square.grid.2x2") {
                            isGrid = true
                        }
                    }
                }
            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
        }
    }
}

#Preview {
    ContentView()
}
