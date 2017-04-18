//
//  LaunchViewController.swift
//  PhotoSharingApp
//
//  Created by Barry Brown on 4/14/17.
//  Copyright © 2017 barrybrown. All rights reserved.
//

import UIKit
import OAuthSwift

class LaunchViewController: UIViewController {

    let viewModel: LaunchViewModel

    let mainStackView = UIStackView()

    let loadingView = UIView()

    let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    var oauthswift: OAuthSwift?

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.titleString

        setupViews()
        setupConstraints()
    }

    fileprivate func setupViews() {
        view.backgroundColor = UIColor.white
        setupMainStackView()
        setupLoadingView()
        setupActivityIndicator()
    }

    fileprivate func setupMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        label.text = viewModel.labelTitle
        mainStackView.addArrangedSubview(label)

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.backgroundColor = UIColor.orange
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.addTarget(self, action: #selector(LaunchViewController.buttonTapped), for: .touchUpInside)
        mainStackView.addArrangedSubview(button)
    }

    fileprivate func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        loadingView.alpha = 0.0
    }

    fileprivate func setupActivityIndicator() {
        view.addSubview(loadingActivityIndicatorView)
        loadingActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(mainStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor))


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

extension LaunchViewController {
    func doAuthService() {
        let oauthswift = WebService.oauthSwift()
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://PhotoSharingApp/flickr")!,
            success: { credential, response, parameters in
                let _ = credential.oauthToken
                let _ = credential.oauthTokenSecret
        },
            failure: { error in
                print(error.description)
        })
    }
}
