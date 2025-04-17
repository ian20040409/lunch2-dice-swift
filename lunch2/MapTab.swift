import SwiftUI
import UIKit
import CoreLocation

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

    var body: some View {
        ZStack {
            // Use system background to match light/dark mode
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button(action: {
                    let defaultAppScheme = "googlemaps://?q=餐廳"
                    let defaultWebURL = "https://www.google.com/maps/search/餐廳"
                    var appScheme = defaultAppScheme
                    var webURL = defaultWebURL
                    if let coord = locMgr.coordinate {
                        appScheme = "googlemaps://?q=餐廳&center=\(coord.latitude),\(coord.longitude)"
                        webURL = "https://www.google.com/maps/search/餐廳/@\(coord.latitude),\(coord.longitude),15z"
                    }
                    if let appURL = URL(string: appScheme), UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else if let url = URL(string: webURL) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("打開 Google 地圖搜尋餐廳")
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
    }
}
