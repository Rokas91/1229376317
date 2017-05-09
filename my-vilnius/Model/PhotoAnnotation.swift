//
//  PhotoAnnotation.swift
//  my-vilnius
//
//  Created by Rokas on 24/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    
    private var _annotationId: String!
    private var _userId: String!
    private var _imageUrl: String!
    private var _coordinate = CLLocationCoordinate2D()
    
    var annotationId: String {
        return _annotationId
    }
    
    var userId: String {
        return _userId
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var coordinate: CLLocationCoordinate2D {
        return _coordinate
    }
    
    init(annotationId: String, annotationData: [String : AnyObject]) {
        _annotationId = annotationId
        _userId = annotationData["userId"] as! String
        _imageUrl = annotationData["imageUrl"] as! String
        
        if let latitude = annotationData["latitude"] as? Double {
            _coordinate.latitude = latitude
        }
        
        if let longitude = annotationData["longitude"] as? Double {
            _coordinate.longitude = longitude
        }
    }
}
