//
//  CommentTableViewCell.swift
//  GameCenter
//
//  Created by Siyuan Guo on 12/12/18.
//  Copyright © 2018 Siyuan Guo. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
