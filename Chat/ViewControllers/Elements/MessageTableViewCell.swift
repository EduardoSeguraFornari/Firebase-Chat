//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Eduardo Fornari on 23/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var textUILabel: UILabel!
    @IBOutlet weak var backgroundUIView: UIView!

    var message: Message! {
        didSet {
            textUILabel.text = message.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundUIView.layer.cornerRadius = 5
    }

}
