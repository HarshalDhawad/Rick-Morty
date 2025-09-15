//
//  SearchpageViewController.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 10/09/25.
//

import Foundation
import UIKit
import Apollo
import WeatherAppAPI
import Kingfisher


class SearchpageViewController: UIViewController {

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

    private var textView: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .black
        textView.placeholder = "Search"
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
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
    var collectionView: UICollectionView!
    var data: [GetSearchQuery.Data.Characters.Result?] = []
    var searchText: String = ""
    let debouncer = Debouncer(delay: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        textView.addTarget(self, action: #selector(changeTextField(_:)), for: .editingChanged)
        button.addTarget(self, action: #selector(searchButton), for: .touchUpInside)
        performFetch(name: "")
    }
    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(true)
        setupUI()
        setupKeyboardObeserver()
    }
    func performFetch(name: String) {

        let filter = FilterCharacter(name: .some(name))
        let querry = GetSearchQuery(filter: .some(filter))
        
        SearchNetwork.shared.searchApollo.fetch(query: querry) { [weak self] result in
            guard let self else {
                return
            }

            switch result {
            case .success(let graphqlResult):
                if let searchQuerry = graphqlResult.data?.characters {
                    self.data = searchQuerry.results!
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.button.backgroundColor = .blue
                    }
                }
            case .failure(_):
                print("failure")
            }
        }
    }

    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing  = 5
        layout.itemSize = CGSize(width: view.bounds.size.width - 20, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addSubview(commentBoxContainer)
        commentBoxContainer.addSubview(textView)
        commentBoxContainer.addSubview(button)

        NSLayoutConstraint.activate([
  
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: commentBoxContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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

    @objc func changeTextField(_ textField: UITextField){
        guard let text = textField.text, !text.isEmpty else {
            debouncer.debounce {
                self.performFetch(name: "")
            }
            searchText = ""
            return
        }
        searchText = text
        debouncer.debounce {
            self.performFetch(name: text)
        }

    }

    @objc func searchButton() {
        button.backgroundColor = .gray
        performFetch(name: self.searchText)
    }
}
extension SearchpageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let searchView = SearchView()
        if let song = data[indexPath.row]?.name {
            searchView.songLabel.text = song
        }
        if let image = data[indexPath.row]?.image {
            searchView.imageView.kf.setImage(with: URL(string: image))
        }
        searchView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.imageView.heightAnchor.constraint(equalToConstant: cell.contentView.bounds.height),
            searchView.imageView.widthAnchor.constraint(equalToConstant: cell.contentView.bounds.height),
            
            searchView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDetailPage(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
            headerView.titleLabel.text = "Results"
            return headerView
        }
        return UICollectionReusableView()
    }

    @objc func openDetailPage(_ gesture: UITapGestureRecognizer) {
        if let image = gesture.view?.subviews.first?.subviews.first?.subviews.first{
            let detailPage = DetailViewController(image: image)
            navigationController?.pushViewController(detailPage, animated: true)
        }
    }
}



