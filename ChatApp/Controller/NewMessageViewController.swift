//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Apollo on 1.09.2023.
//

import UIKit

protocol NewMessageViewControllerProtocol: AnyObject {
    func goToChatView(user: User)
}

class NewMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let identifier = "MessageCell"
    private let tableView = UITableView()
    private var users = [User]()
    weak var delegate: NewMessageViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        tableView.register(UserCell.self, forCellReuseIdentifier: identifier)

        style()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.goToChatView(user: users[indexPath.row])
    }
}

extension NewMessageViewController {
    func style() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 74
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
    }

    func layout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
