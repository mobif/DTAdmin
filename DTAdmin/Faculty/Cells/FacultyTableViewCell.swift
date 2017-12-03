//
//  FacultyTableViewCell.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/28/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class FacultyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var facultyIdLabel: UILabel!
    @IBOutlet weak var facultyNameLabel: UILabel!
    @IBOutlet weak var facultyDescriptionLabel: UILabel!
}
