//
//  SmallMemeTableViewCell.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import UIKit

class SmallMemeTableViewCell: UITableViewCell {
    
    let ID = "smallMemeCell"
 
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var memeNameLabel: UILabel!
    @IBOutlet weak var memeTextLabel: UILabel!
    
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        lineHeightConstraint.constant = 0.5
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
