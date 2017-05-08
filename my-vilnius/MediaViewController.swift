//
//  MediaViewController.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private var _indexPath: IndexPath?
    fileprivate let _shared = DataService.instance
    fileprivate var _tabController: UITabBarController?
    
    fileprivate lazy var _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    fileprivate lazy var _containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    fileprivate lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        longPressRecognizer.minimumPressDuration = 1
        
        collectionView.isPagingEnabled = true
        collectionView.frame = self.view.frame
        collectionView.register(MediaCell.self, forCellWithReuseIdentifier: MEDIA_CELL_ID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .customGreen
        collectionView.bounces = false
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        return collectionView
    }()
    
    var indexPath: IndexPath? {
        get { return _indexPath }
        set { _indexPath = newValue }
    }
    
    var tabController: UITabBarController? {
        get { return _tabController }
        set { _tabController = newValue }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = _indexPath {
            _collectionView.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * view.frame.width, y :0), animated: false)
        }
        _collectionView.isScrollEnabled = true
        _collectionView.reloadData()
        
        _tabController?.tabBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupScrollView()
        setupContainerView()
        _containerView.addSubview(_collectionView)
    }

}

// MARK: - Selectors

extension MediaViewController {
    
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if let indexPath = _collectionView.indexPathForItem(at: sender.location(in: _collectionView)) {
            let cell = _collectionView.cellForItem(at: indexPath) as! MediaCell
            
            handleLongPress(image: cell.pictureImageView.image, id: cell.media?.mediaId)
        }
        
    }
    
}

// MARK: - SetupUI

extension MediaViewController {
    
    fileprivate func setupScrollView() {
        view.addSubview(_scrollView)
        
        //x,y,w,h
        _scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        _scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupContainerView() {
        _scrollView.addSubview(_containerView)
        
        //x,y,w,h
        _containerView.leftAnchor.constraint(equalTo: _scrollView.leftAnchor).isActive = true
        _containerView.rightAnchor.constraint(equalTo: _scrollView.rightAnchor).isActive = true
        _containerView.topAnchor.constraint(equalTo: _scrollView.topAnchor).isActive = true
        _containerView.bottomAnchor.constraint(equalTo: _scrollView.bottomAnchor).isActive = true
        _containerView.heightAnchor.constraint(equalToConstant: view.frame.height + 1).isActive = true
        _containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            cell.userImageView.isHidden = false
            cell.userNameLabel.isHidden = false
            
            return cell
        }
        
        cell.media = media
        cell.userImageView.isHidden = false
        cell.userNameLabel.isHidden = false
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate

extension MediaViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 150 || scrollView.contentOffset.y < -150 {
            dismiss(animated: true)
            _tabController?.tabBar.isHidden = false
        }
    }
    
}

// MARK: - LongPressing

extension MediaViewController: LongPressing {}
























