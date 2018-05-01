
//
//  FastighetRowView.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-03-14.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit

@IBDesignable class BigEditableView: NibView {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBInspectable var maxNumbers: Int = 80
    @IBInspectable var placeholder: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        setupView()
    }
    
    fileprivate func setupView() {
        textView.delegate = self
        placeHolderLabel.text = placeholder
        maxLabel.text = "/ \(maxNumbers)"
    }
}

// MARK: - Text View Delegate
extension BigEditableView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
        totalLabel.text = "\(textView.text.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < (maxNumbers + 1)
    }
}

