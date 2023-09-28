//
//  User.swift
//  ChatApp
//
//  Created by Apollo on 15.09.2023.
//

import Foundation

struct User {
    let uid: String
    let email: String
    let name: String
    let userName: String
    let profileImageUrl: String

    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? "denem"
        self.email = data["email"] as? String ?? "deeneme"
        self.name = data["name"] as? String ?? ""
        self.userName = data["username"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

struct LastUser {
    let user: User
    let message: Message
}
