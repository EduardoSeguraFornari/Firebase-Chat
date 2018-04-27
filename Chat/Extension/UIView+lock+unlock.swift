//
//  UIView+lock+unlock.swift
//  Chat
//
//  Created by Eduardo Fornari on 09/04/18.
//  Copyright © 2018 Eduardo Fornari. All rights reserved.
//

import UIKit

extension UIView {

    private static let backdropViewTag = 1001
    private static let activityViewTag = 1002

    func lock() {
        let backdrop = UIView()
        backdrop.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.8)
        backdrop.tag = UIView.backdropViewTag

        self.addSubview(backdrop)

        backdrop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backdrop.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backdrop.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backdrop.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backdrop.topAnchor.constraint(equalTo: self.topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

        let activityView = UIActivityIndicatorView()
        activityView.activityIndicatorViewStyle = .whiteLarge
        activityView.color = .white
        activityView.tag = UIView.activityViewTag
        activityView.startAnimating()

        self.addSubview(activityView)

        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }

    func unlock() {
        DispatchQueue.main.async {
            self.viewWithTag(UIView.backdropViewTag)?.removeFromSuperview()
            self.viewWithTag(UIView.activityViewTag)?.removeFromSuperview()
        }
    }

}
