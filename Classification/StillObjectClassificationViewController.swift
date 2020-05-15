//
//  StillObjectClassificationViewController.swift
//  Classification
//
//  Created by artyom korotkov on 5/12/20.
//  Copyright © 2020 artyom korotkov. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class StillObjectClassificationViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        return imageView
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        button.imageView?.tintColor = .white
        return button
    }()
    
    let classificationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Add photo"
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        view.addSubview(imageView)
        view.addSubview(cameraButton)
        view.addSubview(classificationLabel)
        view.addSubview(closeButton)
        
        imageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(70)
            make.left.right.equalToSuperview()
        }
        
        classificationLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        cameraButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(classificationLabel)
            make.width.height.equalTo(30)
            make.left.equalToSuperview().inset(10)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.width.equalTo(20)
        }
    }
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: Model().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassification = classifications[0]
                let description = String(format: "(%.2f) %@", topClassification.confidence, topClassification.identifier)
                self.classificationLabel.text = description
            }
        }
    }
    
    // MARK: - Photo Actions
    
    @objc func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension StillObjectClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            updateClassifications(for: image)
        }
    }
}
