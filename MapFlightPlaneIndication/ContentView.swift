//
//  ContentView.swift
//  MapFlightPlaneIndication
//
//  Created by Elliot Knight on 01/01/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: .init(latitude: 22.176310, longitude:-41.176251),
            distance: .infinity
            )
    )


    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                Map(
                    position: $cameraPosition
                ) {
                    Annotation("Orly airport", coordinate: .orlyAirport) {
                        Image(systemName: "airplane")
                            .font(.system(size: 20))
                            .rotationEffect(.degrees(200))
                    }
                    .annotationTitles(.hidden)

                    MapPolyline(coordinates: CLLocationCoordinate2D.airports, contourStyle: .geodesic)
                        .stroke(Color.orange, lineWidth: 2.5)
                }
                FlightInformationsView()
                    .padding()
                    .background(.thinMaterial)
            }
        }
        .onAppear {
            averageLocationBetweenTwoAirports()
        }
    }

    private func averageLocationBetweenTwoAirports() {
        let centerCoordinate = calculAverageLocationBetweenTwoAirports()

        let distanceBetweenAirports = distanceBetweenCoordinates()

        // Multiplier la distance entre les aéroports par un facteur pour la vue de la caméra
        let cameraDistance = distanceBetweenAirports * 2.3
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: centerCoordinate,
                distance: cameraDistance
            )
        )
    }

    private func calculAverageLocationBetweenTwoAirports() -> CLLocationCoordinate2D {
        let orlyAirport = CLLocationCoordinate2D.orlyAirport
        let newarkAirport = CLLocationCoordinate2D.newarkAirport

        let avgLatitude = (orlyAirport.latitude + newarkAirport.latitude) / 2
        let avgLongitude = (orlyAirport.longitude + newarkAirport.longitude) / 2

        return CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude)
    }

    private func distanceBetweenCoordinates() -> CLLocationDistance {
        let orlyAirport = CLLocationCoordinate2D.orlyAirport
        let newarkAirport = CLLocationCoordinate2D.newarkAirport

        let location1 = CLLocation(latitude: orlyAirport.latitude, longitude: orlyAirport.longitude)
        let location2 = CLLocation(latitude: newarkAirport.latitude, longitude: newarkAirport.longitude)

        return location1.distance(from: location2)
    }


}

#Preview {
    ContentView()
}
