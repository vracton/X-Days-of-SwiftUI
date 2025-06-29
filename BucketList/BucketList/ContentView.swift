//
//  ContentView.swift
//  BucketList
//
//  Created by vracto on 6/27/25.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        if viewModel.isUnlocked {
                            ForEach(viewModel.locations) { loc in
                                Annotation(loc.name, coordinate: loc.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture(minimumDuration: 0.2) {
                                            viewModel.selectedPlace = loc
                                        }
                                }
                            }
                        }
                    }
                    .mapStyle(viewModel.useStandardMap ? .standard : .hybrid)
                    .onTapGesture { pos in
                        if viewModel.isUnlocked {
                            if let coord = proxy.convert(pos, from: .local) {
                                viewModel.addLocation(at: coord)
                            }
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                .blur(radius: viewModel.isUnlocked ? 0 : 4)
                .allowsHitTesting(viewModel.isUnlocked)
                if !viewModel.isUnlocked {
                    Button("Unlock Places", systemImage: "faceid", action: viewModel.authenticate)
                        .padding(20)
                        .buttonStyle(.glass)
                }
            }
            .toolbar {
                Button("Switch Map Style", systemImage: "map") {
                    viewModel.useStandardMap.toggle()
                }
                .disabled(!viewModel.isUnlocked)
            }
        }
    }
}

#Preview {
    ContentView()
}
