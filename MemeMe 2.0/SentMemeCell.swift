//
//  SentMemeCell.swift
//  MemeMe 2.0
//
//  Created by Abidi on 10/15/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class SentMemeCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    func setText(topText: String, bottomText: String) {
        self.topText.text = topText
        self.bottomText.text = bottomText
    }
}
