//
//  LaunchViewController.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let viewModel: LaunchViewModel

    let label = UILabel()
    let separatorView = UIView()
    let viewPhotosButton = UIButton(type: .custom)
    let loadingView = UIView()
    let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    // MARK: - Initializers

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.titleString

        setupViews()
        setupConstraints()
    }

    // MARK: - fileprivate methods

    fileprivate func setupViews() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        setupLabel()
        setupSeparatorView()
        setupButton()
        setupLoadingView()
        setupActivityIndicator()
    }

    fileprivate func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        label.text = viewModel.labelTitle
        view.addSubview(label)
    }

    fileprivate func setupSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.gray
    }

    fileprivate func setupButton() {
        viewPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        viewPhotosButton.setTitle(viewModel.buttonTitle, for: .normal)
        viewPhotosButton.backgroundColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        viewPhotosButton.setTitleColor(UIColor.white, for: .normal)
        viewPhotosButton.setTitleColor(UIColor.gray, for: .highlighted)
        viewPhotosButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        viewPhotosButton.addTarget(self, action: #selector(LaunchViewController.buttonTapped), for: .touchUpInside)
        view.addSubview(viewPhotosButton)
    }

    fileprivate func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.alpha = 0.0
    }

    fileprivate func setupActivityIndicator() {
        view.addSubview(loadingActivityIndicatorView)
        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func setupConstraints() {
        let buttonHeight: CGFloat = 50.0
        let horizontalMargin: CGFloat = 8.0
        let verticalMargin: CGFloat = 20.0
        let separatorHeight: CGFloat = 1.0

        var constraints: [NSLayoutConstraint] = []
        constraints.append(label.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: verticalMargin))
        constraints.append(label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin))
        constraints.append(label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin))

        constraints.append(separatorView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: verticalMargin))
        constraints.append(separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin))
        constraints.append(separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin))
        constraints.append(separatorView.bottomAnchor.constraint(lessThanOrEqualTo: viewPhotosButton.topAnchor, constant: -verticalMargin))
        constraints.append(separatorView.heightAnchor.constraint(equalToConstant: separatorHeight))

        constraints.append(viewPhotosButton.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor))
        constraints.append(viewPhotosButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(viewPhotosButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(viewPhotosButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor))
        constraints.append(viewPhotosButton.heightAnchor.constraint(equalToConstant: buttonHeight))

        constraints.append(loadingView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor))

        constraints.append(loadingActivityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(loadingActivityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    fileprivate func displayLoadingView() {
        title = viewModel.loadingTitle
        loadingActivityIndicatorView.startAnimating()
        UIView.animate(withDuration: viewModel.loadingDuration, animations: { [weak self] in
            self?.loadingView.alpha = 1.0
        })
    }

    fileprivate func hideLoadingView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.viewModel.loadingDuration, animations: { [weak self] in
                self?.loadingView.alpha = 0.0
            }) { [weak self] _ in
                self?.title = self?.viewModel.titleString
                self?.loadingActivityIndicatorView.stopAnimating()
            }
        }
    }

    @objc fileprivate func buttonTapped() {
        viewModel.loadPhotoset(showLoadingBlock: { [weak self] in
            self?.displayLoadingView()
            }, completion: { [weak self] (photoset: Photoset?) in
                if let photoset = photoset {
                    self?.hideLoadingView()
                    DispatchQueue.main.async {
                        let listViewModel = PhotosListViewModel(photoset: photoset)
                        let listViewController = PhotosListViewController(viewModel: listViewModel)
                        self?.navigationController?.pushViewController(listViewController, animated: true)
                    }
                }
                else {
                    let alert = UIAlertController(title: self?.viewModel.alertTitle, message: self?.viewModel.alertMessage, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: self?.viewModel.alertButtonTitle, style: UIAlertActionStyle.default) { _ in
                        self?.hideLoadingView()
                    }
                    alert.addAction(dismissAction)
                    self?.present(alert, animated: true, completion: nil)
                }
        })
    }
}
