//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Apollo on 28.07.2023.
//

import Foundation

struct RegisterViewModel {
    var email: String?
    var password: String?
    var username: String?
    var name: String?
    var status: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && name?.isEmpty == false && username?.isEmpty == false
    }
}
