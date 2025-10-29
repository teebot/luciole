//
//  WeatherManager.swift
//  Luciole
//
//  Manages weather data using WeatherKit
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherManager: NSObject, ObservableObject {
    @Published var temperature: String = "--"
    @Published var weatherSymbol: String = "cloud"
    @Published var locationAuthorized = false

    private let weatherService = WeatherService.shared
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self

        // Defer authorization check to avoid blocking UI
        DispatchQueue.main.async { [weak self] in
            self?.checkLocationAuthorization()
        }
    }

    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus

        print("📍 Location authorization status: \(status.rawValue)")

        switch status {
        case .notDetermined:
            print("📍 Requesting location authorization...")
            // Request authorization asynchronously
            DispatchQueue.main.async { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            print("📍 Location authorized, starting updates...")
            locationAuthorized = true
            DispatchQueue.main.async { [weak self] in
                self?.locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            print("⚠️ Location access denied or restricted")
            locationAuthorized = false
        @unknown default:
            print("⚠️ Unknown location authorization status")
            locationAuthorized = false
        }
    }

    func fetchWeather() {
        guard let location = currentLocation else {
            print("⚠️ Cannot fetch weather: location is nil")
            return
        }

        print("🌤️ Fetching weather for location: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        Task {
            do {
                let weather = try await weatherService.weather(for: location)

                await MainActor.run {
                    // Get temperature in Celsius
                    let temp = weather.currentWeather.temperature
                    self.temperature = "\(Int(temp.value.rounded()))°"

                    // Get weather symbol
                    self.weatherSymbol = symbolName(for: weather.currentWeather.condition)

                    print("✅ Weather updated: \(self.temperature) \(weather.currentWeather.condition)")
                }
            } catch {
                print("❌ Error fetching weather: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
                await MainActor.run {
                    self.temperature = "--"
                    self.weatherSymbol = "cloud"
                }
            }
        }
    }

    private func symbolName(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .mostlyClear:
            return "cloud.sun.fill"
        case .mostlyCloudy:
            return "cloud.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .foggy:
            return "cloud.fog.fill"
        case .haze:
            return "cloud.fog.fill"
        case .smoky:
            return "smoke.fill"
        case .breezy, .windy:
            return "wind"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .rain, .sunShowers:
            return "cloud.rain.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .isolatedThunderstorms, .thunderstorms, .strongStorms:
            return "cloud.bolt.rain.fill"
        case .flurries, .snow, .blizzard, .blowingSnow:
            return "cloud.snow.fill"
        case .freezingDrizzle, .freezingRain, .sleet:
            return "cloud.sleet.fill"
        case .hail:
            return "cloud.hail.fill"
        case .frigid, .hot:
            return "thermometer"
        case .hurricane, .tropicalStorm:
            return "hurricane"
        case .scatteredThunderstorms:
            return "cloud.bolt.fill"
        case .heavySnow, .sunFlurries:
            return "snow"
        case .wintryMix, .blowingDust:
            return "wind"
        @unknown default:
            return "cloud"
        }
    }
}

extension WeatherManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("⚠️ No location in update")
            return
        }

        print("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        currentLocation = location

        // Stop updating to save battery
        locationManager.stopUpdatingLocation()

        // Fetch weather for this location
        fetchWeather()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("📍 Location authorization changed")
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error)")
        print("❌ Location error details: \(error.localizedDescription)")
    }
}
