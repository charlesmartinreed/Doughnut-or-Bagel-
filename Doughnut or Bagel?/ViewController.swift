//
//  ViewController.swift
//  Doughnut or Bagel?
//
//  Created by Charles Martin Reed on 1/7/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doughnutConfidenceLabel: UILabel!
    @IBOutlet weak var bageConfidenceLabel: UILabel!
    
    //MARK:- Properties
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
    }

    //MARK:- IBActions
    @IBAction func choosePhotoTapped(_ sender: UIBarButtonItem) {
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func processImage(image: UIImage) {
        print("processing image!")
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

