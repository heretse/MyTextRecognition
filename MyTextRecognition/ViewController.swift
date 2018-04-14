//
//  ViewController.swift
//  MyTextRecognition
//
//  Created by Winston Hsieh on 20/02/2018.
//  Copyright © 2018 Winston Hsieh. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        
        view.endEditing(true)
        presentOptions()
    }
    
    func presentOptions() {
        
        let imageActionController = UIAlertController(title: "Take photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            print("Camera selected")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Choose Existing", style: .default) { (action) in
            print("Library")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        imageActionController.addAction(cameraAction)
        imageActionController.addAction(libraryAction)
        imageActionController.addAction(cancelAction)
        
        self.present(imageActionController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let scaledPhoto = selectedImage.scaleImage(640)
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            dismiss(animated: true, completion: {
                
                print("start recognizing image")
                
                //recognize the image
                self.recognizeText(image: scaledPhoto!)
            })
            
        }
        
    }
    
    func recognizeText(image: UIImage) {
        
        if let tessaract = G8Tesseract(language: "eng") {
            
            tessaract.engineMode = .tesseractCubeCombined
            tessaract.pageSegmentationMode = .auto
            tessaract.image = image.g8_blackAndWhite()
            tessaract.recognize()
            
            textView.text = tessaract.recognizedText
        }
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

extension UIImage {
    
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            
            let scaleFactor = size.height / size.width
            
            scaledSize.height = scaledSize.width * scaleFactor
            
        } else {
            
            let scaleFactor = size.width / size.height

            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

