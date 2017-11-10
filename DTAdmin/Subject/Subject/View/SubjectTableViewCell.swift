//
//  SubjectTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol SubjectTableViewCellDelegate {
    
    func didTapShowTest(id: String)
    func didTapShowTimeTable(id: String)
}

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameSubjectLabel: UILabel!
    
    @IBOutlet weak var descriptionSubjectLabel: UILabel!
    
    var subjectItem: SubjectStructure!
    var delegate: SubjectTableViewCellDelegate?
    
    func setSubject(subject: SubjectStructure) {
        subjectItem = subject
        nameSubjectLabel.text = subject.name
        descriptionSubjectLabel.text = subject.description
    }
    
    @IBAction func showTest(_ sender: UIButton) {
        guard let id = subjectItem.id else { return }
        delegate?.didTapShowTest(id: id)
    }
    
    @IBAction func showTimeTable(_ sender: UIButton) {
        guard let id = subjectItem.id else { return }
        delegate?.didTapShowTimeTable(id: id)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
