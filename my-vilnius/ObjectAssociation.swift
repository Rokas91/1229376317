//
//  ObjectAssociation.swift
//  my-vilnius
//
//  Created by Rokas on 30/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Foundation

final class ObjectAssociation<T: Any> {
    
    private let policy: objc_AssociationPolicy
    
    init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    subscript(index: Any) -> T? {
        get { 
            return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? 
        } set {
            objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) 
        }
    }
}
