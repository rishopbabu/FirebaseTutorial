//
//  CustomTableViewCell.swift
//  FirebaseTutorial
//
//  Created by MAC-OBS-26 on 31/05/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
