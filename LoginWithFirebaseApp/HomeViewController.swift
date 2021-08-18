//
//  HomeViewController.swift
//  LoginWithFirebaseApp
//
//  Created by NaoyukiIshida on 2021-08-16.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.cornerRadius = 10
        
        if let user = user {
            nameLabel.text = user.name + "さん、ようこそ"
            emailLabel.text = user.email
            let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
            dateLabel.text = "作成日: " + dateString
        }
    }
    
    private func dateFormatterForCreatedAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
