//
//  PhotoTableViewCell.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/16/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoTableViewCell: UITableViewCell {

    var photo: Photo? {
        didSet {
            updateCell()
        }
    }

    fileprivate let photoImageView = UIImageView()

    fileprivate let photoTitleLabel = UILabel()

    let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    fileprivate let photoWH: CGFloat = 60.0

    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - fileprivate methods

    fileprivate func setupViews() {
        photoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoTitleLabel)
        photoTitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        photoTitleLabel.adjustsFontSizeToFitWidth = true
        photoTitleLabel.minimumScaleFactor = 0.6

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImageView)
        photoImageView.backgroundColor = UIColor.gray
        photoImageView.layer.cornerRadius = 8.0
        photoImageView.layer.masksToBounds = true

        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingActivityIndicatorView)
    }

    fileprivate func setupConstraints() {
        let margin: CGFloat = 12.0

        var constraints: [NSLayoutConstraint] = []

        constraints.append(photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin))
        constraints.append(photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin))
        constraints.append(photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin))
        constraints.append(photoImageView.heightAnchor.constraint(equalToConstant: photoWH))
        constraints.append(photoImageView.widthAnchor.constraint(equalToConstant: photoWH))

        constraints.append(photoTitleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: margin))
        constraints.append(photoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin))
        constraints.append(photoTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        constraints.append(photoTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor))
        constraints.append(photoTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor))

        constraints.append(loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor))
        constraints.append(loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Internal methods

    func updateCell() {
        guard let photo = photo else {
            return
        }
        photoTitleLabel.text = photo.title
        self.loadingActivityIndicatorView.startAnimating()
        self.photoImageView.sd_setImage(with: URL(string: photo.thumbnailURL)) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, theURL: URL?) in
            self.loadingActivityIndicatorView.stopAnimating()
        }
    }
}
