//
//  HorizontalPageViewController.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class HorizontalPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    fileprivate var _collectionViewController: CollectionViewController?
    fileprivate var _secondCameraViewController: SecondCameraViewController?
    
    var collectionViewController: CollectionViewController? {
        get { return _collectionViewController }
        set { _collectionViewController = newValue }
    }
    
    var secondCameraViewController: SecondCameraViewController? {
        get { return _secondCameraViewController }
        set { _secondCameraViewController = newValue }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .white
    }
    
    func enableSwipeGesture(enable: Bool){
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = enable
            }
        }
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension HorizontalPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let _ = viewController as? CollectionViewController, let secondCameraViewController = _secondCameraViewController {
            return secondCameraViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let _ = viewController as? SecondCameraViewController, let collectionViewController = _collectionViewController {
            return collectionViewController
        }
        return nil
    }
}
