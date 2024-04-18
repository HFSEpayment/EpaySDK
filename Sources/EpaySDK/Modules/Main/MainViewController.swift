//
//  ViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 1/29/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit
import PassKit
import AVKit
import Accelerate
import AudioToolbox
import AVFoundation
import CoreGraphics
import CoreMedia
import CoreVideo
import Foundation
import MobileCoreServices
import OpenGLES
import QuartzCore
import Security
import CardScan


class MainViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var paymentModel: PaymentModel!
    private var isHomebankInstalled: Bool
    private var keyboard = KeyboardObserver()
    private var paymentTypes: [PaymentType] = [.creditCard]
    private var qrStatusTimer: Timer?
    private let headerId = String(describing: OrderDetailsView.self)
    private var additionalInfoViewHidden = true
    
    private var selectedPaymentType: PaymentType = .creditCard {
        didSet {
            paymentModel.paymentType = selectedPaymentType
            if selectedPaymentType == .applePay {
                presentApplePayViewController()
            }
        }
    }

    private var paymentViewSettings: PublicProfileResponseBody.Assets.PaymentViewSettings? {
        return paymentModel.publicProfile?.assets?.payment_view_settings
    }

    private var paymentTypesView: PaymentTypesView {
        return PaymentTypesView(
            paymentTypes: paymentTypes,
            selectedPaymentType: selectedPaymentType,
            colorScheme: paymentModel.publicProfile?.assets?.color_scheme,
            delegate: self
        )
    }

    private var licenseView: LicenseView {
        let licenseView = LicenseView()
        licenseView.setCustomText(color: paymentModel.publicProfile?.assets?.color_scheme?.textColor)
        return licenseView
    }

    init(paymentModel: PaymentModel, isHomebankInstalled: Bool) {
        self.paymentModel = paymentModel
        self.isHomebankInstalled = isHomebankInstalled
        super.init(nibName: nil, bundle: nil)
        setPaymentTypes()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setLayoutConstraints()
        stylize()
        setupKeyboard()
        setCustomStyle()

        if paymentModel.installmentAvailable {
            paymentModel.getOrderStatus(every: 10) { [weak self] status, timer in
                if status != .new {
                    timer.invalidate()
                    DispatchQueue.main.async {
                        self?.showInstallmentSteps(with: status)
                    }
                }
            }
        }
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getQrStatusIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setPaymentTypes() {
        if paymentViewSettings?.byQR == true {
            paymentTypes.append(.QR)
        }
        if paymentViewSettings?.byHalykID == true, paymentModel.invoice.homebankToken != nil {
            paymentTypes.append(.halykID)
            loadHomebankCards()
        }
        if paymentViewSettings?.byApplePay == true {
            paymentTypes.append(.applePay)
            if paymentModel.authConfig.isAppClip == true {
                selectedPaymentType = .applePay
            }
        }
        if paymentViewSettings?.byPayByHBCredit == true && paymentModel.installmentAvailable {
            paymentTypes.append(.installment)
        }
    }

    private func setLayoutConstraints() {
        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor
        )
    }

    private func stylize() {
        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedSectionHeaderHeight = 200
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 180
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderDetailsView.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(PaymentInfoTableViewCell.self, forCellReuseIdentifier: PaymentInfoTableViewCell.cellId)
    }

    private func setupKeyboard() {
        keyboard.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow, .willHide, .willChangeFrame:
                let keyboardFrameEnd = event.keyboardFrameEnd
                var bottom: CGFloat = 0
                if #available(iOS 11.0, *) {
                    bottom = keyboardFrameEnd.height - self.view.safeAreaInsets.bottom + 16
                } else {
                    bottom = keyboardFrameEnd.height + 16
                }
                
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options], animations: { () -> Void in
                    self.tableView.contentInset.bottom = bottom
                    self.tableView.scrollIndicatorInsets.bottom = bottom
                }, completion: nil)
            default:
                break
            }
        }
    }

    private func setCustomStyle() {
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        guard let params = colorScheme?.bgGradientParams, let color1 = params.color1, let color2 = params.color2 else { return }
        view.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
    }

    private func getQrStatusIfNeeded() {
        guard selectedPaymentType == .QR else {
            invalidateTimer()
            return
        }

        qrStatusTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(2), repeats: true) { [weak self] _ in
            self?.paymentModel.getQRStatus { [weak self] success in
                guard success, let vc = self, let status = vc.paymentModel?.qrStatus?.qrStatus else { return }

                switch status {
                case .SCANNED, .BLOCKED:
                    vc.invalidateTimer()
                    DispatchQueue.main.async { [weak vc] in
                        guard let mainVC = vc else { return }
                        let loadingVC = LoadingViewController(paymentModel: mainVC.paymentModel)
                        mainVC.navigationController?.pushViewController(loadingVC, animated: true)
                        mainVC.didSelectPayment(type: .creditCard)
                    }
                default:
                    DispatchQueue.main.async { [weak vc] in
                        vc?.tableView.reloadData()
                    }
                }
            }
        }
    }

    private func invalidateTimer() {
        qrStatusTimer?.invalidate()
        qrStatusTimer = nil
    }

    private func loadHomebankCards() {
        paymentModel.loadHomebankCards { success in
            guard success else { return }
            DispatchQueue.main.async { [weak self] in
                guard let viewController = self else { return }
                if viewController.paymentModel.homebankCards.isEmpty {
                    viewController.paymentTypes.removeAll(where: { $0 == .halykID })
                }
                self?.tableView.reloadData()
            }
        }
    }

    private func requestGoBonus() {
        paymentModel.getGoBonus { [weak self] success in
            guard let vc = self, success else { return }
            let goBonus = vc.paymentModel.goBonusResponseBody.goBonus
            if goBonus > 0 {
                DispatchQueue.main.async {
                    let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PaymentInfoTableViewCell
                    cell.halykIdPaymentView.showBonusView(goBonus: goBonus)
                }
            }
        }
    }
    
    private func presentApplePayViewController() {
        guard let merchantId = paymentModel.authConfig.appleMerchantId else { return }

        let paymentNetworks: [PKPaymentNetwork] = [.amex, .discover, .masterCard, .visa]
        let paymentItem = PKPaymentSummaryItem(label: paymentModel.invoice.description, amount: NSDecimalNumber(value: paymentModel.invoice.amount), type: .final)

        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "KZT"
            request.countryCode = "KZ"
            request.merchantIdentifier = merchantId
            request.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
            request.supportedNetworks = paymentNetworks
            request.supportedCountries = ["KZ"]
            request.paymentSummaryItems = [paymentItem]

            if let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: request) {
                paymentViewController.delegate = self
                present(paymentViewController, animated: true)
            } else {
                showAlert(title: "Error", message: "Unable to present Apple Pay authorization", actionTitle: "OK")
            }
        } else {
            showAlert(title: "Error", message: "Unable to make Apple Pay transaction", actionTitle: "OK")
        }
    }

    private func dismissCardPickerView() {
        let pickerView = view.subviews.first { $0 is CardPickerView }
        pickerView?.removeFromSuperview()
    }

    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        dismissCardPickerView()
        view.removeGestureRecognizer(sender)
    }
}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoTableViewCell.cellId) as! PaymentInfoTableViewCell
        cell.delegate = self
        cell.colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        cell.publicProfile = paymentModel.publicProfile?.assets
        cell.paymentTag = 0
        cell.amount = paymentModel.invoice.amount
        cell.showQR = !isHomebankInstalled
        cell.paymentType = selectedPaymentType
        cell.qrImage = paymentModel.qrImage
        cell.set(card: paymentModel.selectedHomebankCard, isCardListEmpty: paymentModel.homebankCards.isEmpty)
        if paymentModel.installmentAvailable {
            cell.months = paymentModel.creditConditionsResponseBody?.map { $0.monthCount }
            cell.monthlyPaymentAmount = paymentModel.monthlyPayment
            cell.overpaymentAmount = paymentModel.overpaymentAmount
            cell.selectedMonthIndex = paymentModel.selectedMonthIndex
            cell.qrLinkInfo = paymentModel.linkInfo
            
            // QRImage is not updating fix
            UIView.performWithoutAnimation {
                tableView.performBatchUpdates(nil, completion: nil)
            }
        }
        if paymentModel.invoice.isMasterPass {
            cell.masterPassData = paymentModel.invoice.masterPass
        }
        
        if (paymentModel.invoice.email != nil) || (paymentModel.invoice.phone != nil){
            cell.preEmailandPhone(invoice: paymentModel.invoice)
        }
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return paymentTypesView }

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? OrderDetailsView
        header?.colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        header?.isAdditionalInfoEnabled = paymentViewSettings?.additionalInfo == true
        header?.isAdditionalInfoViewHidden = additionalInfoViewHidden
        header?.delegate = self
        header?.set(logoImage: paymentModel.logoImage)
        header?.set(orderNumber: paymentModel.invoice.id)
        header?.set(amount: paymentModel.invoice.amount)
        header?.set(description: paymentModel.invoice.description)
        header?.set(merchant: paymentModel.authConfig.merchantName)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section != 0 ? licenseView : nil
    }
}

extension MainViewController: OrderDetailsViewDelegate {

    func didTapMoreInfoView() {
        additionalInfoViewHidden.toggle()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension MainViewController: PaymentInfoTableViewCellDelegate {
    
    func requestGoBonus(pan: String, expDate: String, cvc: Int) {
        let text = "{\"hpan\":\"\(pan)\",\"expDate\":\"\(expDate)\",\"cvc\":\"\(cvc)\",\"terminalId\":\"\(paymentModel.authConfig.merchantId)\"}"
        let cryptogram = RSA.encrypt(string: text, publicKey: paymentModel.publicKey)
        paymentModel.cryptogram = cryptogram
        
        paymentModel.requestGoBonus { (success) in
            if success {
                DispatchQueue.main.async {
                    if let cellNotCasted = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                        let cell = cellNotCasted as! PaymentInfoTableViewCell
                        cell.creditCardPaymentView.showBonusView(goBonus: self.paymentModel.goBonusResponseBody.goBonus)
                    }
                }
            }
        }
    }
    
    func updateTableView() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func popMainViewController() {
        let dict = [
            "isSuccessful": false,
            "errorCode": -1,
            "errorMessage": String(
                Constants.Localizable.mainCancel
            ).localized()
            ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makePayment(pan: String, expDate: String, cvc: Int, name: String?, email: String?, phone: String?, useGoBonus: Bool, isMasterPass: Bool?, saveCard: Bool?) {
        var cryptogram = RSA.encrypt(string: "{\"hpan\":\"\(pan)\",\"expDate\":\"\(expDate)\",\"cvc\":\"\(cvc)\",\"terminalId\":\"\(paymentModel.authConfig.merchantId)\"}", publicKey: paymentModel.publicKey) ?? ""
        if isMasterPass == true {
            cryptogram = RSA.encrypt(string: "{\"hpan\":\"\",\"expDate\":\"\(expDate)\",\"cvc\":\"\(cvc)\",\"terminalId\":\"\(paymentModel.authConfig.merchantId)\"}", publicKey: paymentModel.publicKey) ?? ""
        }
        
        paymentModel.cryptogram = cryptogram
        paymentModel.name = name
        paymentModel.email = email
        paymentModel.phone = phone
        paymentModel.useGoBonus = useGoBonus
        paymentModel.saveCard = saveCard
        paymentModel.isMasterPass = (paymentModel.publicProfile?.assets?.payment_view_settings?.byMasterPass ?? false) && (isMasterPass ?? false)
        
        let vc = LoadingViewController(paymentModel: paymentModel)
        vc.makePayment()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showInstallmentSteps(with orderStatus: OrderStatus) {
        let vc = InstallmenStepsViewController(paymentModel: paymentModel)
        vc.orderStatus = orderStatus
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeInstallment() {
        guard let url = URL(string: paymentModel.linkInfo.deepLink) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func installmentMonthsChanged(to months: String) {
        paymentModel.installmentMonths = Int(months) ?? 0
        tableView.reloadData()
    }

    func showCardPicker(under cardView: UIView) {
        guard let halykIDPaymentView = cardView.superview else { return }
        let cardViewFrame = halykIDPaymentView.convert(cardView.frame, to: view)
        let shownPickerView = view.subviews.first { $0 is CardPickerView }

        if shownPickerView != nil {
            dismissCardPickerView()
        } else {
            let pickerView = CardPickerView(cards: paymentModel.homebankCards)
            pickerView.delegate = self
            let pickerViewY = cardViewFrame.origin.y + cardViewFrame.height + 4
            pickerView.frame = CGRect(x: cardViewFrame.origin.x, y: pickerViewY, width: cardViewFrame.width, height: 166)
            view.addSubview(pickerView)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    func makeHalykIDPayment(useGoBonus: Bool) {
        paymentModel.useGoBonus = useGoBonus

        let vc = LoadingViewController(paymentModel: paymentModel)
        vc.makePayment()
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapPayInHomebank() {
        guard let homebankLink = paymentModel.publicProfile?.homebankLink,
              let url = URL(string: homebankLink),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func didTapPayInHomebankInstallment(homebankLink: String) {
        guard let url = URL(string: homebankLink),
        UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func didTapApplePayButton() {
        presentApplePayViewController()
    }
}

extension MainViewController: ScanDelegate {
    func scanCard() {
        guard let vc = ScanViewController.createViewController(withDelegate: self) else {
            print("This device is incompatible with CardScan")
            return
        }
        
        DispatchQueue.main.async {
                    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized || AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
                        self.present(vc, animated: true)
                    } else {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                if granted {
                                    self.present(vc, animated: true)
                                } else {
                                    self.present(vc, animated: true)
                                }
                            }
                        })
                    }
        }
        
        
    }
    
    func userDidCancel(_ scanViewController: CardScan.ScanViewController) {
        scanViewController.dismiss(animated: true)
    }
    
    func userDidScanCard(_ scanViewController: CardScan.ScanViewController, creditCard: CardScan.CreditCard) {
        let cellNotCasted = self.tableView.visibleCells[0]
        if (cellNotCasted is PaymentInfoTableViewCell) {
            let cell = cellNotCasted as! PaymentInfoTableViewCell
            cell.creditCardPaymentView.creditCardView.cardNumber = creditCard.number
            cell.creditCardPaymentView.creditCardView.nameTextField.text = creditCard.name ?? ""
            if creditCard.expiryMonth != nil && creditCard.expiryYear != nil {
                cell.creditCardPaymentView.creditCardView.monthTextField.text = creditCard.expiryMonth ?? ""
                cell.creditCardPaymentView.creditCardView.yearTextField.text = creditCard.expiryYear ?? ""
            }
        }
        scanViewController.dismiss(animated: true)
    }
    
    func userDidSkip(_ scanViewController: CardScan.ScanViewController) {
        scanViewController.dismiss(animated: true)
    }
    
    
}

extension MainViewController: PaymentTypesViewDelegate {

    func didSelectPayment(type: PaymentType) {
        selectedPaymentType = type
        paymentModel.paymentType = type
        getQrStatusIfNeeded()
        tableView.reloadData()
    }
}

extension MainViewController: CardPickerViewDelegate {

    func didSelect(card: HomeBankCard) {
        paymentModel.selectedHomebankCard = card
        dismissCardPickerView()
        tableView.reloadData()

        if paymentModel.publicProfile?.assets?.payment_view_settings?.byGoBonuses == true {
            requestGoBonus()
        }
    }
}

extension MainViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true)
    }

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        if let paymentData = try? JSONSerialization.jsonObject(with: payment.token.paymentData) as? [String: Any] {
            paymentModel.applePayToken = paymentData
            print("dictionary", paymentData)
        }

        let text = "{\"hpan\":\"AppleToken\",\"expDate\":\"expToken\",\"cvc\":\"\",\"terminalId\":\"\(paymentModel.authConfig.merchantId)\"}"
        let cryptogram = RSA.encrypt(string: text, publicKey: paymentModel.publicKey)
        paymentModel.cryptogram = cryptogram

        let vc = LoadingViewController(paymentModel: paymentModel)
        vc.makePayment { success in
            completion(.init(status: success ? .success : .failure, errors: nil))
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let pickerView = view.subviews.first { $0 is CardPickerView }
        if pickerView?.bounds.contains(touch.location(in: pickerView)) == true {
            return false
        }
        return true
    }
}
