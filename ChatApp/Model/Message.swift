//
//  Message.swift
//  ChatApp
//
//  Created by Apollo on 22.09.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    let currentUser: Bool
    init(data: [String: Any]) {
        self.text = data["text"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.currentUser = fromId == Auth.auth().currentUser?.uid
    }
}
