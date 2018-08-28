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
    

    @IBOutlet weak var pickGridyPhoto: GridyMainButton!
    @IBOutlet weak var pickPhotoLibrary: GridyMainButton!
    @IBOutlet weak var pickCameraForPhoto: GridyMainButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        PickButton.setImage(UIImage(named:"Gridy-name-small-grey"), for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickGridyPhoto(_ sender: GridyMainButton) {

    }
    @IBAction func pickPhotLibrary(_ sender: GridyMainButton) {
        displayLibrary()
    }
    @IBAction func pickCamerPhoto(_ sender: GridyMainButton) {
        displayCamera()
    }
    
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
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        //        present(imagePicker, animated: true, completion: nil)
    }
    
    func troubleAlert(message: String?){
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
        
    }

    

}

