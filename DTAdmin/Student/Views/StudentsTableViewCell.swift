//
//  StudentsTableViewCell.swift
//  DTAdmin
//
//  Created by Volodymyr on 10/16/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class StudentsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var sName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
