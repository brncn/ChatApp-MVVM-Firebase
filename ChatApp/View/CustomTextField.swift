//
//  CustomTextField.swift
//  ChatApp
//
//  Created by Apollo on 26.07.2023.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    init(placeholder: String) {
        super.init(frame: .zero)
       attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.white])
        borderStyle = .none
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
