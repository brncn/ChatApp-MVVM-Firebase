//
//  UserCell.swift
//  ChatApp
//
//  Created by Apollo on 8.09.2023.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    // MARK: Proporties
    
    var user: User? {
        didSet{
            configureUserCell()
        }
    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true

        return imageView
    }()

    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.text = "Ad Soyad"
        return title
    }()

    private let subTitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont.systemFont(ofSize: 13)
        subtitle.textColor = .systemGray
        subtitle.text = "Önceki Mesajlar"

        return subtitle
    }()
    
    

    private var stackview = UIStackView()

    // MARK: Lifecycle
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Helpers

extension UserCell {
    private func setup() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 55 / 2

        // stackview
        stackview = UIStackView(arrangedSubviews: [title, subTitle])
        stackview.axis = .vertical
        stackview.spacing = 0.5
        stackview.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layout() {
        addSubview(profileImageView)
        addSubview(stackview)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 55),
            profileImageView.widthAnchor.constraint(equalToConstant: 55),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            stackview.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 9),
            trailingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: 4),
            stackview.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            bottomAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 10),

        ])
    }
    
    func configureUserCell(){
        guard let user = user else { return }
        self.title.text = user.name
        self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        self.subTitle.text = user.userName
    }
}
