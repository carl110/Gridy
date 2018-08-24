//
//  ViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 24/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let button = GridyMainButton()

    @IBOutlet weak var pickGridyPhoto: GridyMainButton!
    @IBOutlet weak var pickPhotoLibrary: GridyMainButton!
    @IBOutlet weak var pickCameraForPhoto: GridyMainButton!
    
    @IBAction func pickGridyPhoto(_ sender: GridyMainButton) {
    }
    @IBAction func pickPhotLibrary(_ sender: GridyMainButton) {
    }
    @IBAction func pickCamerPhoto(_ sender: GridyMainButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        PickButton.setImage(UIImage(named:"Gridy-name-small-grey"), for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

