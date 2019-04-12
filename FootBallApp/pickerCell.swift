//
//  pickerCell.swift
//  FootBallApp
//
//  Created by Praveen Khare on 14/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class pickerCell: UITableViewCell {

    @IBOutlet var lbl: UILabel!
    @IBOutlet var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
