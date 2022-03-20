//
//  GeolocationViewController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 17.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class GeolocationViewController: UIViewController {
    
    private let locationManager = LocationManager.shared
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.getLocation()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Remove pins",
                                                                                         comment: ""),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(self.deleteAllPins))
        self.view.backgroundColor = .white
        self.title = NSLocalizedString("Geocoder", comment: "")
        
        self.view.addSubview(mapView)
        
        self.mapView.snp.makeConstraints { make in
            make.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAddPin(_:)))
        
        self.mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    private func getLocation() {
        
        self.locationManager.getUserLocation { location in
            
            DispatchQueue.main.async { [ weak self ] in
                
                guard let self = self else { return }
                
                self.addPin(location: location)
                
            }
            
        }
        
    }
    
    private func addPin(location: CLLocation) {
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = location.coordinate
        
        self.mapView.addAnnotation(pin)
        self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                  span: MKCoordinateSpan(latitudeDelta: 0.8,
                                                                         longitudeDelta: 0.8)),
                               animated: true)
        
    }
    
    @objc private func longPressAddPin(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
                        
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let anotation = MKPointAnnotation()
            
            anotation.coordinate = touchCoordinates
            
            self.mapView.addAnnotation(anotation)
            
        }
        
    }
    
    @objc private func deleteAllPins() {
        
        var anotations = self.mapView.annotations
        
        guard anotations.count > 1 else { return }
        
        anotations.remove(at: 0)
        
        self.mapView.removeAnnotations(anotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        
    }
    
}

extension GeolocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if self.mapView.annotations.first?.coordinate.latitude == view.annotation?.coordinate.latitude,
           self.mapView.annotations.first?.coordinate.longitude == view.annotation?.coordinate.longitude {
            
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            return
            
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("What to do with the tag?",
                                                                         comment: ""), message: nil,
                                                preferredStyle: .alert)
        
        let firstAlertAction = UIAlertAction(title: NSLocalizedString("Back", comment: ""),
                                             style: .default) { _ in
            
            mapView.deselectAnnotation(view.annotation, animated: true)
            
        }
        
        let secondAlertAction = UIAlertAction(title: NSLocalizedString("Remove", comment: ""),
                                              style: .default) { [ weak self ] _ in
            
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            guard let annotation = view.annotation else { return }
                        
            self?.mapView.removeAnnotation(annotation)
            self?.mapView.removeOverlays(self?.mapView.overlays ?? [])
                        
        }
        
        let thirdAlertAction = UIAlertAction(title: NSLocalizedString("Plan a route", comment: ""),
                                             style: .cancel) { [ weak self ] _ in
            
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            guard let firstCoordinate = self?.mapView.annotations.first?.coordinate,
                    let secondCoordinate = view.annotation?.coordinate else { return }
            
            let firstMapItem = MKMapItem(placemark: MKPlacemark(coordinate: firstCoordinate))
            let secondMapItem = MKMapItem(placemark: MKPlacemark(coordinate: secondCoordinate))
            
            let directRequest = MKDirections.Request()
            
            directRequest.source = firstMapItem
            directRequest.destination = secondMapItem
            directRequest.transportType = .automobile
            
            let direction = MKDirections(request: directRequest)
            
            direction.calculate { response, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
                
                guard let response = response else {
                    print("error: response is equal to nil")
                    
                    return
                }
                                
                guard let polyline = response.routes.first?.polyline else {
                    print("error: polyline is equal to nil")
                    
                    return
                }
                
                self?.mapView.removeOverlays(self?.mapView.overlays ?? [])
                self?.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
                self?.mapView.setRegion(MKCoordinateRegion(polyline.boundingMapRect), animated: true)
                
            }
            
        }
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        alertController.addAction(thirdAlertAction)
        
        self.present(alertController, animated: true)
                
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKPolylineRenderer(overlay: overlay)
        
        render.lineWidth = 7
        render.strokeColor = .systemBlue
        
        return render
        
    }
    
}
