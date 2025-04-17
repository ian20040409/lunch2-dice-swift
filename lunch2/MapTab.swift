import SwiftUI
import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var coordinate: CLLocationCoordinate2D?
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        coordinate = loc.coordinate
        self.manager.stopUpdatingLocation()
    }
}

struct MapTab: View {
    @StateObject private var locMgr = LocationManager()
    @State private var buttonScale: CGFloat = 1.0
    @State private var buttonOffset: CGFloat = UIScreen.main.bounds.height
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.033964, longitude: 121.564468),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    private var searchURL: (keyword: String, appScheme: String, webURL: String) {
        let keyword = "餐廳"
        let defaultAppScheme = "googlemaps://?q=\(keyword)"
        let defaultWebURL = "https://www.google.com/maps/search/\(keyword)"
        var appScheme = defaultAppScheme
        var webURL = defaultWebURL
        if let coord = locMgr.coordinate {
            appScheme = "googlemaps://?q=\(keyword)&center=\(coord.latitude),\(coord.longitude)"
            webURL = "https://www.google.com/maps/search/\(keyword)/@\(coord.latitude),\(coord.longitude),15z"
        }
        return (keyword, appScheme, webURL)
    }

    var body: some View {
        ZStack {
            // Use system background to match light/dark mode
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Map(position: .constant(.userLocation(fallback: .region(region))))
                    .mapControls {
                        MapUserLocationButton()
                    }
                    .frame(height: 300)
                    .cornerRadius(16)
                    .padding()
                
                // Removed inline search URL logic. Button now uses computed property 'searchURL'.
                
                Button(action: {
                    let keyword = searchURL.keyword
                    let appScheme = searchURL.appScheme
                    let webURL = searchURL.webURL
                    if let appURL = URL(string: appScheme), UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else if let url = URL(string: webURL) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("打開 Google 地圖搜尋 \(searchURL.keyword)")
                        .font(.headline)
                        .foregroundColor(.white)
                        // Add padding for a larger tappable area
                        .padding(.vertical, 14)
                        .padding(.horizontal, 32)
                        // Background, corner radius, and shadow for depth
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(buttonScale)
                .offset(y: buttonOffset)
                .onAppear {
                    withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                        buttonOffset = 0
                    }
                }
                .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                        buttonScale = pressing ? 0.9 : 1.0
                    }
                }, perform: {})
            }
        }
        .onReceive(locMgr.$coordinate) { newCoord in
            if let newCoord = newCoord {
                region.center = newCoord
            }
        }
    }
}
