//
//  AppDelegate.swift
//  my-vilnius
//
//  Created by Rokas on 22/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import CoreLocation
import Firebase
import UIKit

@objc protocol ApplicationDelegate {
    
    @objc optional func handleError(message: String)
    @objc optional func handleAuthorization()
    @objc optional func handleUserLocation(location: CLLocation)
    @objc optional func handleAlert()
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var _signInViewController: SignInViewController = {
        return SignInViewController()
    }()
    
    private lazy var _mainTabBarController: MainTabBarController = {
        let tab = MainTabBarController()
        
        tab.tabBar.tintColor = .customGreen
        
        return tab
    }()
    
    private lazy var _buzzViewController: UINavigationController = {
        let controller = UINavigationController(rootViewController: BuzzViewController())
        
        return controller
    }()
    
    private lazy var _horizontalPageViewController: HorizontalPageViewController = {
        let controller = HorizontalPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return controller
    }()
    
    private lazy var _collectionViewController: CollectionViewController = {
        let controller = CollectionViewController()
        
        return controller
    }()
    
    private lazy var _firstCameraViewController: FirstCameraViewController = {
        let controller = FirstCameraViewController()
        
        return controller
    }()
    
    private lazy var _secondCameraViewController: SecondCameraViewController = {
        let controller = SecondCameraViewController()
        
        return controller
    }()
    
    private lazy var _mediaViewController: MediaViewController = {
        let controller = MediaViewController()
        
        return controller
    }()
    
    private lazy var _mapViewController: MapViewController = {
        let controller = MapViewController()
        
        return controller
    }()
    
    private lazy var _annotationViewController: AnnotationViewController = {
        let controller = AnnotationViewController()
        
        return controller
    }()
    
    private lazy var _profileViewController: ProfileViewController = {
        let controller = ProfileViewController()
        
        return controller
    }()
    
    private lazy var _locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()
    
    fileprivate var _location: CLLocation?
    fileprivate var _delegate: ApplicationDelegate?
    
    var location: CLLocation? {
        return _location
    }
    
    var locationManager: CLLocationManager {
        return _locationManager
    }
    
    var tabBarHeight: CGFloat {
        return _mainTabBarController.tabBar.frame.height
    }
    
    var delegate: ApplicationDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        setAppearance()
        
        _signInViewController.mainTabBarController = _mainTabBarController
        _signInViewController.firstCameraViewController = _firstCameraViewController
        
        _buzzViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "buzz")?.resizeImage(newHeight: 40), tag: 0)
        
        _horizontalPageViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "random")?.resizeImage(newHeight: 40), tag: 1)
        _horizontalPageViewController.collectionViewController = _collectionViewController
        _horizontalPageViewController.secondCameraViewController = _secondCameraViewController
        _horizontalPageViewController.setViewControllers([_secondCameraViewController], direction: .forward, animated: true)       
        
        _collectionViewController.mediaViewController = _mediaViewController
        _collectionViewController.tabController = _mainTabBarController
        
        _secondCameraViewController.tabController = _mainTabBarController
        
        _mediaViewController.tabController = _mainTabBarController
        
        _mapViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "map")?.resizeImage(newHeight: 40), tag: 2)
        _mapViewController.annotationViewController = _annotationViewController
        
        _profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile")?.resizeImage(newHeight: 40), tag: 3)
        _profileViewController.firstCameraViewController = _firstCameraViewController
        
        _mainTabBarController.viewControllers = [_buzzViewController, _horizontalPageViewController, _mapViewController, _profileViewController]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = _signInViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setAppearance() {
        //UILabel
        UILabel.appearance().defaultFont = .avenir
        UILabel.appearance().defaultTextColor = .darkGray
        
        //UITextField
        UITextField.appearance().defaultFont = .avenir
        UITextField.appearance().defaultTextColor = .darkGray
        
        //UITextView
        UITextView.appearance().defaultFont = .avenir
        UITextView.appearance().defaultTextColor = .darkGray
        
        //UIButton
        UIButton.appearance().defaultFont = .avenir
        UIButton.appearance().defaultTitleColor = .white
        
        //UINavigationBar
        UINavigationBar.appearance().barTintColor = .customGreen
        UINavigationBar.appearance().tintColor = .white
        
        //UIBarButtonItem
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.avenir], for: .normal)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// MARK: - CLLocationManagerDelegate

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse, let handleAuthorization = _delegate?.handleAuthorization?() {
            handleAuthorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _location = locations[0]
        if let location = _location, let handleUserLocation = _delegate?.handleUserLocation?(location: location) {
            handleUserLocation
        }
    }
    
    func checkLocality(completion: @escaping () -> ()) {
        if let location = _location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { 
                        return
                    }
                    
                    guard error == nil else {
                        strongSelf._delegate?.handleError?(message: LOCATION_ERROR)
                        return
                    }
                    
                    if let city = placemarks![0].locality, city == CITY {
                        completion()
                    } else {
                        strongSelf._delegate?.handleAlert?() 
                    }
                }
            }
        } else {
            _delegate?.handleError?(message: LOCATION_SERVICES_ERROR)
        }
    }
    
}
