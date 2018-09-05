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

class ViewController: UIViewController {
    
    let viewModel = MainViewModel()
    fileprivate var mainFlowController: MainFlowController!
    let localImages = [UIImage].init()

    
    @IBOutlet weak var gridyPick: GridyIconButton!
    @IBOutlet weak var cameraSelect: GridyIconButton!
    @IBOutlet weak var photoLibrarySelect: GridyIconButton!
    
    @IBAction func gridyPick(_ sender: GridyIconButton) {
        
        //mainFlowController.showImageEditor(with: UIImage(named: "Frog")!)

    }
    
    @IBAction func cameraSelect(_ sender: GridyIconButton) {
        displayCamera()
    }
    
    @IBAction func photoLibrarySelect(_ sender: GridyIconButton) {
        displayLibrary()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        PickButton.setImage(UIImage(named:"Gridy-name-small-grey"), for: .normal)
        gridyPick.griduLabelView.text = "Pick"
        gridyPick.gridyImageView.image = UIImage(named: "Gridy-name-small-grey")
        photoLibrarySelect.griduLabelView.text = "Photo Library"
        photoLibrarySelect.gridyImageView.image = UIImage(named: "Gridy-library")
        cameraSelect.griduLabelView.text = "Camera"
        cameraSelect.gridyImageView.image = UIImage(named: "Gridy-camera")
        gridyPick.mainButton(radius: 8)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignDependancies(mainFlowController: MainFlowController) {
        self.mainFlowController = mainFlowController
    }
    
//    @IBAction func pickGridyPhoto(_ sender: GridyMainButton) {
//
//    }
//    @IBAction func pickPhotLibrary(_ sender: GridyMainButton) {
//        displayLibrary()
//    }
//    @IBAction func pickCamerPhoto(_ sender: GridyMainButton) {
//        displayCamera()
//    }
//
    func displayCamera() {
        let sourceType = UIImagePickerControllerSourceType.camera
        
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
    
    func displayLibrary() {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        
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
            case . denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Gridy is unable to access your PhortoLibrary at this time")
        }

    }
    
    func randomImage() -> UIImage? {
        if localImages.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                return newImage
            }
        else {
            return nil
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        
//    }
    
    
    func troubleAlert(message: String?){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
        
    }

    
    

}

