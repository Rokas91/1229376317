//
//  ReportViewController.swift
//  my-vilnius
//
//  Created by Rokas on 26/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

class ReportViewController: EditViewController {
    
    // MARK: - Properties
    
    fileprivate var _postId: String?
    fileprivate var _mediaId: String?
    
    var postId: String? {
        get { return _postId }
        set { _postId = newValue }
    }
    
    var mediaId: String? {
        get { return _mediaId }
        set { _mediaId = newValue }
    }
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
}

// MARK: - EditViewControllerDelegate

extension ReportViewController: EditViewControllerDelegate {
    
    var charactersCount: Int { 
        return 1000
    }
    var leavingWarning: String { 
        return WANT_LEAVE_REPORTING
    }
    var buttonTitle: String {
        return REPORT
    }
    
    func handleTap() {
        guard let text = textView.text, !text.isEmpty else {
            createAlertWithOkAction(title: WARNING, message: MUST_SAY)
            return
        }
        
        if let currentUser = AuthService.currentUser {
            let report: [String: AnyObject] = ["senderId" : currentUser.uid as AnyObject,
                                               "postId" : _postId as AnyObject,
                                               "mediaId" : _mediaId as AnyObject,
                                               "reportMessage" : text as AnyObject,
                                               "timestamp" : FIRServerValue.timestamp() as AnyObject]
            
            shared.reportsRef.childByAutoId().setValue(report) { (error, reference) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { 
                        return
                    }
                    
                    if let _ = error {
                        strongSelf.createAlertWithOkAction(title: ERROR, message: SOMETHING_WENT_WRONG)
                    } else {
                        strongSelf.textView.text = ""
                        strongSelf.createDismissingAlert(title: REPORTED) {
                            strongSelf.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    
}
