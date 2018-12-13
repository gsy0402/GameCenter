//
//  GameTableViewCell.swift
//  GameCenter
//
//  Created by Siyuan Guo on 12/12/18.
//  Copyright © 2018 Siyuan Guo. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gamePriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
