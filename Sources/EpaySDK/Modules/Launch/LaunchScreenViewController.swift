//
//  LaunchScreenViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

public class LaunchScreenViewController: UIViewController {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private var paymentModel: PaymentModel!
    
    // MARK: - UI Elements
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 16
        v.distribution = .fill
        v.alignment = .fill
        return v
    }()
    
    private lazy var logoImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.logo, in: Bundle.module, compatibleWith: nil)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var timeIconImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.time, in: Bundle.module, compatibleWith: nil)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var introTextLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.introText
        ).localized()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()
    
    // MARK: - Initializers
    
    public init(paymentModel: PaymentModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.paymentModel = paymentModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
//        paymentModel?.requestToken(completion: { (success) in
//            DispatchQueue.main.async {
//                if success {
//                    let vc = MainViewController(paymentModel: self.paymentModel!)
//                    self.navigationController?.pushViewController(vc, animated: false)
//                }
//                else {
//                    let vc = FailureViewController(paymentModel: self.paymentModel, failType: .token)
//                    self.navigationController?.pushViewController(vc, animated: false)
//                }
//            }
//        })
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupViews()
        setupConstraints()
        
    }
    
    // MARK: - Public methods
    
    public func setEnvironmetType(type: EnvironmentType) {
        Constants.Url.environment = type
    }
    // MARK: - Private methods
    
    private func getData() {
        let pushMainViewController = {
            DispatchQueue.main.async {
                let vc = MainViewController(
                    paymentModel: self.paymentModel!,
                    isHomebankInstalled: self.isHomebankInstalled
                )
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        let pushTransferViewController = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let vc = TransferViewController(paymentModel: strongSelf.paymentModel!)
                strongSelf.navigationController?.pushViewController(vc, animated: false)
            }
        }
        let pushFailureViewController = {
            DispatchQueue.main.async {
                let vc = FailureViewController(paymentModel: self.paymentModel, failType: .token)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
        paymentModel?.requestToken { [weak self] success in
            guard let viewController = self else { return }
            if success {
                viewController.paymentModel.loadPublicProfile { success in
                    viewController.paymentModel.getInstallmentInfo {
                        if success {
                            if viewController.paymentModel.isMasterPass != nil {
                                viewController.paymentModel.getMasterPassCardData {success in
                                    if success {
                                        viewController.paymentModel.invoice.isTransfer ? pushTransferViewController() : pushMainViewController()
                                    } else {
                                        viewController.paymentModel.invoice.isTransfer ? pushTransferViewController() : pushMainViewController()
                                    }
                                }
                            } else {
                                viewController.paymentModel.invoice.isTransfer ? pushTransferViewController() : pushMainViewController()
                            }
                        } else {
                            pushFailureViewController()
                        }
                    }
                }
            } else {
                pushFailureViewController()
            }
        }
    }
    
    private var isHomebankInstalled: Bool {
        guard let url = URL(string: Constants.DeepLink.homeBank) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(timeIconImageView)
        stackView.addArrangedSubview(introTextLabel)
        stackView.addArrangedSubview(logoImageView)
    }
    
    private func setupConstraints() {
        stackView.anchor(right: view.rightAnchor, left: view.leftAnchor, paddingRight: 32, paddingLeft: 32, centerY: view.centerYAnchor)
        stackView.addCustomSpacing(44, after: introTextLabel)
        
        timeIconImageView.anchor(height: 24)
        logoImageView.anchor(height: 46)
    }
}
