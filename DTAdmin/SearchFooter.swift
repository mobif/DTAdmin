//
//  SearchFooter.swift
//  DTAdmin
//
//  Created by ITA student on 11/18/17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import UIKit

class SearchFooter: UIView {

    let label: UILabel = UILabel()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // Function for configuration footer view
    func configureView() {
        backgroundColor = .blue
        alpha = 0.0
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }

    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }

    // Functions which generate animation for footer view
    fileprivate func hideFooter() {
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.alpha = 0.0
        }
    }

    fileprivate func showFooter() {
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.alpha = 1.0
        }
    }
}

extension SearchFooter {
    public func setNotFiltering() {
        label.text = ""
        hideFooter()
    }

    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            setNotFiltering()
        } else if (filteredItemCount == 0) {
            label.text = NSLocalizedString("No items match your query", comment: "Information for user about no items")
            showFooter()
        } else {
            let filteringText = NSLocalizedString("Filtering ", comment: "Filtering information - filtering")
            let ofText = NSLocalizedString(" of ", comment: "Filtering information - filtering")
            label.text = filteringText + String(filteredItemCount) + ofText + String(totalItemCount)
            showFooter()
        }
    }

}
