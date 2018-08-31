//
//  GridyIconButton.swift
//  Gridy
//
//  Created by Carl Wainwright on 31/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import UIKit

class GridyIconButton: UIButton {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var gridyImageView: UIImageView!
    
    @IBOutlet weak var griduLabelView: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//        let buttonWidth = 120
//        let buttonHeight = 100
//
//        self.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
//
//
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gridyButtonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gridyButtonInit()
    }
    
    private func gridyButtonInit() {

        Bundle.main.loadNibNamed("GridyIconButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        

    }

    
    


}
