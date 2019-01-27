//
//  ViewController.swift
//  Instafilter
//
//  Created by Brian Sipple on 1/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!
    
    var imageFilterContext: CIContext!
    var currentImageFilter: CIFilter!
    
    var currentImage: UIImage! {
        didSet {
            imageView.image = self.currentImage
            intensitySlider.isEnabled = true
            currentImageFilter.setValue(CIImage(image: self.currentImage), forKey: kCIInputImageKey)
        }
    }
    
    var currentImageFilterName = "" {
        didSet {
            currentImageFilter = CIFilter(name: self.currentImageFilterName)
            
            if let currentImage = currentImage {
                currentImageFilter.setValue(CIImage(image: currentImage), forKey: kCIInputImageKey)
                applyImageProcessing()
            }
        }
    }
    
    var currentFilterKeyAndValue: (key: String, value: Any)? {
        return _currentFilterKeyAndValue()
    }
    
    lazy var filterChoiceActions = _makeFilterChoiceActions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 🔑 Creating a CIContext is expensive, so create one during your initial setup and reuse it throughout your app.
        imageFilterContext = CIContext()
        
        currentImageFilterName = "CISepiaTone"
        setupUI()
    }
    
    
    func setupUI() {
        title = "The Best Image Filter"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
        
        intensitySlider.isEnabled = false
    }
    

    @objc func importPicture() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        currentImage = image
        applyImageProcessing()
        
        dismiss(animated: true)
    }
    
    func applyImageProcessing() {
        guard let (filterKey, value) = currentFilterKeyAndValue else { return }
        
        currentImageFilter.setValue(value, forKey: filterKey)
                
        if let cgImage = imageFilterContext.createCGImage(
            currentImageFilter.outputImage!,
            from: currentImageFilter.outputImage!.extent
        ) {
            let processedImage = UIImage(cgImage: cgImage)
            
            currentImage = processedImage
        }
    }
    
    func setFilter(action: UIAlertAction) {
        currentImageFilterName = action.title!
    }

    
    @IBAction func changeFilter(_ sender: Any) {
        let controller = UIAlertController(title: "Choose a Filter", message: nil, preferredStyle: .actionSheet)
        
        for action in filterChoiceActions {
            controller.addAction(action)
        }
        
        present(controller, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyImageProcessing()
    }
    
    
    func _makeFilterChoiceActions() -> [UIAlertAction] {
        var actions = [
            "CIBumpDistortion",
            "CIGaussianBlur",
            "CIPixellate",
            "CIMotionBlur",
            "CISepiaTone",
            "CITwirlDistortion",
            "CIUnsharpMask",
            "CIVignette",
        ].map({ UIAlertAction(title: $0, style: .default, handler: setFilter) })
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: setFilter))
        
        return actions
    }
    
    func _currentFilterKeyAndValue() -> (key: String, value: Any)? {
        let inputKeys = currentImageFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            return (kCIInputIntensityKey, intensitySlider.value)
            
        } else if inputKeys.contains(kCIInputRadiusKey) {
            return (kCIInputRadiusKey, intensitySlider.value * 200)
            
        } else if inputKeys.contains(kCIInputScaleKey) {
            return (kCIInputScaleKey, intensitySlider.value * 10)
            
        } else if inputKeys.contains(kCIInputCenterKey) {
            let vector = CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2)
            return (kCIInputCenterKey, vector)
        }
        
        return nil
    }
}

