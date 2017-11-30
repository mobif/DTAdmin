//
//  TestDetailsTableViewCell.swift
//  DTAdmin
//
//  Created by Volodymyr on 11/8/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class TestDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var testDetailId: UILabel!
    @IBOutlet weak var testDetailTestId: UILabel!
    @IBOutlet weak var testDetailLevel: UILabel!
    @IBOutlet weak var testDetailTasks: UILabel!
    @IBOutlet weak var testDetailRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
