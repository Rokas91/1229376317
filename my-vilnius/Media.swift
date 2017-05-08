//
//  Media.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Foundation

struct Media {
    
    private var _mediaId: String!
    private var _userId: String!
    private var _imageUrl: String!
    private var _timestamp: TimeInterval!
    
    var mediaId: String {
        return _mediaId
    }
    
    var userId: String {
        return _userId
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var timestamp: TimeInterval {
        return _timestamp
    }
    
    init(mediaId: String, mediaData: [String : AnyObject]) {
        _mediaId = mediaId
        _userId = mediaData["userId"] as! String
        _imageUrl = mediaData["imageUrl"] as! String
        _timestamp = mediaData["timestamp"] as! TimeInterval
    }
    
}
