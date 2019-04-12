//
//  customCell1TableCellTableViewCell.swift
//  FootBallApp
//
//  Created by AS182 on 7/20/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit

class customCell1TableCellTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var leagueName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
