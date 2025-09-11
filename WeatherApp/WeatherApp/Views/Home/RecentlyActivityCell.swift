//
//  RecentlyActivityCell.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 29/08/25.
//

import Foundation
import UIKit

class RecentlyActivityCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecentlyActivityCell"
    let imageView = UIImageView()
    let songLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .init(white: 0.2, alpha: 0.9)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        stackView.axis = .horizontal
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(songLabel)
        stackView.spacing = 10
        stackView.alignment = .center // Align items vertically in the center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        songLabel.font = .systemFont(ofSize: 14, weight: .bold)
        songLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
