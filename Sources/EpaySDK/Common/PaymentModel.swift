//
//  ViewModel.swift
//  EpaySDK
//
//  Created by a1pamys on 2/15/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

open class PaymentModel {
    
    // MARK: - Public properties
    
    var authConfig: AuthConfig
    var invoice: Invoice
    
    var name: String!
    var email: String!
    var phone: String!
    var useGoBonus: Bool!
    var installmentAvailable: Bool = false
    var homeBankInstalled: Bool
    var installmentMonths: Int = 3
    var linkInfo: QRLinkInfo {
        return QRLinkInfo(
            orderNumber: invoice.id,
            shopName: terminalsResponseBody.shop.merchant.companyName,
            creditPeriod: installmentMonths
        )
    }
    var cryptogram: String!
    var isMasterPass: Bool? = false
    var saveCard: Bool? {
        didSet {
            saveCard = invoice.cardSave ?? false
        }
    }
    lazy var publicKey = Constants.publicKey // prod
    var applePayToken: [String: Any]?
    
    var tokenResponseBody: TokenResponseBody!
    var paymentResponseBody: PaymentResponseBody!
    var goBonusResponseBody: GoBonusResponseBody!
    var errorResponseBody: ErrorResponseBody!
    var autoPaymentResponseBody: AutoPaymentResponseBody!
    var terminalsResponseBody: TerminalsResponseBody!
    var creditConditionsResponseBody: [CreditConditionResponseBody]?
    var orderStatus: OrderStatusResponseBody!
    var publicProfile: PublicProfileResponseBody?
    var qrStatus: QRResponseBody?
    var paymentType: PaymentType = .creditCard
    var logoImage: UIImage?
    var homebankCards: [HomeBankCard] = []
    var selectedHomebankCard: HomeBankCard?
    var transferResponseBody: TransferResponseBody?
    private let minimumAmmountToGetCredit: Double = 5000.0

    // MARK: - Private properties
    
    private var apiRequest = ApiRequest.shared
    
    // MARK: - Initializers
    
    public init(authConfig: AuthConfig, invoice: Invoice, homeBankInstalled: Bool = false) {
        self.authConfig = authConfig
        self.invoice = invoice
        self.homeBankInstalled = homeBankInstalled
    
        //@Dos added language change
        Bundle.setLanguage(lang: invoice.langApp ?? "ru")
    }
    
    // MARK: - Public methods
    
    public func requestToken(completion: @escaping (Bool) -> ()) {
        let body = TokenRequestBody(grantType: "client_credentials",
                                    scope: invoice.scope,
                                    clientId: authConfig.clientId,
                                    clientSecret: authConfig.clientSecret,
                                    invoiceId: invoice.id,
                                    amount: invoice.amount,
                                    currency: invoice.currency,
                                    terminal: authConfig.merchantId)
        
        if self.authConfig.appClipToken != nil {
            self.tokenResponseBody = TokenResponseBody(
                access_token: self.authConfig.appClipToken!,
                expires_in: "1200",
                scope: "payment",
                token_type: "Bearer"
            )
            completion(true)
        } else {
            apiRequest.requestToken(body: body) { (body, error) in
                if let body = body, error == nil {
                    self.tokenResponseBody = body
                    completion(true)
                } else {
                    let message = error!.localizedDescription
                    let error = ErrorResponseBody(message: message)
                    self.errorResponseBody = error
                    completion(false)
                }
            }
        }
    }

    public func loadPublicProfile(completion: @escaping (Bool) -> ()) {
        let token = tokenResponseBody.access_token
        let body = PublicProfileRequestBody(
            payerEmail: nil,
            payerPhone: nil,
            backLink: nil,
            failureLink: invoice.failurePostLink,
            postLink: invoice.postLink
        )
        apiRequest.loadPublicProfile(accessToken: token, body: body) { [weak self] body, error in
            guard let model = self else { return }
            if let body = body, error == nil {
                model.publicProfile = body

                if body.assets?.payment_view_settings?.logo == true {
                    model.loadLogoImage { completion(true) }
                } else {
                    completion(true)
                }
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                model.errorResponseBody = error
                completion(false)
            }
        }
    }
    
    public func getMasterPassCardData(completion: @escaping (Bool) -> ()) {
        let token = tokenResponseBody.access_token
        let body = MasterPassCardRequestBody(
            token: invoice.masterPass?.token ?? "",
            amount: invoice.amount,
            merchantName: invoice.masterPass?.merchantName ?? "",
            session: invoice.masterPass?.session ?? "",
            currencyCode: invoice.currency
        )
        apiRequest.getMasterPassCardData(token: token, body: body) { [weak self] body, error in
            guard let model = self else { return }
            if let body = body, error == nil {
                model.invoice.masterPass?.cardData = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                model.errorResponseBody = error
                completion(false)
            }
        }
    }

    public func loadLogoImage(completion: @escaping () -> ()) {
        guard let imageUrl = publicProfile?.assets?.logo_url else { return }
        apiRequest.loadImage(from: imageUrl) { [weak self] image in
            self?.logoImage = image
            completion()
        }
    }

    public func makePayment(completion: @escaping (Bool) -> ()) {
        let token = self.tokenResponseBody.access_token
        let body = PaymentRequestBody(amount: invoice.amount,
                                      currency: invoice.currency,
                                      name: name,
                                      cryptogram: cryptogram,
                                      invoiceId: invoice.id,
                                      description: invoice.description,
                                      accountId: invoice.accountId,
                                      email: email,
                                      phone: phone,
                                      postLink: invoice.postLink,
                                      backLink: invoice.backLink,
                                      failurePostLink: invoice.failurePostLink,
                                      failureBackLink: invoice.failureBackLink,
                                      useGoBonus: useGoBonus,
                                      cardSave: saveCard ?? false,
                                      paymentType: isMasterPass == false ? nil : "masterPass",
                                      masterpass: isMasterPass == false ? nil : invoice.masterPass
                                      
        )
        
        apiRequest.makePayment(accessToken: token, body: body) { (body, error) in
            if let body = body, error == nil {
                self.paymentResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self.errorResponseBody = error
                completion(false)
            }
        }
    }

    public func makePaymentWithApplePay(completion: @escaping (Bool) -> ()) {
        let token = self.tokenResponseBody.access_token
        let body = PaymentRequestBody(
            amount: invoice.amount,
            currency: invoice.currency,
            cryptogram: cryptogram,
            invoiceId: invoice.id,
            description: invoice.description,
            accountId: invoice.accountId,
            email: publicProfile?.assets?.email,
            phone: publicProfile?.assets?.phone,
            postLink: invoice.postLink,
            backLink: invoice.backLink,
            failurePostLink: invoice.failurePostLink,
            failureBackLink: invoice.failureBackLink,
            useGoBonus: false,
            cardSave: false,
            paymentType: "applePay",
            terminalId: authConfig.merchantId,
            applePayToken: applePayToken
        )
        apiRequest.makePayment(accessToken: token, body: body) { (body, error) in
            if let body = body, error == nil {
                self.paymentResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self.errorResponseBody = error
                completion(false)
            }
        }
    }

    func makeHalykIDPayment(completion: @escaping (Bool) -> ()) {
        let accessToken = tokenResponseBody.access_token
        let body = PaymentRequestBody(
            amount: invoice.amount,
            currency: invoice.currency,
            invoiceId: invoice.id,
            description: invoice.description,
            email: publicProfile?.assets?.email,
            phone: publicProfile?.assets?.phone,
            postLink: invoice.postLink,
            backLink: invoice.postLink,
            failurePostLink: invoice.failurePostLink,
            failureBackLink: invoice.failureBackLink,
            useGoBonus: useGoBonus,
            cardSave: false,
            not3d: false,
            paymentType: "halykId",
            osuvoxCardId: selectedHomebankCard?.systemAttributeId,
            terminalId: authConfig.merchantId
        )

        apiRequest.makePayment(accessToken: accessToken, homebankToken: invoice.homebankToken, body: body) { (body, error) in
            if let body = body, error == nil {
                self.paymentResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self.errorResponseBody = error
                completion(false)
            }
        }
    }
    
    func requestGoBonus(completion: @escaping (Bool) -> ()) {
        let token = self.tokenResponseBody.access_token
        let body = GoBonusRequestBody(cryptogram: cryptogram)
        apiRequest.requestGoBonus(token: token, body: body) { (body, error) in
            if let body = body, error == nil  {
                self.goBonusResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self.errorResponseBody = error
                completion(false)
            }
        }
    }
    
    func subscribeToAutoPayment(completion: @escaping (Bool) -> ()) {
        let token = tokenResponseBody.access_token
        let body = AutoPaymentRequestBody(transactionId: paymentResponseBody.id, paymentFrequency: invoice.autoPaymentFrequency)
        apiRequest.subscribeToAutoPayment(token: token, body: body, completion: { (body, error) in
            if let body = body, error == nil {
                self.autoPaymentResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self.errorResponseBody = error
                completion(false)
            }
        })
    }
    
    func getOrderStatus(completion: @escaping (Bool) -> ()) {
        let token = tokenResponseBody.access_token
        let orderId = invoice.id
        apiRequest.getOrderStatus(token: token, orderId: orderId) { (body, error) in
            if let body = body, error == nil {
                self.orderStatus = body
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func sendOrder(completion: @escaping () -> ()) {
        let token = tokenResponseBody.access_token
        let body = OrderRequestBody(
            shopId: terminalsResponseBody.shop.id,
            amount: invoice.amount,
            orderId: invoice.id,
            creditConditionId: creditConditionsResponseBody?.first?.id ?? ""
        )
        apiRequest.sendOrder(token: token, body: body) { (body, error) in
            completion()
        }
    }
    
    func getCreditCondition(completion: @escaping () -> ()) {
        let token = tokenResponseBody.access_token
        apiRequest.getCreditConditions(token: token, shopId: terminalsResponseBody.shop.id) { (body, error) in
            if let body = body, error == nil {
                self.creditConditionsResponseBody = body
                self.sendOrder(completion: completion)
                self.installmentAvailable = !body.isEmpty && self.invoice.amount >= self.minimumAmmountToGetCredit
            } else {
                completion()
            }
        }
    }
    
    func getTerminals(completion: @escaping () -> ()) {
        let token = tokenResponseBody.access_token
        let id = authConfig.merchantId
        apiRequest.getTerminals(token: token, id: id) { (body, error) in
            if let body = body, error == nil {
                self.terminalsResponseBody = body
                self.getCreditCondition(completion: completion)
            } else {
                completion()
            }
        }
    }
    
    func getInstallmentInfo(completion: @escaping () -> ()) {
        getTerminals(completion: completion)
    }

    func getQRStatus(completion: @escaping (Bool) -> ()) {
        let accessToken = tokenResponseBody.access_token
        apiRequest.getQRStatus(accessToken: accessToken) { [weak self] body, error in
            if let body = body, error == nil {
                self?.qrStatus = body
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func loadHomebankCards(completion: @escaping (Bool) -> ()) {
        guard let homebankToken = invoice.homebankToken else { return }
        apiRequest.loadHomebankCards(
            invoiceId: invoice.id,
            accessToken: tokenResponseBody.access_token,
            homebankToken: homebankToken
        ) { [weak self] cards, error in
            if error == nil {
                self?.homebankCards = cards
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func getGoBonus(completion: @escaping (Bool) -> ()) {
        guard let iban = selectedHomebankCard?.cardInfo?.iban, let homebankToken = invoice.homebankToken else { return }
        apiRequest.getGoBonusBy(
            iban: iban,
            terminalId: authConfig.merchantId,
            accessToken: tokenResponseBody.access_token,
            homebankToken: homebankToken
        ) { [weak self] body, error in
            if let body = body, error == nil  {
                self?.goBonusResponseBody = body
                completion(true)
            } else {
                let message = error!.localizedDescription
                let error = ErrorResponseBody(message: message)
                self?.errorResponseBody = error
                completion(false)
            }
        }
    }

    func makeTransfer(body: TransferRequestBody, completion: @escaping (Bool) -> ()) {
        guard let type = invoice.transferType else { return }
        let token = self.tokenResponseBody.access_token
        apiRequest.makeTransfer(for: type, accessToken: token, body: body) { [weak self] (body, error) in
            guard let model = self else  { return }
            if let body = body, error == nil {
                model.transferResponseBody = body
                completion(true)
            } else {
                if let errorResponse = error {
                    model.errorResponseBody = error
                }
                completion(false)
            }
        }
    }
}

struct RSA {
    
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        
        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }
    
    static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}

extension PaymentModel {

    var monthlyPayment: Double {
        guard let conditions = creditConditionsResponseBody,
              conditions.count > selectedMonthIndex
        else { return 0 }
        let creditCondition = conditions[selectedMonthIndex]
        let totalAmount = invoice.amount
        let monthlyPayment: Double
        if creditCondition.interestRate != 0 {
            let monthlyRate: Double = Double(creditCondition.interestRate) / 12 / 100
            let paymentsCount: Double = pow(Double(1 + monthlyRate), Double(creditCondition.monthCount))
            let monthlyRatio: Double = monthlyRate * (paymentsCount / (paymentsCount - 1))
            monthlyPayment = monthlyRatio * totalAmount
        } else {
            monthlyPayment = totalAmount / Double(creditCondition.monthCount)
        }
        return monthlyPayment
    }
    
    var overpaymentAmount: Double {
        guard let conditions = creditConditionsResponseBody,
              conditions.count > selectedMonthIndex
        else { return 0 }
        let creditCondition = conditions[selectedMonthIndex]
        var overpayment: Double = 0
        if creditCondition.interestRate != 0 {
            let totalAmount = invoice.amount
            let monthlyRate: Double = Double(creditCondition.interestRate) / 12 / 100
            let paymentsCount: Double = pow(Double(1 + monthlyRate), Double(creditCondition.monthCount))
            overpayment = monthlyRate * paymentsCount * totalAmount * Double(creditCondition.monthCount) / (paymentsCount - 1) - totalAmount
        }
        return overpayment
    }
    
    var selectedMonthIndex: Int {
        guard let index = creditConditionsResponseBody?.firstIndex(where: { $0.monthCount == installmentMonths }) else {
            return 0
        }
        return index
    }

    var qrImage: UIImage? { qrStatus?.qrImage ?? publicProfile?.qrImage }
}

extension PaymentModel {
    func getOrderStatus(every seconds: Int, completion: @escaping (OrderStatus, Timer) -> ()) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(seconds), repeats: true) { [weak self] timer in
            self?.getOrderStatus { success in
                guard success, let status = self?.orderStatus.name else { return }
                completion(status, timer)
            }
        }
    }
}
