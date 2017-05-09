//
//  ExpandableCell.swift
//  my-vilnius
//
//  Created by Rokas on 25/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol ExpandableCellDelegate {
    
    func present(navigationController: UINavigationController)
    
}

class ExpandableCell: UITableViewCell {
    
    // MARK: - Properties
    
    fileprivate var _isReportButtonHidden = true
    fileprivate var _delegate: ExpandableCellDelegate?
    
    fileprivate lazy var _postImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    fileprivate lazy var _userNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customGreen
        label.font = .avenirHeavy
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate lazy var _arrowButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.contentMode = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showReportButton), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        
        return button
    }()
    
    fileprivate lazy var _reportButton: SoftlyRoundedButton = {
        let button = SoftlyRoundedButton()
        
        button.setTitle("Report", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToReportViewController), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var _postLabel: ExpandableLabel = {
        let label = ExpandableLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate lazy var _timestampLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customGreen
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    fileprivate lazy var _postButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var postLabel: ExpandableLabel {
        return _postLabel
    }
    
    var postButton: UIButton {
        return _postButton
    }
    
    var delegate: ExpandableCellDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var post: Post? {
        didSet {
            if let post = post {
                configureCell(post: post)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupPostImageView()
        setupUserNameLabel()
        setupArrowButton()
        setupPostLabel()
        setupTimestampLabel()
        setupPostButton()
        setupReportButton()
        
        _reportButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _postImageView.image = nil
        _userNameLabel.text = nil
        _postLabel.text = nil
    }
    
    private func configureCell(post: Post) {
        DataService.instance.getUserData(userId: post.userId) { userData in
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else {
                    return 
                }
                
                guard let userData = userData else {
                    return
                }
                
                strongSelf._postImageView.loadImageUsingCacheWithUrlString(userData["imageUrl"] as! String)
                strongSelf._userNameLabel.text = (userData["userName"] as! String)
                strongSelf._postLabel.text = post.postDesc
                strongSelf._timestampLabel.text = post.date
            }
        }
    }
}

// MARK: - SetupUI

extension ExpandableCell {
    
    fileprivate func setupPostImageView() {
        addSubview(_postImageView)
        
        //x,y,w,h
        _postImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        _postImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        _postImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        _postImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    fileprivate func setupUserNameLabel() {
        addSubview(_userNameLabel)
        
        //x,y,w,h
        _userNameLabel.leftAnchor.constraint(equalTo: _postImageView.rightAnchor, constant: 5).isActive = true
        _userNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        _userNameLabel.topAnchor.constraint(equalTo: _postImageView.topAnchor).isActive = true
        _userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    fileprivate func setupArrowButton() {
        addSubview(_arrowButton)
        
        //x,y,w,h
        _arrowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        _arrowButton.topAnchor.constraint(equalTo: _userNameLabel.topAnchor).isActive = true
        _arrowButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        _arrowButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    fileprivate func setupPostLabel() {
        let height = _postLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        let bottom = _postLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        
        addSubview(_postLabel)
        
        //x,y,w,h
        _postLabel.leftAnchor.constraint(equalTo: _userNameLabel.leftAnchor).isActive = true
        _postLabel.topAnchor.constraint(equalTo: _userNameLabel.bottomAnchor).isActive = true
        _postLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        height.priority = 1000
        height.isActive = true
        bottom.priority = 999
        bottom.isActive = true
    }
    
    fileprivate func setupTimestampLabel() {
        addSubview(_timestampLabel)
        
        //x,y,w,h
        _timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        _timestampLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    fileprivate func setupPostButton() {
        addSubview(_postButton)
        
        //x,y,w,h
        _postButton.leftAnchor.constraint(equalTo: _postLabel.leftAnchor).isActive = true
        _postButton.rightAnchor.constraint(equalTo: _postLabel.rightAnchor).isActive = true
        _postButton.topAnchor.constraint(equalTo: _postLabel.topAnchor).isActive = true
        _postButton.bottomAnchor.constraint(equalTo: _postLabel.bottomAnchor).isActive = true
    }
    
    fileprivate func setupReportButton() {
        addSubview(_reportButton)
        
        //x,y,w,h
        _reportButton.rightAnchor.constraint(equalTo: _arrowButton.rightAnchor).isActive = true
        _reportButton.topAnchor.constraint(equalTo: _arrowButton.bottomAnchor, constant: 20).isActive = true
        _reportButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        _reportButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
}

// MARK: - Selectors

extension ExpandableCell {
    
    func showReportButton() {
        _reportButton.isHidden = !_isReportButtonHidden
        _isReportButtonHidden = !_isReportButtonHidden
    }
    
    func goToReportViewController() {
        let reportViewController = ReportViewController()
        
        reportViewController.postId = post?.postId
        _delegate?.present(navigationController: UINavigationController(rootViewController: reportViewController))
    }
    
}


















