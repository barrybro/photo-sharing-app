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
    let shareButton = UIButton(type: .custom)

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
        title = viewModel.photoTitle()
        view.backgroundColor = UIColor.white
        
        setupViews()
        setupConstraints()
        loadImage()
    }

    fileprivate func setupViews() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        setupMainStackView()
        setupShareButton()
        setupActivityIndicator()
        setupLabels()
    }

    fileprivate func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 4.0
        view.addSubview(mainStackView)
        photoImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        photoImageView.contentMode = UIViewContentMode.scaleAspectFill
        photoImageView.clipsToBounds = true

        mainStackView.addArrangedSubview(photoImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(viewsLabel)
    }

    fileprivate func setupShareButton() {
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(PhotoDetailViewController.buttonTapped), for: .touchUpInside)
        shareButton.setTitle(viewModel.shareButtonTitle, for: .normal)
        shareButton.backgroundColor = UIColor.brown
        shareButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.6
    }

    fileprivate func setupLabels() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.text = viewModel.photoTitle()

        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.6
        dateLabel.text = viewModel.photoDateTaken()

        viewsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        viewsLabel.adjustsFontSizeToFitWidth = true
        viewsLabel.minimumScaleFactor = 0.6
        viewsLabel.text = viewModel.photoViewCount()
    }

    fileprivate func setupActivityIndicator() {
        view.addSubview(loadingActivityIndicatorView)
    }

    fileprivate func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(mainStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: shareButton.topAnchor))
        constraints.append(shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(shareButton.heightAnchor.constraint(equalToConstant: 50.0))

        constraints.append(photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor))
        constraints.append(loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor))
        constraints.append(loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    fileprivate func loadImage() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadingActivityIndicatorView.startAnimating()
            strongSelf.photoImageView.sd_setImage(with: URL(string: strongSelf.viewModel.photoURL())) {[weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                self?.loadingActivityIndicatorView.stopAnimating()
            }
        }
    }

    @objc fileprivate func buttonTapped() {
        // display action sheet to share photo
//        let activityItems = [UIActivityIte]
//        let activityVC = UIActivityViewController(activityItems: <#T##[Any]#>, applicationActivities: <#T##[UIActivity]?#>)
    }
}
