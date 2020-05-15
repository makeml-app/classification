//
//  ViewController.swift
//  Classification
//
//  Created by artyom korotkov on 5/12/20.
//  Copyright © 2020 artyom korotkov. All rights reserved.
//

import UIKit
import SnapKit

class ChooseRecognitionTypeViewController: UIViewController {

    lazy var stillImageRecognitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkGray
        button.setTitle("Still Object Classification", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(stillImageRecognitionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var liveImageRecognitionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkGray
        button.setTitle("Live Object Classification", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(liveImageRecognitionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSubviews()
    }
    
    func setupNavigationBar() {
        self.title = "Choose Type"
        self.navigationController?.navigationBar.barTintColor = .darkGray
    }
    
    func setupSubviews() {
        view.addSubview(stillImageRecognitionButton)
        view.addSubview(liveImageRecognitionButton)
        
        stillImageRecognitionButton.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.height.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-70)
        }
        
        liveImageRecognitionButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(stillImageRecognitionButton)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(70)
        }
    }
    
    @objc func stillImageRecognitionButtonPressed() {
        let stillClassificationVC = StillObjectClassificationViewController()
        stillClassificationVC.modalPresentationStyle = .fullScreen
        present(stillClassificationVC, animated: true)
    }

    @objc func liveImageRecognitionButtonPressed() {
        let liveClassificationVC = LiveObjectClassificationViewController()
        liveClassificationVC.modalPresentationStyle = .fullScreen
        present(liveClassificationVC, animated: true)
    }
}

