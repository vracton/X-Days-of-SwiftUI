//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by vracto on 6/28/25.
//

import Foundation


extension EditView {
    @Observable
    class ViewModel {
        var loadingState: LoadState = .loading
        var pages: [Page] = [Page]()
        
        var location: Location
        var name: String
        var desc: String
        
        init(_ location: Location) {
            self.location = location
            self.name = location.name
            self.desc = location.desc
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("bad url")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                print(error.localizedDescription)
                loadingState = .failed
            }
        }
        
        func updatedLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.desc = desc
            return newLocation
        }
    }
}
