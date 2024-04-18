//
//  LoadingViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 2/12/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit
import WebKit

class LoadingViewController: UIViewController {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    
    private var webView: WKWebView!
    private var paymentModel: PaymentModel!
    private var didObtainReference = false
    private var qrStatusTimer: Timer?
    private var timerTickCount = 0
    
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
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    private var statusBarView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.loadingText
        ).localized()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    // MARK: - Initializer
    
    init(paymentModel: PaymentModel) {
        self.paymentModel = paymentModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupViews()
        setupConstraints()
        getQRStatusIfNeeded()
        setCustomStyle()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.addSubview(statusBarView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(logoImageView)
    }
    
    private func setupConstraints() {
        if #available(iOS 13.0, *) {
            let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            statusBarView.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor, height: statusBarHeight)
            
        } else {
            statusBarView = UIApplication.shared.value(forKeyPath: Constants.statusBar) as! UIView
        }
        
        stackView.anchor(right: view.rightAnchor, left: view.leftAnchor, paddingRight: 32, paddingLeft: 32, centerY: view.centerYAnchor)
        stackView.addCustomSpacing(44, after: titleLabel)
        //        stackView.setCustomSpacing(44, after: titleLabel)
        logoImageView.anchor(height: 46)
    }

    private func setCustomStyle() {
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        guard let params = colorScheme?.bgGradientParams, let color1 = params.color1, let color2 = params.color2 else { return }

        view.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        titleLabel.textColor = colorScheme?.textColor
        activityIndicatorView.color = colorScheme?.textColor
    }
    
    private func openWebView(details3D: Details3D) {
        setupWebView()
        let request = getRequest(details3D)
        webView.load(request)
    }
    private func setupWebView() {
        let statusBarHeight = statusBarView.frame.height
        webView = WKWebView(frame: CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: view.frame.height - statusBarHeight))
        var safeAreaBottomInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        let backButton = UIButton()
        backButton.setTitle(String(Constants.Localizable.back).localized(), for: .normal)
        backButton.setTitleColor(self.view.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let customToolBarView = UIView()
        webView.addSubview(customToolBarView)
        customToolBarView.addSubview(backButton)
        customToolBarView.backgroundColor = .white
        customToolBarView.anchor(right: webView.rightAnchor, left: webView.leftAnchor, bottom: webView.bottomAnchor, height: 44 + safeAreaBottomInset)
        backButton.anchor(top: customToolBarView.topAnchor, left: customToolBarView.leftAnchor, paddingTop: 8, paddingLeft: 8, width: 96, height: 24)
        webView.backgroundColor = .white
        if #available(iOS 13.0, *) {
            webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        view.addSubview(webView)
    }
    
    
    private func getRequest(_ details3D: Details3D) -> URLRequest {
        let token = paymentModel.tokenResponseBody.access_token
        var termUrl = "\(Constants.Url.base)/payments/cards/confirmPayment?Access=\(token)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        termUrl = termUrl.replacingOccurrences(of: "+", with: "%2B")
        termUrl = termUrl.replacingOccurrences(of: "+", with: "%2B")
        
        var md = details3D.md.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        md = md.replacingOccurrences(of: "+", with: "%2B")
        md = md.replacingOccurrences(of: "+", with: "%2B")
        
        var paReq = details3D.paReq.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        paReq = paReq.replacingOccurrences(of: "+", with: "%2B")
        paReq = paReq.replacingOccurrences(of: "+", with: "%2B")
        
        let postString = "MD=\(md)&PaReq=\(paReq)&TermUrl=\(termUrl)"
        
        let url = URL (string: details3D.action)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postData: Data = postString.data(using: String.Encoding.utf8)!
        
        request.httpBody = postData
        
        return request as URLRequest
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
        webView.removeFromSuperview()
        webView = nil
    }
    
    private func showResponse() {
        invalidateTimer()

        DispatchQueue.main.async { [weak self] in
            guard let loadingVC = self else { return }
            if let response = loadingVC.paymentModel.paymentResponseBody,
               let details3D = response.secure3D,
               loadingVC.didObtainReference == false {
                loadingVC.openWebView(details3D: details3D)
            } else {
                let successVC = SuccessViewController(paymentModel: loadingVC.paymentModel)
                loadingVC.navigationController?.pushViewController(successVC, animated: false)
            }
        }
    }
    
    private func showError() {
        invalidateTimer()

        DispatchQueue.main.async { [weak self] in
            guard let loadingVC = self else { return }
            let failureVC = FailureViewController(
                paymentModel: loadingVC.paymentModel,
                failType: loadingVC.paymentModel.invoice.transferType != nil ? .transfer : .payment
            )
            loadingVC.navigationController?.pushViewController(failureVC, animated: false)
        }
    }

    private func getQRStatusIfNeeded() {
        guard let currentQRStatus = paymentModel.qrStatus,
              currentQRStatus.qrStatus == .SCANNED || currentQRStatus.qrStatus == .BLOCKED else {
            qrStatusTimer?.invalidate()
            qrStatusTimer = nil
            return
        }

        qrStatusTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(2), repeats: true) { [weak self] _ in
            guard let viewController = self else { return }
            viewController.timerTickCount += 1
            viewController.paymentModel.getQRStatus { [weak viewController] success in
                guard success, let loadingVC = viewController, let status = loadingVC.paymentModel.qrStatus?.qrStatus else {
                    return
                }
                switch status {
                case .AUTH, .PAID:
                    loadingVC.showResponse()
                case .REJECTED:
                    loadingVC.showError()
                default:
                    if loadingVC.timerTickCount == 30 {
                        loadingVC.showError()
                    }
                }
            }
        }
    }

    private func invalidateTimer() {
        qrStatusTimer?.invalidate()
        qrStatusTimer = nil
    }

    private func handlePaymentRequestStatus(success: Bool) {
        DispatchQueue.main.async {
            if success {
                self.showResponse()
                self.activityIndicatorView.stopAnimating()
            } else {
                self.showError()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    // MARK: - Public methods
    
    func makePayment(completion: ((Bool) -> Void)? = nil) {
        if paymentModel.paymentType == .halykID {
            paymentModel.makeHalykIDPayment { [weak self] success in
                self?.handlePaymentRequestStatus(success: success)
            }
        } else if paymentModel.paymentType == .applePay {
            paymentModel.makePaymentWithApplePay { [weak self] success in
                completion?(success)
                self?.handlePaymentRequestStatus(success: success)
            }
        } else {
            paymentModel.makePayment { [weak self] success in
                self?.handlePaymentRequestStatus(success: success)
            }
        }
    }
    
    func subscribeToAutoPayment() {
        paymentModel.subscribeToAutoPayment { (success) in
            DispatchQueue.main.async {
                if success {
                    let vc = AutoPaymentViewController(paymentModel: self.paymentModel)
                    self.navigationController?.pushViewController(vc, animated: false)
                    self.activityIndicatorView.stopAnimating()
                } else {
                    let vc = FailureViewController(paymentModel: self.paymentModel, failType: .autoPayment)
                    self.navigationController?.pushViewController(vc, animated: false)
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        if let key = change?[NSKeyValueChangeKey.newKey] {
            
            guard let url = key as? URL, webView.superview != nil else { return }
            if let _ = url.valueOf("errorCode") {
                let message = String("error_payment_455").localized()
                let error = ErrorResponseBody(message: message)
                self.paymentModel.errorResponseBody = error
                webView.removeFromSuperview()
                showError()
            } else if let reference = url.valueOf("reference") {
                didObtainReference = true
                self.paymentModel.paymentResponseBody.reference = reference
                webView.removeFromSuperview()
                showResponse()
            }
        }
    }

    func makeTransfer(requestBody: TransferRequestBody) {
        paymentModel.makeTransfer(body: requestBody) { [weak self] success in
            self?.handlePaymentRequestStatus(success: success)
        }
    }
}
