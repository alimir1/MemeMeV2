//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Abidi on 10/15/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }
}
