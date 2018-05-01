//
//  AddTextViewController.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-30.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit
import Hero

class AddTextViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: BigEditableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var image = UIImage()
    var backgroundImage = UIImage()
    var meme = Meme()
    
    //MARK: - View controller specifics
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        backgroundImageView.image = backgroundImage
        textView.placeholder = "Write here"
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    //MARK: - Actions
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let text = textView.textView.text!
        
        if text != "" {
             StorageHandler.getInstance().saveMemeText(memeId: meme.id, text: text)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Keyboard notifications
extension AddTextViewController  {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            scrollView.bounces = true
            var scrollRect = self.view.frame
            scrollRect.size.height -= keyboardHeight
            if textView.textView.isFirstResponder {
                let frameWithOffset = CGRect(x: textView.frame.minX,
                                             y: textView.frame.minY + 8,
                                             width: textView.frame.width,
                                             height: textView.frame.height)
                if !scrollRect.contains(CGPoint(x: textView.frame.origin.x, y: textView.frame.maxY + 16)) {
                    scrollView.scrollRectToVisible(frameWithOffset, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight, right: 0)
            scrollView.bounces = true
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            scrollView.becomeFirstResponder()
            scrollView.isScrollEnabled = true
        }
    }
}
