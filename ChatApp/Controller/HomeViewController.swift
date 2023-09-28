//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Apollo on 31.08.2023.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
    //    MARK: - Proporties

    private var messageButton: UIBarButtonItem!
    private var newMessageButton: UIBarButtonItem!
    private var container = Container()
    private let messageViewController = NewMessageViewController()
    private lazy var viewControllers: [UIViewController] = [MessageViewController(), messageViewController]
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationStatus()
//        Çıkış yapılmasını istediğinizde signOut() Fonksiyonunu çalıştırabilirsiniz.
//        signOut()
        style()
        layout()
        print(Auth.auth().currentUser?.email)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleMessageButton()
    }
}

//    MARK: - Helpers

extension HomeViewController {
    private func configureBarItem(text: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    private func authenticationStatus() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationStatus()
            
        } catch {}
    }
    
    private func style() {
        view.backgroundColor = .black
        messageButton = UIBarButtonItem(customView: configureBarItem(text: "Mesage", selector: #selector(handleMessageButton)))
        newMessageButton = UIBarButtonItem(customView: configureBarItem(text: "New Mesage", selector: #selector(handleNewMessageButton)))
        navigationItem.leftBarButtonItems = [messageButton, newMessageButton]
        messageViewController.delegate = self
        
        // container
        handleMessageButton()
        configureContainer()
    }

    private func layout() {}
    
    private func configureContainer() {
        guard let containerView = container.view else { return }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Selector

extension HomeViewController {
    @objc private func handleMessageButton() {
        if container.children.first == MessageViewController() { return }
        container.add(viewControllers[0])
        viewControllers[0].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageButton.customView?.alpha = 1
            self.newMessageButton.customView?.alpha = 0.5
            self.viewControllers[0].view.alpha = 1
            self.viewControllers[1].view.frame.origin.x = -1000
        } completion: { _ in
            self.viewControllers[1].remove()
            self.viewControllers[1].view.frame.origin.x = 0
        }
    }
    
    @objc private func handleNewMessageButton() {
        if container.children.first == NewMessageViewController() { return }
        container.add(viewControllers[1])
        viewControllers[1].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageButton.customView?.alpha = 0.5
            self.newMessageButton.customView?.alpha = 1
            self.viewControllers[1].view.alpha = 1
            self.viewControllers[0].view.frame.origin.x = +1000
        } completion: { _ in
            self.viewControllers[0].remove()
            self.viewControllers[0].view.frame.origin.x = 0
        }
    }
}

extension HomeViewController: NewMessageViewControllerProtocol {
    func goToChatView(user: User) {
        let controller = ChatViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
