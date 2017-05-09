//
//  Post.swift
//  my-vilnius
//
//  Created by Rokas on 25/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Foundation

struct Post {
    
    private var _postId: String!
    private var _userId: String!
    private var _userName: String!
    private var _postDesc: String!
    private var _timestamp: TimeInterval!
    
    var postId: String {
        return _postId
    }
    
    var userId: String {
        return _userId
    }
    
    var userName: String {
        return _userName
    }
    
    var postDesc: String {
        return _postDesc
    }
    
    var timestamp: TimeInterval {
        return _timestamp
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970:((_timestamp) / 1000))
        let weekdays = ["Sun",
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thur",
                        "Fri",
                        "Sat"]
        
        let calendar = Calendar.current as NSCalendar
        let components = calendar.components(.weekday, from: date) as NSDateComponents
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm MM/dd"
        
        return "\(weekdays[components.weekday - 1] ) \(formatter.string(from: date))"
    }
    
    init(postId: String, postData: [String : AnyObject]) {
        _postId = postId
        _userId = postData["userId"] as! String
        _userName = postData["userName"] as! String
        _postDesc = postData["description"] as! String
        _timestamp = postData["timestamp"] as! TimeInterval
    }
    
}
