//
//  CustomSectionHeaderView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//
import UIKit

class CustomSectionHeaderView: UIView {
    private let sectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray // Set your desired background color
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16) // Set your desired font
        label.textColor = .black // Set your desired text color
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(sectionBackgroundView)
        addSubview(titleLabel)

        // Configure constraints for the section background view
        NSLayoutConstraint.activate([
            sectionBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            sectionBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Configure constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: sectionBackgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: sectionBackgroundView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: sectionBackgroundView.centerYAnchor)
        ])
    }

    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
}
