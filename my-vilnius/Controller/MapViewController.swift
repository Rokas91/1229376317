//
//  MapViewController.swift
//  my-vilnius
//
//  Created by Rokas on 20/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import MapKit
import UIKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let _shared = DataService.instance
    private var _locationManager: CLLocationManager?
    fileprivate var _mapHasCenteredOnce = false
    fileprivate var _annotationViewController: AnnotationViewController?
    
    fileprivate lazy var _mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        return mapView
    }()

    var annotationViewController: AnnotationViewController? {
        get { return _annotationViewController }
        set { _annotationViewController = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_mapView)
        _locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        (UIApplication.shared.delegate as! AppDelegate).delegate = self
        
        _shared.observeAnnotations(addAnnotation: { annotation in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else { 
                    return 
                }
                strongSelf._mapView.addAnnotation(annotation)
            }
        }, removeAnnotation: { annotation in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else { 
                    return 
                }
                
                var annotations = strongSelf._mapView.annotations.filter { (($0 as? PhotoAnnotation) != nil) } as! [PhotoAnnotation]
                annotations = annotations.filter { $0.imageUrl != annotation.imageUrl }
                strongSelf._mapView.removeAnnotations(strongSelf._mapView.annotations)
                strongSelf._mapView.addAnnotations(annotations)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            _locationManager?.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            _mapView.showsUserLocation = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _locationManager?.stopUpdatingLocation()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000)
        
        _mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "annotation"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView = av
        }
        
        if let annotationView = annotationView, let annotation = annotation as? PhotoAnnotation {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            
            tapRecognizer.annotation = annotation
            annotationView.loadImageUsingCacheWithUrlString(annotation.imageUrl, completion: { (image) in
                tapRecognizer.image = image
            })
            annotationView.isUserInteractionEnabled = true
            annotationView.addGestureRecognizer(tapRecognizer)
        }
        
        return annotationView
    }
    
}

// MARK: - ApplicationDelegate

extension MapViewController: ApplicationDelegate {
    
    func handleUserLocation(location: CLLocation) {
        if !_mapHasCenteredOnce {
            centerMapOnLocation(location: location)
            _mapHasCenteredOnce = true
        }
    }
    
    func handleAuthorization() {
        _mapView.showsUserLocation = true
    }
    
}

// MARK: - Selectors

extension MapViewController {
    
    func onTap(_ sender: UITapGestureRecognizer) {
        if let annotationViewController = _annotationViewController {
            annotationViewController.modalPresentationStyle = .overCurrentContext
            annotationViewController.annotation = sender.annotation
            annotationViewController.image = sender.image
            present(annotationViewController, animated: true)
        }
    }
    
}
