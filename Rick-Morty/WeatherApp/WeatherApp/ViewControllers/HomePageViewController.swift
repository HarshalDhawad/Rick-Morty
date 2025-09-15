//
//  HomePageViewController.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 29/08/25.
//

import Foundation
import Apollo
import WeatherAppAPI
import UIKit
import Kingfisher

enum Section {
    case recentActivity
    case mostPopular
    case topHits
}
enum Item: Hashable {
    case recentActivityCard(image: String, label: String)
    case mostPopularCard(image: String, label: String, desc: String)
}

class HomePageViewController: UIViewController {
    
    var imageData: [CharactersQuery.Data.Characters.Result?] = []
    var indexPath: IndexPath?
    var fractionalWidth: Float = 0.5
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the setup methods
//        configureCollectionView()
//        configureDataSource()
    }
    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .black
        configureCollectionView()
        configureDataSource()
        Network.shared.apollo.fetch(query: CharactersQuery()) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let graphQLResult):
                if let rickAndMorty = graphQLResult.data?.characters {
                    self.imageData = rickAndMorty.results!
                    DispatchQueue.main.async {
                        self.applyInitialSnapshot()
                    }
                }
                if let errors = graphQLResult.errors {
//                    self.appAlert = .errors(errors: errors)
                    print("error .\(errors)")
                }
            case .failure(let error):
//                self.appAlert = .errors(errors: [error])
                print("error\(error)")
            }
        }
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.clipsToBounds = true
        view.addSubview(collectionView)
        
        // Register the custom cells with their reuse identifiers
        collectionView.register(RecentlyActivityCell.self, forCellWithReuseIdentifier: RecentlyActivityCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(MostPopularView.self, forCellWithReuseIdentifier: MostPopularView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionKind = self.datasource.snapshot().sectionIdentifiers[sectionIndex]
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            switch sectionKind {
            case .recentActivity:
                if UIDevice.current.orientation.isLandscape {
                    self.fractionalWidth = 0.3
                } else {
                    self.fractionalWidth = 0.5
                }
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(self.fractionalWidth)), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [header]
                section.interGroupSpacing = 10
                return section
            case .mostPopular, .topHits:
                if UIDevice.current.orientation.isLandscape {
                    self.fractionalWidth = 0.25
                } else {
                    self.fractionalWidth = 0.5
                }
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(self.fractionalWidth)), heightDimension: .absolute(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 40, trailing: 10)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
        return layout
    }
    func configureDataSource(){
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView){(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            let section = self.datasource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .recentActivity:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyActivityCell.reuseIdentifier, for: indexPath) as? RecentlyActivityCell else { return nil }
                if case .recentActivityCard(let url, let label) = item {
                    cell.songLabel.text = label
                    if let imageUrl = URL(string: url) {
                        cell.imageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
                        cell.isUserInteractionEnabled = true
                        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_: )))
                        cell.addGestureRecognizer(tapGestureRecog)
                    }
                }
                return cell
                
            case .mostPopular, .topHits:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostPopularView.reuseIdentifier, for: indexPath) as? MostPopularView else { return nil }
                if case .mostPopularCard(let url, let label, let desc) = item {
                    cell.songLabel.text = label
                    cell.songSecondaryLabel.text = desc
                    if let imageUrl = URL(string: url) {
                        cell.imageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
                        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_: )))
                        cell.addGestureRecognizer(tapGestureRecog)
                    }
                }
                return cell
            }
        }
        datasource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else { return nil }
            
            let section = self.datasource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .recentActivity:
                headerView.titleLabel.text = "Recent Activity"
            case .mostPopular:
                headerView.titleLabel.text = "Most Popular"
            case .topHits:
                headerView.titleLabel.text = "Top Hits"
            }
            return headerView
        }
    }
    
    @objc
    func handleTap(_ recogniser: UITapGestureRecognizer) {
        guard let tappedView = recogniser.view else {return}
        if let image = tappedView.subviews.first?.subviews.first?.subviews.first {
            let detailViewController = DetailViewController(image: image)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func applyInitialSnapshot(){
        
        guard !imageData.isEmpty else {
            return
        }
        
        var snapshots = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshots.appendSections([.recentActivity, .mostPopular, .topHits])
        

        var items: [Item] = []
        for (index, image) in imageData.enumerated() {
            if index > 5 {
                break
            }
            guard let imageName = image?.name else {
                return
            }
            let label = "\(imageName)"
            if let urlString = image?.image {
                items.append(.recentActivityCard(image: urlString, label: label))
            }
            
        }
        snapshots.appendItems(items, toSection: .recentActivity)
        
        var popularItems: [Item] = []
        for(index, image) in imageData.enumerated() {
            guard let imageName = image?.name else {
                return
            }
            let label = "\(imageName)"
            let desc = "\(index).Single  \(imageName)"
            if let urlString = image?.image {
                popularItems.append(.mostPopularCard(image: urlString, label: label, desc: desc))
            }
        }
        snapshots.appendItems(popularItems, toSection: .mostPopular)
        
        var topHitsItems: [Item] = []
        for(index, image) in imageData.enumerated() {
            guard let imageName = image?.name else {
                return
            }
            let label = "\(imageName)"
            let desc = "\(index).Single - topImages \(imageName)"
            if let urlString = image?.image {
                topHitsItems.append(.mostPopularCard(image: urlString, label: label, desc: desc))
            }
        }
        snapshots.appendItems(topHitsItems, toSection: .topHits)

        self.datasource.apply(snapshots, animatingDifferences: false)
    }
}
