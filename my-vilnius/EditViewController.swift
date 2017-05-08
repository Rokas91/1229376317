//
//  EditViewController.swift
//  my-vilnius
//
//  Created by Rokas on 25/04/2017.
//  Copyright © 2017 Rokas. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate: class {
    
    var charactersCount:Int { get }
    var leavingWarning: String { get }
    var buttonTitle: String { get }
    
    func handleTap()
}

class EditViewController: UIViewController {
    
    fileprivate var _delegate: EditViewControllerDelegate?
    fileprivate var _placeholderLabel: UILabel?
    fileprivate let _shared = DataService.instance
    
    private lazy var _backButton: UIBarButtonItem = {
        let backButton = UIBarButtonItem(image: UIImage(named: "back")?.resizeImage(newHeight: self._navigationBarHeight * 0.6), style: .plain, target: self, action: #selector(goBack))
        
        return backButton
    }()
    
    fileprivate lazy var _navigationBarHeight: CGFloat = {
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            return navigationBarHeight
        }
        
        return 40
    }()
    
    fileprivate lazy var _textView: UITextView = {
        let textView = UITextView()
        
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.returnKeyType = .done
        textView.autocorrectionType = .no
        
        self._placeholderLabel = UILabel()
        self._placeholderLabel?.text = PLACEHOLDER_TEXT
        self._placeholderLabel?.font = .avenir
        self._placeholderLabel?.sizeToFit()
        self._placeholderLabel?.frame.origin = CGPoint(x: 5, y: UIFont.avenir.pointSize / 2)
        self._placeholderLabel?.textColor = UIColor(white: 0, alpha: 0.3)
        self._placeholderLabel?.isHidden = !textView.text.isEmpty
        
        if let placeholderLabel = self._placeholderLabel {        
            textView.addSubview(placeholderLabel)
        }
        
        return textView
    }()
    
    fileprivate lazy var _button: UIButton = {
        let button = UIButton()
        
        if let delegate = self._delegate {
            button.setTitle(delegate.buttonTitle, for: .normal)
        }
        button.backgroundColor = .customGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        
        return button
    }()
    
    var shared: DataService {
        return _shared
    }
    
    var delegate: EditViewControllerDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    var textView: UITextView {
        return _textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = _backButton
        setupButton()
        setupTextView()
    }
}

// MARK: - Selectors

extension EditViewController {
    
    func onTap() {
        _delegate?.handleTap()
    }
    
    func goBack() {
        if let text = _textView.text, !text.isEmpty {
            let yesAction = UIAlertAction(title: YES, style: .default, handler: { action in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { 
                        return
                    }
                    strongSelf.dismiss(animated: true)
                }
            })
            
            let noAction = UIAlertAction(title: NO, style: .default)
            
            if let delegate = _delegate {
                createAlert(title: WARNING, message: delegate.leavingWarning, actions: yesAction, noAction)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
}

// MARK: - SetupUI

extension EditViewController {
    
    fileprivate func setupTextView() {
        let margins = view.layoutMarginsGuide
        
        view.addSubview(_textView)
        
        //x,y,w,h
        _textView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        _textView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        _textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        _textView.bottomAnchor.constraint(equalTo: _button.topAnchor, constant: -20).isActive = true
    }
    
    fileprivate func setupButton() {
        let margins = view.layoutMarginsGuide
        
        view.addSubview(_button)
        
        //x,y,w,h
        _button.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        _button.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        _button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        _button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
}

// MARK: - UITextViewDelegate

extension EditViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text != "\n" else {
            textView.resignFirstResponder()
            return false
        }
        
        guard let delegate = _delegate, textView.text.characters.count < delegate.charactersCount  else {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        _placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    
}

// MARK: - Alerting

extension EditViewController: Alerting {}


// MARK: - KeyboardHandling

extension EditViewController: KeyboardHandling {
    
    func keyboardIsOn(keyboardSize: CGSize) {
        _button.isHidden = true
    }
    
    func keyboardIsOff() {
        _button.isHidden = false
    }
    
}

























