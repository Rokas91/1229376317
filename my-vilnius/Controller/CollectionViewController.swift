//
//  CollectionViewController.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var _timer: Timer?
    private var _tabController: UITabBarController?
    fileprivate var _mediaViewController: MediaViewController?
    fileprivate let _shared = DataService.instance
    
    fileprivate lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let lenght = self.view.frame.width * 0.291
        let tabBarHeight = (UIApplication.shared.delegate as! AppDelegate).tabBarHeight
        let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, tabBarHeight, 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: lenght, height: lenght)
        
        collectionView.frame = self.view.frame
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        collectionView.register(MediaCell.self, forCellWithReuseIdentifier: MEDIA_CELL_ID)
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var tabController: UITabBarController? {
        get { return _tabController }
        set { _tabController = newValue }
    }
    
    var mediaViewController: MediaViewController? {
        get { return _mediaViewController }
        set { _mediaViewController = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customGreen
        view.addSubview(_collectionView)

        _shared.observeMedia {
            self.scheduleTimer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _tabController?.tabBar.isHidden = false
    }
    
    private func scheduleTimer() {
        _timer?.invalidate()
        _timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(reloadCollectionView), userInfo: nil, repeats: false)
    }

}

// MARK: - Selectors

extension CollectionViewController {
    
    func reloadCollectionView() {
        DispatchQueue.main.async{ [weak self] in
            guard let strongSelf = self else { 
                return 
            }
            strongSelf._shared.mediaArray = strongSelf._shared.mediaArray.sorted(by: { $0.timestamp > $1.timestamp })
            strongSelf._collectionView.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _shared.mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MediaCell()
        let media = _shared.mediaArray[indexPath.row]
                
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MEDIA_CELL_ID, for: indexPath) as? MediaCell {
            cell.media = media
            return cell
        }

        cell.media = media
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mediaViewController = _mediaViewController else {
            return
        }
        
        mediaViewController.indexPath = indexPath
        mediaViewController.modalPresentationStyle = .overCurrentContext
        present(mediaViewController, animated: true)
    }
    
}





























