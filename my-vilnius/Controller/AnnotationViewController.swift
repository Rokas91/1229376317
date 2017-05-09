//
//  AnnotationViewController.swift
//  my-vilnius
//
//  Created by Rokas on 29/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var _annotation: PhotoAnnotation?
    fileprivate var _image: UIImage?
    
    fileprivate lazy var _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        
        longPressRecognizer.minimumPressDuration = 1
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addGestureRecognizer(longPressRecognizer)
        
        return scrollView
    }()
    
    fileprivate lazy var _containerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate lazy var _imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    fileprivate lazy var _userImageView: CircleImageView = {
        let imageView = CircleImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    fileprivate lazy var _userNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customGreen
        label.font = .avenirHeavy
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var annotation: PhotoAnnotation? {
        get { return _annotation }
        set { _annotation = newValue }
    }
    
    var image: UIImage? {
        get { return _image }
        set { _image = newValue }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userId = _annotation?.userId {
            DataService.instance.getUserData(userId: userId) { userData in
                DispatchQueue.main.async{ [weak self] in
                    guard let strongSelf = self else {
                        return 
                    }
                    
                    guard let userData = userData else {
                        return
                    }
                    
                    strongSelf._imageView.image = strongSelf._image
                    strongSelf._userImageView.loadImageUsingCacheWithUrlString(userData["imageUrl"] as! String)
                    strongSelf._userNameLabel.text = (userData["userName"] as! String)
                }
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupScrollView()
        setupContainerView()
        setupImageView()
        setupUserImageView()
        setupUserNameLabel()
    }
    
}

// MARK: - Selectors

extension AnnotationViewController {
    
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        handleLongPress(image: _image, id: _annotation?.annotationId)
    }
    
}

// MARK: - SetupUI

extension AnnotationViewController {
    
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
    
    fileprivate func setupImageView() {
        _containerView.addSubview(_imageView)
        
        //x,y,w,h
        _imageView.leftAnchor.constraint(equalTo: _containerView.leftAnchor).isActive = true
        _imageView.rightAnchor.constraint(equalTo: _containerView.rightAnchor).isActive = true
        _imageView.topAnchor.constraint(equalTo: _containerView.topAnchor).isActive = true
        _imageView.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupUserImageView() {
        _imageView.addSubview(_userImageView)
        
        //x,y,w,h
        _userImageView.leftAnchor.constraint(equalTo: _imageView.leftAnchor, constant: 10).isActive = true
        _userImageView.topAnchor.constraint(equalTo: _imageView.topAnchor, constant: 30).isActive = true
        _userImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        _userImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    fileprivate func setupUserNameLabel() {
        _imageView.addSubview(_userNameLabel)
        
        //x,y,w,h
        _userNameLabel.leftAnchor.constraint(equalTo: _userImageView.rightAnchor, constant: 5).isActive = true
        _userNameLabel.topAnchor.constraint(equalTo: _userImageView.topAnchor).isActive = true
    }
    
}

// MARK: - UIScrollViewDelegate

extension AnnotationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 150 || scrollView.contentOffset.y < -150 {
            dismiss(animated: true)
        }
    }
    
}

// MARK: - LongPressing

extension AnnotationViewController: LongPressing {}
