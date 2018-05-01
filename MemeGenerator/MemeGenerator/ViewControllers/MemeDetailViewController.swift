//
//  MemeDetailViewController.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit
import MessageUI
import Hero
import Imaginary

class MemeDetailViewController: UIViewController {
    
    var meme: Meme = Meme()
    
    @IBOutlet weak var memeTextLabel: UILabel!
    @IBOutlet weak var memeLabelView: UILabel!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - View controller specifics
    override func viewDidLoad() {
        super.viewDidLoad()
        title = meme.name
    
        if let url = URL(string: meme.url){
            memeImageView.setImage(url: url)
            backgroundImageView.setImage(url: url)
        }
        
        memeTextLabel.text = meme.name
        
        memeImageView.addParallax(amount: 40)
        memeLabelView.addParallax(amount: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let text = StorageHandler.getInstance().memeTexts[meme.id] {
            if text != "" {
                memeTextLabel.text = text
            } else {
                memeTextLabel.text = meme.name
            }
        } else {
            memeTextLabel.text = meme.name
        }
    }
    
    //MARK: - Actions
    @IBAction func shareButton(_ sender: Any) {
        let alert = UIAlertController(title: "Spread the word!", message: "Share.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sms", style: .default , handler:{ (UIAlertAction)in
            self.sendSms()
        }))
        
        alert.addAction(UIAlertAction(title: "Email", style: .default , handler:{ (UIAlertAction)in
            self.sendEmail()
        }))
    
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    func sendSms() {
        if !MFMessageComposeViewController.canSendText() {
            showAlert("Could not send.", "You can not send a message with this device.")
            return
        }
        
        let textComposer = MFMessageComposeViewController()
        textComposer.messageComposeDelegate = self
        textComposer.body = memeTextLabel.text!
        
        if MFMessageComposeViewController.canSendSubject() {
            textComposer.subject = meme.name
        }
        
        if MFMessageComposeViewController.canSendAttachments() {
            let imageData = UIImageJPEGRepresentation(backgroundImageView.image!, 1.0)
            textComposer.addAttachmentData(imageData!, typeIdentifier: "meme\(meme.id)/jpg", filename: "meme\(meme.id).jpg")
        }
        
        present(textComposer, animated: true)
    }
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            showAlert("Could not send.", "You can not send a message with this device.")
            return
        }
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject(meme.name)
        mail.setMessageBody(memeTextLabel.text!, isHTML: false)
        let imageData = UIImageJPEGRepresentation(backgroundImageView.image!, 1.0)
        mail.addAttachmentData(imageData!, mimeType: "meme\(meme.id)/jpg", fileName: "meme\(meme.id).jpg")
        self.present(mail, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddTextViewController {
            destination.image = memeImageView.image!
            destination.backgroundImage = backgroundImageView.image!
            destination.meme = meme
        }
    }
}

// MARK: - MessageCompose delegates
extension MemeDetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MailCompose delegates
extension MemeDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
