//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Apollo on 27.07.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class RegisterViewController: UIViewController {
    private var registerView = RegisterViewModel()
    
    //    MARK: - Properties
    
    private var profilePhotoUpload: UIImage?
    private lazy var addCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoPicker), for: .touchUpInside)
        return button
    }()

    private lazy var emailContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        
        return containerView
    }()

    private lazy var nameContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "figure.stand")!, textField: nameTextField)
        
        return containerView
    }()

    private lazy var usernameContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person.circle")!, textField: usernameTextField)
        
        return containerView
    }()

    private lazy var passwordContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        
        return containerView
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()

    private let emailTextField: UITextField = CustomTextField(placeholder: "Email")
    private let nameTextField: UITextField = CustomTextField(placeholder: "Name")
    private let usernameTextField: UITextField = CustomTextField(placeholder: "Username")
    private var stackView = UIStackView()
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()

    private lazy var switchToLogin: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "back to login page", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 12)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleToLoginPage), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleToLoginPage(sender: UIButton) {
        let controller = LoginViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func handlePhotoPicker() {
        let picker = UIImagePickerController()
        present(picker, animated: true)
        picker.delegate = self
    }
    
    //    MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        registerButtonStatus()
        
        emailTextField.autocorrectionType = .no
    }
}

// MARK: - Selector

extension RegisterViewController {
    @objc private func handleTextFİeldChange(sender: UITextField) {
        if sender == emailTextField {
            registerView.email = sender.text
        } else if sender == nameTextField {
            registerView.name = sender.text
        } else if sender == usernameTextField {
            registerView.username = sender.text
        } else {
            registerView.password = sender.text
        }
        registerButtonStatus()
    }
    
    @objc private func handleRegisterButton(sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        guard let nameText = nameTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let profileImage = profilePhotoUpload else { return }
        
        let user = AuthenticationServiceUser(emailText: emailText, passwordText: passwordText, nameText: nameText, usernameText: usernameText)
        showProgressHud(showProgress: true)
        AuthenticationService.register(withUser: user, image: profileImage) { error in
            if let error = error {
                print("Error-1\(error.localizedDescription)")
                self.showProgressHud(showProgress: false)
                return
            }
            self.showProgressHud(showProgress: false)
            self.dismiss(animated: true)
        }
    }
}

//    MARK: - Helpers

extension RegisterViewController {
    @objc private func handleWillShowNotification() {
        view.frame.origin.y = -110
    }

    @objc private func handleWillHideNotification() {
        view.frame.origin.y = 0
    }

    private func configureSetupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func style() {
        configureGradientLayer()
        configureSetupKeyboard()
        
        //        addCameraButton
        addCameraButton.translatesAutoresizingMaskIntoConstraints = false
        //        StackView
        stackView = UIStackView(arrangedSubviews: [emailContainerView, usernameContainerView, nameContainerView, passwordContainerView, registerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        //        textDidChange
        emailTextField.addTarget(self, action: #selector(handleTextFİeldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFİeldChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(handleTextFİeldChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(handleTextFİeldChange), for: .editingChanged)
        //        loginpage
        switchToLogin.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layout() {
        view.addSubview(stackView)
        view.addSubview(addCameraButton)
        view.addSubview(switchToLogin)
        
        NSLayoutConstraint.activate([
            addCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            addCameraButton.heightAnchor.constraint(equalToConstant: 150),
            addCameraButton.widthAnchor.constraint(equalToConstant: 150),
            addCameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: addCameraButton.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            switchToLogin.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            switchToLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            switchToLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
}

extension RegisterViewController {
    private func registerButtonStatus() {
        if registerView.status {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.white
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.systemGray
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as! UIImage
        profilePhotoUpload = image
        addCameraButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        addCameraButton.layer.cornerRadius = 150 / 2
        addCameraButton.clipsToBounds = true
        addCameraButton.layer.borderColor = UIColor.white.cgColor
        addCameraButton.layer.borderWidth = 1
        addCameraButton.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}
