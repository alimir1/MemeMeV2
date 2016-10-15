//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by Abidi on 10/15/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    var memes: [Meme] {
        // Do any additional setup after loading the view.
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemeCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailVC") as! MemeDetailViewController
        memeDetailController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(memeDetailController, animated: true)
    }
}
