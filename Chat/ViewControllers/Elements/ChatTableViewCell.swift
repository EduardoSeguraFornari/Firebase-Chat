//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by Eduardo Fornari on 25/04/18.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var profileNameUILabel: UILabel!

    public private(set) var profile: Profile?

    public var userChat: UserChat! {
        didSet {
            profileNameUILabel.text = userChat.identifier
            DataAccess.sharedInstance.fetchUserProfile(by: userChat.secondUserProfileID) { profiles in
                if let profile = profiles?.first {
                    self.profile = profile
                    self.profileNameUILabel.text = profile.firstName
                }
            }
        }
    }

}
