//
//  ViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 24/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    fileprivate var mainFlowController: MainFlowController!
    //Array of local images
    fileprivate let localImages: [UIImage] = [UIImage(named: "Wands")!, UIImage(named: "Plant")!, UIImage(named: "Orangutan")!, UIImage(named: "Dobby")!, UIImage(named: "Frog")!]

    @IBOutlet weak var testPhoto: UIImageView!
    @IBOutlet weak var gridyPick: GridyIconButton!
    @IBOutlet weak var cameraSelect: GridyIconButton!
    @IBOutlet weak var photoLibrarySelect: GridyIconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        PickButton.setImage(UIImage(named:"Gridy-name-small-grey"), for: .normal)
        gridyPick.gridyLabelView.text = "Pick"
        gridyPick.gridyImageView.image = UIImage(named: "Gridy-name-small-grey")
        photoLibrarySelect.gridyLabelView.text = "Photo Library"
        photoLibrarySelect.gridyImageView.image = UIImage(named: "Gridy-library")
        cameraSelect.gridyLabelView.text = "Camera"
        cameraSelect.gridyImageView.image = UIImage(named: "Gridy-camera")
    }
    
    @IBAction func gridyPick(_ sender: GridyIconButton) {
        //call pickRandom Func
        pickRandom()
    }
    @IBAction func cameraSelect(_ sender: GridyIconButton) {
        displayCamera()
    }
    @IBAction func photoLibrarySelect(_ sender: GridyIconButton) {
        displayLibrary()
    }
    func assignDependancies(mainFlowController: MainFlowController) {
        self.mainFlowController = mainFlowController
    }
    //enable use of camera
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Gridy does not have access to your camera. To enable, please go to Settings -> Gridy and enable Camera"
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Gridy is unable to access your camera at this time.")
        }
    }
    //enable use of photo library
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Gridy does not have access to your Photo Library. To enable, please go to Settings -> Gridy and enable Photos"
            switch status {
            case.notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    }
                    else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
                print ("Photo Library authorized")
            case . denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Gridy is unable to access your PhortoLibrary at this time")
        }
    }
    func pickRandom() {
        //run randomImage Func
        processPicked(image: randomImage())
    }
    func randomImage() -> UIImage? {
        //random number from count or local images
        let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
        //gets random local image
        let newImage = localImages[randomIndex]
        return newImage
    }
    //show images from camera/library
    func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    //push image picked in camera/library to newImage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        print ("imagePickerController")
        picker.dismiss(animated: true, completion: nil)
        let newImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        processPicked(image: newImage)
    }
    //Error box if unable to access camera or library
    func troubleAlert(message: String?){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    //Set image chosen and push to next screen
    func processPicked(image: UIImage?) {
        if let photo = image {
            mainFlowController.showImageEditor(with: photo)
            }
        }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
