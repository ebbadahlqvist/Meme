//
//  SearchNavBarBottomView.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-27.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit

protocol SearchNavBarBottomViewDelegate {
    func onTextChange(text: String, shouldSearch: Bool)
}

class SearchNavBarBottomView: NibView {

    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: SearchNavBarBottomViewDelegate?
    
    var placeholder = "Search"
    
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
        placeholderLabel.text = placeholder
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }
}

// MARK: - Text View Delegate
extension SearchNavBarBottomView: UITextFieldDelegate {
    @objc func textDidChange(textField: UITextField) {
        if textField.text!.isEmpty {
            placeholderLabel.isHidden = false
            delegate?.onTextChange(text: "", shouldSearch: false)
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText = textField.text!
        
        if string.isEmpty {
            searchText = String(searchText.dropLast())
        } else {
            searchText = textField.text!+string
        }
        
        if searchText != "" {
            placeholderLabel.isHidden = true
            delegate?.onTextChange(text: searchText, shouldSearch: true)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


