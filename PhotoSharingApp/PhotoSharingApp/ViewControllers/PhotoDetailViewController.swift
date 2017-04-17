//
//  PhotoDetailViewController.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/17/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoDetailViewController: UIViewController {

    let viewModel: PhotoDetailViewModel

    let photoImageView = UIImageView()
    let titleLabel = UILabel()
    let viewsLabel = UILabel()
    let dateLabel = UILabel()
    let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let mainStackView = UIStackView()

    // MARK: - Initializers

    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.photo.title
        view.backgroundColor = UIColor.white
        
        setupViews()
        setupConstraints()
        DispatchQueue.main.async { [weak self] in
            self?.loadingActivityIndicatorView.startAnimating()
            guard let imageString = self?.viewModel.photo.imageURL else {
                return
            }
            self?.photoImageView.sd_setImage(with: URL(string: imageString)) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                self?.loadingActivityIndicatorView.stopAnimating()
            }

        }
    }

    fileprivate func setupViews() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        setupMainStackView()
        setupActivityIndicator()

        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.text = viewModel.photo.title

        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.6
        dateLabel.text = viewModel.photo.dateTaken

        viewsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        viewsLabel.adjustsFontSizeToFitWidth = true
        viewsLabel.minimumScaleFactor = 0.6
        viewsLabel.text = viewModel.photo.viewCount
    }

    fileprivate func setupMainStackView() {
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)
        photoImageView.backgroundColor = UIColor.gray
        photoImageView.contentMode = UIViewContentMode.scaleAspectFill

        mainStackView.addArrangedSubview(photoImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(viewsLabel)
    }

    fileprivate func setupActivityIndicator() {
        view.addSubview(loadingActivityIndicatorView)
    }

    fileprivate func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(mainStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor))

        constraints.append(photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor))
        constraints.append(loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor))
        constraints.append(loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }
}
