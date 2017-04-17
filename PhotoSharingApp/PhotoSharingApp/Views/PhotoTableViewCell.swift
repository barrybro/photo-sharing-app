//
//  PhotoTableViewCell.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/16/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    var photo: Photo? {
        didSet {
            updateCell()
        }
    }

    fileprivate let photoTitleLabel = UILabel()

    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews() {
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoTitleLabel)
    }

    fileprivate func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(photoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(photoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(photoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(photoTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func updateCell() {
        guard let photo = photo else {
            return
        }
        photoTitleLabel.text = photo.title

    }
}
