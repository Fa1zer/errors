//
//  LocationManager.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    override init() {
        super.init()
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    private(set) var completion: ((CLLocation) -> Void)?
        
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        
        self.completion = completion
        
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard !locations.isEmpty, let location = locations.last else { return }
        
        self.completion?(location)
        
    }
    
}
