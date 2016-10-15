//
//  SentMemesCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Ali Mir on 10/11/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

final class SentMemesCollectionViewController: UICollectionViewController {
        
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    fileprivate let reuseIdentifier = "sentMemeCell"
    fileprivate var memes: [Meme] {
        // Do any additional setup after loading the view.
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
     }
    
    func reloadTableData(_ notification: Notification) {
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemeCell
        let meme = memes[indexPath.row]
        
        cell.imageView.image = meme.originalImage
        cell.setText(topText: meme.topText, bottomText: meme.bottomText)
        
        return cell
    }
    
    // MARK: Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailVC") as! MemeDetailViewController
        memeDetailController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailController, animated: true)
    }
}
