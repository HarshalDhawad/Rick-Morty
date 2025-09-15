//
//  SearchView.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 12/09/25.
//

import UIKit

class SearchView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let imageView = UIImageView()
    let songLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        layer.cornerRadius = 10
        layer.masksToBounds = true

        stackView.axis = .horizontal
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(songLabel)
        stackView.spacing = 10
        stackView.alignment = .center // Align items vertically in the center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        songLabel.font = .systemFont(ofSize: 14, weight: .bold)
        songLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
    
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
