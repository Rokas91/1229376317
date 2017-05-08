//
//  MediaCell.swift
//  my-vilnius
//
//  Created by Rokas on 05/03/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

class MediaCell: UICollectionViewCell {
    
    fileprivate lazy var _pictureImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
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
    
    var pictureImageView: UIImageView {
        return _pictureImageView
    }
    
    var userImageView: CircleImageView {
        return _userImageView
    }
    
    var userNameLabel: UILabel {
        return _userNameLabel
    }
    
    var media: Media? {
        didSet {
            if let media = media {
                configureCell(media: media)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _pictureImageView.image = nil
        _userImageView.image = nil
        _userNameLabel.text = nil
    }
    
    private func configureCell(media: Media) {
        DataService.instance.getUserData(userId: media.userId) { userData in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else {
                    return 
                }
                
                guard let userData = userData else {
                    return
                }
                
                strongSelf._pictureImageView.loadImageUsingCacheWithUrlString(media.imageUrl)
                strongSelf._userImageView.loadImageUsingCacheWithUrlString(userData["imageUrl"] as! String)
                strongSelf._userNameLabel.text = (userData["userName"] as! String)
            }
        }
    }
    
    private func setupUI() {
        setupPictureImageView()
        setupUserImageView()
        setupUserNameLabel()
        _userImageView.isHidden = true
        _userNameLabel.isHidden = true
    }
    
}

// MARK: - SetupUI

extension MediaCell {
    
    fileprivate func setupPictureImageView() {
        addSubview(_pictureImageView)
        
        //x,y,w,h
        _pictureImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _pictureImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _pictureImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        _pictureImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    fileprivate func setupUserImageView() {
        _pictureImageView.addSubview(_userImageView)
        
        //x,y,w,h
        _userImageView.leftAnchor.constraint(equalTo: _pictureImageView.leftAnchor, constant: 10).isActive = true
        _userImageView.topAnchor.constraint(equalTo: _pictureImageView.topAnchor, constant: 30).isActive = true
        _userImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        _userImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    fileprivate func setupUserNameLabel() {
        _pictureImageView.addSubview(_userNameLabel)
        
        //x,y,w,h
        _userNameLabel.leftAnchor.constraint(equalTo: _userImageView.rightAnchor, constant: 5).isActive = true
        _userNameLabel.topAnchor.constraint(equalTo: _userImageView.topAnchor).isActive = true
    }
    
}









