//
//  ViewController.swift
//  Doughnut or Bagel?
//
//  Created by Charles Martin Reed on 1/7/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doughnutConfidenceLabel: UILabel!
    @IBOutlet weak var bageConfidenceLabel: UILabel!
    
    //MARK:- Properties
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doughnutConfidenceLabel.text = "0%"
        bageConfidenceLabel.text = "0%"
        picker.delegate = self
        
    }

    //MARK:- IBActions
    @IBAction func choosePhotoTapped(_ sender: UIBarButtonItem) {
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func processImage(image: UIImage) {
        //create a vision coreML model
        if let model = try? VNCoreMLModel(for: BagelOrDoughnutClassifier().model) {
            //make a request to that model to check out the image
            let request = VNCoreMLRequest(model: model) { (req, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    if let results = req.results as? [VNClassificationObservation] {
                        
                        results.forEach({ (obs) in
                            switch obs.identifier {
                            case "bagels":
                                let resultRounded = Int((obs.confidence * 100).rounded())
                                self.bageConfidenceLabel.text = "\(resultRounded)%"
                            case "doughnuts":
                                let resultRounded = Int((obs.confidence * 100).rounded())
                                self.doughnutConfidenceLabel.text = "\(resultRounded)%"
                            default:
                                break
                            }
                        })
                    }
                }
            }
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    //use the image with our request
                    let handler = VNImageRequestHandler(data: imageData, options: [:])
                    try? handler.perform([request])
            }
        }
    }
}

extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //we need to turn the chosen item into a photo
        if let image = info[.originalImage] as? UIImage {
            //display the image and then process it so we can update the prediction labels
            imageView.image = image
            processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController : UINavigationControllerDelegate {
    
}

