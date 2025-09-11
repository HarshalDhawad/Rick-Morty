//
//  MostPopularView.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 29/08/25.
//

import Foundation
import UIKit
class MostPopularView: UICollectionViewCell {
    
    static let reuseIdentifier = "MostPopularView"
    let imageView = UIImageView()
    let songLabel = UILabel()
    let songSecondaryLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true

        stackView.axis = .vertical
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(songLabel)
        stackView.addArrangedSubview(songSecondaryLabel)
        stackView.spacing = 5
        stackView.alignment = .leading  // Align items vertically in the center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 5
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        songLabel.font = .systemFont(ofSize: 18, weight: .bold)
        songLabel.textColor = .white
        songSecondaryLabel.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
