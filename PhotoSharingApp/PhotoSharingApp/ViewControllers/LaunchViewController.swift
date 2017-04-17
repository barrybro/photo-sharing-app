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

    let authButton: UIButton = {
        let authButton = UIButton(type: .custom)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.setTitle("Need to authorize", for: .normal)
        authButton.backgroundColor = UIColor.orange
        authButton.setTitleColor(UIColor.white, for: .normal)
        authButton.setTitleColor(UIColor.gray, for: .highlighted)
        authButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        return authButton
    }()

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
        setupMainStackView()
        setupLoadingView()
        setupActivityIndicator()
    }

    fileprivate func setupMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)

        authButton.addTarget(self, action: #selector(LaunchViewController.authButtonTapped), for: .touchUpInside)
        mainStackView.addArrangedSubview(authButton)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.cyan
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        label.text = viewModel.labelTitle
        mainStackView.addArrangedSubview(label)

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
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

    @objc fileprivate func authButtonTapped() {
        doAuthService()
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
                    let alert = UIAlertController(title: "Uh oh!", message: "Something went wrong fetching your photos", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in
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

        let handler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            print("Safari dismissed")
        }

        oauthswift.authorizeURLHandler = handler

        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://PhotoSharingApp/flickr")!,
            success: { [weak self] credential, response, parameters in
                let token = credential.oauthToken
                let secret = credential.oauthTokenSecret
                print("😎 token is \(token) and secret is \(secret)")
                self?.authButton.setTitle("Authorized", for: .normal)
        },
            failure: { error in
                print(error.description)
        })
    }
}
