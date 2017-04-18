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
    let titleLabel = PaddedLabel()
    let separatorView = UIView()
    let viewsLabel = PaddedLabel()
    let dateLabel = PaddedLabel()
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

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.photoTitle().string
        view.backgroundColor = UIColor.white
        
        setupViews()
        setupConstraints()
        loadImage()
    }

    // MARK: - fileprivate

    fileprivate func setupViews() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        setupMainStackView()
        setupShareButton()
        setupSeparatorView()
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
        mainStackView.addArrangedSubview(separatorView)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(viewsLabel)
    }

    fileprivate func setupSeparatorView() {
        separatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }

    fileprivate func setupShareButton() {
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(PhotoDetailViewController.buttonTapped), for: .touchUpInside)
        shareButton.setTitle(viewModel.shareButtonTitle, for: .normal)
        shareButton.backgroundColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        shareButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.titleLabel?.minimumScaleFactor = 0.6
    }

    fileprivate func setupLabels() {
        titleLabel.updateAttributedText(viewModel.photoTitle())
        dateLabel.updateAttributedText(viewModel.photoDateTaken())
        viewsLabel.updateAttributedText(viewModel.photoViewCount())
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
        if let image = photoImageView.image {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: viewModel.alertButtonTitle, style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Padded Label Wrapper Class

class PaddedLabel: UIView {

    fileprivate let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6

        addSubview(label)
    }

    fileprivate func setupConstraints() {
        let margin: CGFloat = 8.0
        var constraints: [NSLayoutConstraint] = []
        constraints.append(label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin))
        constraints.append(label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin))
        constraints.append(label.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(label.bottomAnchor.constraint(equalTo: bottomAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    func updateAttributedText(_ text: NSAttributedString) {
        label.attributedText = text
    }
}
