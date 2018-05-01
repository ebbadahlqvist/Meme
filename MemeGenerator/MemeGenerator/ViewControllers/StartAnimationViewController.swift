//
//  StartAnimationViewController.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-29.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit

class StartAnimationViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    let segueId = "startSegue"
    
    let text = Array("For humorous purposes.")
    
    var counter = 0
    
    var timer:Timer?
    
    //MARK: - View controller specifics
    override func viewDidLoad() {
        super.viewDidLoad()
        fireTimer()
    }
    
    //MARK: - Actions
    func fireTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(StartAnimationViewController.typeLetter), userInfo: nil, repeats: true)
    }
    
    @objc func typeLetter(){
        if counter < text.count {
            textField.text = textField.text! + String(text[counter])
            let randomInterval = Double((arc4random_uniform(8)+1))/30
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: randomInterval, target: self, selector: #selector(StartAnimationViewController.typeLetter), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
            sleep(2)
            performSegue(withIdentifier: segueId, sender: self)
        }
        counter += 1
    }
}
