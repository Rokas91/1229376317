//
//  BuzzViewController.swift
//  my-vilnius
//
//  Created by Rokas on 23/02/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import Firebase
import UIKit

class BuzzViewController: UIViewController {
    
    // MARK: - Properties
    
    private var _timer: Timer?
    private var _hasEntered = false
    fileprivate var _filteredPosts: [Post] = []
    fileprivate var _inSearchMode = false
    fileprivate var _states: [Bool]? = []
    fileprivate let _shared = DataService.instance
    
    fileprivate lazy var _addPostButton: UIBarButtonItem = {
        let addPostButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(performAddPostVC))
        
        return addPostButton
    }()
    
    fileprivate lazy var _cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(title: CANCEL, style: .plain, target: self, action: #selector(cancel))
        
        return cancelButton
    }()
    
    fileprivate lazy var _tableView: UITableView = {
        let tableView = UITableView()
        let tabBarHeight = (UIApplication.shared.delegate as! AppDelegate).tabBarHeight
        let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, tabBarHeight, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.contentInset = adjustForTabbarInsets
        tableView.scrollIndicatorInsets = adjustForTabbarInsets
        tableView.register(ExpandableCell.self, forCellReuseIdentifier: EXPANDABLE_CELL_ID)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    fileprivate lazy var _searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        
        searchBar.delegate = self
        searchBar.placeholder = SEARCH
        searchBar.autocapitalizationType = .none
        searchBar.setTextColor(color: .darkGray)
        UIView.removeClearButton(svs: searchBar.subviews)
        
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _hasEntered = true
        view.addSubview(_tableView)
        navigationItem.titleView = _searchBar
        navigationItem.rightBarButtonItem = _addPostButton
        
        _shared.observePosts {
            self.scheduleTimer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !_hasEntered {
            scheduleTimer()
        }
        _hasEntered = false
    }
    
    private func scheduleTimer() {
        _timer?.invalidate()
        _timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(reloadTableView), userInfo: nil, repeats: false)
    }
    
    // MARK: - Selectors
    
    func handleLabel(_ sender: UIButton) {
        let point: CGPoint = sender.convert(.zero, to: _tableView)
        if let indexPath = _tableView.indexPathForRow(at: point) {
            if let cell = _tableView.cellForRow(at: indexPath) as? ExpandableCell {
                if var states = _states {
                    _tableView.beginUpdates()
                    if(!states[indexPath.row]) {
                        cell.postLabel.numberOfLines = 0
                        self._states?[indexPath.row] = true
                    } else {
                        cell.postLabel.numberOfLines = 3
                        self._states?[indexPath.row] = false
                    }
                    _tableView.endUpdates()
                }
            }
        }
    }
    
    func performAddPostVC() {
        let makePostViewController = UINavigationController(rootViewController: MakePostViewController())
        present(makePostViewController, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async{ [weak self] in
            guard let strongSelf = self else { 
                return 
            }
            strongSelf._shared.posts = strongSelf._shared.posts.sorted(by: { $0.timestamp > $1.timestamp })
            strongSelf._states = [Bool](repeating: false, count: strongSelf._shared.posts.count)
            strongSelf._tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BuzzViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _inSearchMode {
            return _filteredPosts.count
        }
        return _shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post: Post?
        
        if _inSearchMode {
            post = _filteredPosts[indexPath.row]
        } else {
            post = _shared.posts[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: EXPANDABLE_CELL_ID) as? ExpandableCell {
            cell.delegate = self
            cell.postButton.addTarget(self, action: #selector(handleLabel(_:)), for: .touchUpInside)
            cell.postLabel.numberOfLines = 3
            cell.postLabel.sizeToFit()
            cell.post = post
            return cell
        } 
        
        let cell = ExpandableCell()
        cell.delegate = self
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: - UISearchBarDelegate

extension BuzzViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func cancel() {
        _searchBar.text = nil
        _searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = _cancelButton
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = _addPostButton
        if let text = searchBar.text {
            _inSearchMode = !text.isEmpty
        } else {
            _inSearchMode = false
        }
        _tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || (searchBar.text?.isEmpty)! {
            _inSearchMode = false
        } else {
            _inSearchMode = true
            let lower = searchBar.text!.lowercased()
            _filteredPosts = _shared.posts.filter({ post -> Bool in
                return post.postDesc.lowercased().range(of: lower) != nil || post.userName.lowercased().range(of: lower) != nil
            })
        }
        _tableView.reloadData()
    }
}


// MARK: - ExpandableCellDelegate

extension BuzzViewController: ExpandableCellDelegate {
    
    func present(navigationController: UINavigationController) {
        present(navigationController, animated: true)
    }
    
}












