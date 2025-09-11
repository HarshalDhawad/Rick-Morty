//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 11/09/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    let image: UIView

    init(image: UIView) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let roatateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        image.addGestureRecognizer(panGesture)
        image.addGestureRecognizer(pinchGesture)
        image.addGestureRecognizer(roatateGesture)
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            image.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    func handleTap(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let imageView = sender.view {
            imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        }
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc
    func handlePinch(_ sender: UIPinchGestureRecognizer) {
        if let pinkView = sender.view {
            pinkView.transform = pinkView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    @objc
    func handleRotate(_ sender: UIRotationGestureRecognizer) {
        if let pinkView = sender.view {
            pinkView.transform = pinkView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
