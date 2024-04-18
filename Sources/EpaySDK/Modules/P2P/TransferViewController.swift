//
//  TransferViewController.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 17.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit
import ContactsUI

class TransferViewController: UIViewController {

    enum TransferItem {
        case sender, arrow, receiver, phoneIIN, email, amount, buttons
    }

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let paymentModel: PaymentModel

    private let headerId = String(describing: TransferHeader.self)
    private let senderCellId = String(describing: TransferSenderCell.self)
    private let arrowCellId = String(describing: TransferArrowCell.self)
    private let receiverCellId = String(describing: TransferReceiverCell.self)
    private let phoneIINCellId = String(describing: TransferPhoneIINCell.self)
    private let emailCellId = String(describing: TransferEmailCell.self)
    private let amountCellId = String(describing: TransferAmountCell.self)
    private let buttonsCellId = String(describing: TransferButtonsCell.self)

    private let keyboardObserver = KeyboardObserver()
    private var items: [TransferItem] = []
    private var selectedPhoneNumber: String?

    init(paymentModel: PaymentModel) {
        self.paymentModel = paymentModel
        super.init(nibName: nil, bundle: nil)
        setItems()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        setLayoutConstraints()
        stylize()
        setupKeyboardObserver()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setItems() {
        guard let type = paymentModel.invoice.transferType else { return }
        switch type {
        case .P2P, .CardId, .masterPass: items = [.sender, .arrow, .receiver, .email, .amount, .buttons]
        case .AFT: items = [.sender, .email, .amount, .buttons]
        case .OCT: items = [.receiver, .email, .amount, .buttons]
        case .byPhone: items = [.phoneIIN, .email, .amount, .buttons]
        }
        if paymentModel.publicProfile?.assets?.p2p_view_settings?.notificationByEmail != true {
            items.removeAll { $0 == .email }
        }
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        if let params = colorScheme?.bgGradientParams, let color1 = params.color1, let color2 = params.color2 {
            view.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        } else {
            view.backgroundColor = .white
        }

        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransferHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(TransferSenderCell.self, forCellReuseIdentifier: senderCellId)
        tableView.register(TransferArrowCell.self, forCellReuseIdentifier: arrowCellId)        
        tableView.register(TransferReceiverCell.self, forCellReuseIdentifier: receiverCellId)
        tableView.register(TransferPhoneIINCell.self, forCellReuseIdentifier: phoneIINCellId)
        tableView.register(TransferEmailCell.self, forCellReuseIdentifier: emailCellId)
        tableView.register(TransferAmountCell.self, forCellReuseIdentifier: amountCellId)
        tableView.register(TransferButtonsCell.self, forCellReuseIdentifier: buttonsCellId)
    }

    private func setupKeyboardObserver() {
        keyboardObserver.observe { [weak self] (event) -> Void in
            guard let self = self else { return }
            switch event.type {
            case .willShow:
                let bottom: CGFloat
                if #available(iOS 11.0, *) {
                    bottom = event.keyboardFrameEnd.height - self.view.safeAreaInsets.bottom + 16
                } else {
                    bottom = event.keyboardFrameEnd.height + 16
                }
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options]) {
                    self.tableView.contentInset.bottom = bottom
                    self.tableView.scrollIndicatorInsets.bottom = bottom
                }
            case .willHide:
                UIView.animate(withDuration: event.duration, delay: 0.0, options: [event.options]) {
                    self.tableView.contentInset.bottom = 0
                    self.tableView.scrollIndicatorInsets.bottom = 0
                }
            default:
                break
            }
        }
    }

    @objc private func viewTapped() {
        view.endEditing(true)
    }

    private func showContacPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        present(contactPicker, animated: true)
    }
}

extension TransferViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let assets = paymentModel.publicProfile?.assets

        switch items[indexPath.row] {
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: senderCellId, for: indexPath) as! TransferSenderCell
            cell.colorScheme = assets?.color_scheme
            cell.publicProfile = assets
            cell.showSaveDataOption = assets?.p2p_view_settings?.checkboxSaveCardSender == true
            cell.card = paymentModel.invoice.sender
            return cell
        case .arrow:
            let cell = tableView.dequeueReusableCell(withIdentifier: arrowCellId, for: indexPath) as! TransferArrowCell
            return cell
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: receiverCellId, for: indexPath) as! TransferReceiverCell
            cell.colorScheme = assets?.color_scheme
            cell.showSaveDataOption = assets?.p2p_view_settings?.checkboxSaveCardReceiver == true
            cell.card = paymentModel.invoice.receiver
            return cell
        case .phoneIIN:
            let cell = tableView.dequeueReusableCell(withIdentifier: phoneIINCellId, for: indexPath) as! TransferPhoneIINCell
            cell.delegate = self
            cell.colorScheme = assets?.color_scheme
            cell.phoneNumber = selectedPhoneNumber
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: emailCellId, for: indexPath) as! TransferEmailCell
            cell.colorScheme = assets?.color_scheme
            return cell
        case .amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: amountCellId, for: indexPath) as! TransferAmountCell
            cell.amountEditable = paymentModel.invoice.amountEditable
            cell.set(amount: paymentModel.invoice.amount)
            return cell
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonsCellId, for: indexPath) as! TransferButtonsCell
            cell.delegate = self
            cell.colorScheme = assets?.color_scheme
            return cell
        }
    }
}

extension TransferViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! TransferHeader
        header.colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        return header
    }
}

extension TransferViewController: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            selectedPhoneNumber = phoneNumber
            tableView.reloadData()
        }
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if let phoneNumber = contactProperty.contact.phoneNumbers.first?.value.stringValue {
            selectedPhoneNumber = phoneNumber
            tableView.reloadData()
        }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true)
    }
}

extension TransferViewController: TransferPhoneIINCellDelegate {

    func didPressContactsButton() {
        showContacPicker()
    }
}

extension TransferViewController: TransferButtonsCellDelegate {

    func didPressTransferButton() {
        let senderIndex = items.firstIndex(of: .sender) ?? 0
        let senderIndexPath = IndexPath(row: senderIndex, section: 0)
        let senderCell = tableView.cellForRow(at: senderIndexPath) as? TransferSenderCell
        let sender = senderCell?.getSenderData()

        let receiver: TransferReceiver?
        if paymentModel.invoice.transferType == .byPhone {
            let receiverIndex = items.firstIndex(of: .phoneIIN) ?? 2
            let receiverIndexPath = IndexPath(row: receiverIndex, section: 0)
            let receiverCell = tableView.cellForRow(at: receiverIndexPath) as? TransferPhoneIINCell
            receiver = receiverCell?.getReceiverData()
        } else {
            let receiverIndex = items.firstIndex(of: .receiver) ?? 2
            let receiverIndexPath = IndexPath(row: receiverIndex, section: 0)
            let receiverCell = tableView.cellForRow(at: receiverIndexPath) as? TransferReceiverCell
            receiver = receiverCell?.getReceiverData()
        }

        if items.contains(.sender) && sender == nil { return }
        if (items.contains(.receiver) || items.contains(.phoneIIN)) && receiver == nil { return }
        guard let order = getTransferOrder() else { return }

        let card = TransferRequestBody.Card(sender: sender, receiver: receiver)
        let body = TransferRequestBody(order: order, card: card)

        let loadingVC = LoadingViewController(paymentModel: paymentModel)
        loadingVC.makeTransfer(requestBody: body)
        navigationController?.pushViewController(loadingVC, animated: true)
    }

    func didPressCancelButton() {
        let errorMessage = String(
            Constants.Localizable.mainCancel
        ).localized()
        let dict: [String: Any] = ["isSuccessful": false, "errorCode": -1, "errorMessage": errorMessage]
        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
}

extension TransferViewController {

    private func getTransferOrder() -> TransferRequestBody.Order? {
        var email: String?
        if paymentModel.publicProfile?.assets?.p2p_view_settings?.notificationByEmail == true {
            let emailIndex = items.firstIndex(of: .email) ?? items.count - 3
            let emailIndexPath = IndexPath(row: emailIndex, section: 0)
            let emailCell = tableView.cellForRow(at: emailIndexPath) as? TransferEmailCell
            email = emailCell?.getEmail()
            if email == nil { return nil }
        }
        let amountIndex = items.firstIndex(of: .amount) ?? items.count - 2
        let amountIndexPath = IndexPath(row: amountIndex, section: 0)
        let amountCell = tableView.cellForRow(at: amountIndexPath) as? TransferAmountCell
        let amount = amountCell?.getAmount()
        if amount == nil { return nil }

        return TransferRequestBody.Order(
            amount: amount,
            currency: "KZT",
            description: paymentModel.invoice.description,
            id: paymentModel.invoice.id,
            senderEmail: email,
            terminalId: paymentModel.authConfig.merchantId,
            postLink: paymentModel.invoice.postLink,
            failurePostLink: paymentModel.invoice.failurePostLink
        )
    }
}
