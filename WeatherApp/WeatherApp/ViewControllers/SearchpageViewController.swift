//
//  SearchpageViewController.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 10/09/25.
//

import Foundation
import UIKit


class SearchpageViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private var commentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Results"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private var commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private var commentBoxContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        return view
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
        textView.isScrollEnabled = false // Initially, not scrollable
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 18
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var commentBoxBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        setupUI()
        setupKeyboardObeserver()
    }
    
    func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(commentView)
        commentView.addSubview(commentLabel)
        commentView.addSubview(commentsStackView)
        view.addSubview(commentBoxContainer)
        commentBoxContainer.addSubview(textView)
        commentBoxContainer.addSubview(button)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: commentBoxContainer.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            commentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            commentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            commentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            commentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
//        let articleContent = UILabel()
//        articleContent.text = "This is a placeholder for your main content. In a real application, this would be an article, a news feed, or a user profile. The goal is to show how the comment box dynamically moves to stay visible above the keyboard when a user starts typing."
//        articleContent.numberOfLines = 0
//        articleContent.translatesAutoresizingMaskIntoConstraints = false
//        commentView.addSubview(articleContent)
        
        NSLayoutConstraint.activate([
//            articleContent.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 20),
//            articleContent.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 20),
//            articleContent.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -20),
//            
//            commentLabel.topAnchor.constraint(equalTo: articleContent.bottomAnchor, constant: 20),
            commentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            commentLabel.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -20),
            
            commentsStackView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 20),
            commentsStackView.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 20),
            commentsStackView.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -20),
            commentsStackView.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: -20)
        ])
        
        commentBoxBottomConstraint = commentBoxContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            commentBoxContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentBoxContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentBoxBottomConstraint,
            
            textView.topAnchor.constraint(equalTo: commentBoxContainer.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: commentBoxContainer.leadingAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: commentBoxContainer.bottomAnchor, constant: -10),
            
            button.heightAnchor.constraint(equalToConstant: 36),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: commentBoxContainer.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            button.topAnchor.constraint(greaterThanOrEqualTo: commentBoxContainer.topAnchor, constant: 10)
        ])
    }
    
    func setupKeyboardObeserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey
              ] as? TimeInterval else {
            return
        }
        
        commentBoxBottomConstraint.constant = -keyboardFrame.height + view.safeAreaInsets.bottom
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                  return
              }
        commentBoxBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

}


