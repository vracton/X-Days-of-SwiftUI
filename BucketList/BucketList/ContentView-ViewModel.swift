//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by vracto on 6/28/25.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked: Bool = false
        var useStandardMap: Bool = true
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(name: "New location", desc: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        let savePath = URL.documentsDirectory.appending(path: "savedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("couldn't save locations")
            }
        }
        
        func authenticate() {
            let ctx = LAContext()
            var err: NSError?
            
            if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) {
                let reason = "Unlock saved locations"
                
                ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if success {
                        self.isUnlocked = true
                    }
                }
            }
        }
    }
}
