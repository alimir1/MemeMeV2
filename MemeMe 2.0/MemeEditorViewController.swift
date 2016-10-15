//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by Ali Mir on 10/11/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoAlbumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    let defaultTopText = "Top"
    let defaultBottomText = "Bottom"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        configureMemeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToObserverNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToObserverNotifications()
    }
    
    func saveMeme() {
        // create the meme
        memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        // add the meme to App delegate's meme instance
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        // reload data in collection view controller
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    
    func subscribeToObserverNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToObserverNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func configureMemeUI() {
        imagePickerView.image = nil
        imagePickerView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        configureTextFields(textFields: [topTextField, bottomTextField])
    }
    
    func configureTextFields(textFields: [UITextField]) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
            ] as [String : Any]
        
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
            if textField == topTextField {
                textField.text = defaultTopText
            } else if textField == bottomTextField {
                textField.text = defaultBottomText
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // move picture view when the keyboard shows
        if bottomTextField.isEditing {
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear default text when user starts typing
        if textField == topTextField {
            if topTextField.text == defaultTopText {
                topTextField.text = ""
            }
        } else if textField == bottomTextField {
            if bottomTextField.text == defaultBottomText {
                bottomTextField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if user leaves a text field empty, text field text displays default text
        if textField == topTextField {
            if topTextField.text == "" {
                topTextField.text = defaultTopText
            }
        } else if textField == bottomTextField {
            if bottomTextField.text == "" {
                bottomTextField.text = defaultBottomText
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        if sender as! UIBarButtonItem == cameraButton {
            pickAnImageFromSource(sourceType: .camera)
        } else if sender as! UIBarButtonItem == photoAlbumButton {
            pickAnImageFromSource(sourceType: .photoLibrary)
        }
    }
    
    func pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme() {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            (activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        configureMemeUI()
        shareButton.isEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

