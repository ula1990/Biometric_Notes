//
//  NotesTableViewCell.swift
//  SecureNote
//
//  Created by Ulad Daratsiuk-Demchuk on 2017-11-06.
//  Copyright © 2017 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
