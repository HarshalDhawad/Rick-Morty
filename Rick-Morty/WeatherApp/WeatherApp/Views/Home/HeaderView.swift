//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 10/09/25.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    
    // A static property for the reuse identifier is a good practice
    static let reuseIdentifier = "headerView"
    
    // The title label to display the header text
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false // Must be set to false for Auto Layout
        return label
    }()
    
    // The designated initializer for programmatically created views
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add the title label to the header view
        addSubview(titleLabel)
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Required initializer for views loaded from a storyboard or xib
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Resets the view to its default state before it's reused
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
