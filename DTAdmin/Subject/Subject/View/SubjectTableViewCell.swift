//
//  SubjectTableViewCell.swift
//  DTAdmin
//
//  Created by ITA student on 11/10/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

protocol SubjectTableViewCellDelegate {
    /**
        Sends to the TestViewController when you press ShowTests button
        - Parameter id: Send subject id to the next View Controller for create request and making call's to API
     */
    func didTapShowTest(for id: String)
    /**
        Sends to the TimeTableViewController when you press ShowTimeTable button
        - Parameter id: Send subject id to the next View Controller for create request and making call's to API
     */
    func didTapShowTimeTable(for id: String)
}

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameSubjectLabel: UILabel!
    @IBOutlet weak var descriptionSubjectLabel: UILabel!
    
    var subjectItem: SubjectStructure?
    var delegate: SubjectTableViewCellDelegate?
    
    func setSubject(subject: SubjectStructure) {
        subjectItem = subject
        nameSubjectLabel.text = subject.name
        descriptionSubjectLabel.text = subject.description
    }
    
    @IBAction func showTest(_ sender: UIButton) {
        guard let id = subjectItem?.id else { return }
        delegate?.didTapShowTest(for: id)
    }
    
    @IBAction func showTimeTable(_ sender: UIButton) {
        guard let id = subjectItem?.id else { return }
        delegate?.didTapShowTimeTable(for: id)
    }

}
