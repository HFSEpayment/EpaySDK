//
//  ApiRequest.swift
//  EpaySDK
//
//  Created by a1pamys on 2/15/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

struct ApiRequest {
    
    // MARK: - Public properties
    
    static var shared = ApiRequest()
    
    // MARK: - Initializers
    
    init() {}
    
    // MARK: - Public methods
    public func requestToken(body: TokenRequestBody,
                             completion: @escaping (TokenResponseBody?, Error?) -> Void) {
        let urlString = "\(Constants.Url.auth)/oauth2/token"
        let urlAllowed: CharacterSet =
            .alphanumerics.union(.init(charactersIn: "-._~"))
        let params: [String: Any] = [
            "grant_type": body.grantType.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "scope": body.scope.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "client_id": body.clientId.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "client_secret": body.clientSecret.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "amount": body.amount,
            "currency": body.currency.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "terminal": body.terminal.addingPercentEncoding(withAllowedCharacters: urlAllowed) ?? "",
            "invoiceID": body.invoiceId
        ]
        
        let body = String.formatDictToString(params).data(using: .utf8, allowLossyConversion: false)!
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: [:], httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(TokenResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    public func loadPublicProfile(
        accessToken: String,
        body: PublicProfileRequestBody,
        completion: @escaping (PublicProfileResponseBody?, Error?) -> Void
    ) {
        let urlString = "\(Constants.Url.base)/public-profile"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
        let params: [String: Any] = ["failureLink": body.failureLink, "postLink": body.postLink]
        let body = try! JSONSerialization.data(withJSONObject: params, options: [])

        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(PublicProfileResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func makePayment(
        accessToken: String,
        homebankToken: String? = nil,
        body: PaymentRequestBody,
        completion: @escaping (PaymentResponseBody?, Error?) -> Void
    ) {
        let urlString = "\(Constants.Url.base)/payment/cryptopay"
        var params: [String: Any] = [
            "amount": body.amount,
            "currency": body.currency,
            "invoiceId": body.invoiceId,
            "postLink": body.postLink,
            "failurePostLink": body.failurePostLink,
            "useBonus": body.useGoBonus,
            "cardSave": body.cardSave
        ]
        if let name = body.name {
            params["name"] = name
        }
        if let cryptogram = body.cryptogram {
            params["сryptogram"] = cryptogram
        }
        if let description = body.description {
            params["description"] = description
        }
        if let accountId = body.accountId {
            params["accountId"] = accountId
        }
        if let email = body.email {
            params["email"] = email
        }
        if let phone = body.phone {
            params["phone"] = phone
        }
        if let not3d = body.not3d {
            params["not3d"] = not3d
        }
        //@Dos added language for 3DSecure
        if let language = body.language {
            params["language"] = language
        }
        
        if let paymentType = body.paymentType {
            params["paymentType"] = paymentType
        }
        if let osuvoxCardId = body.osuvoxCardId {
            params["osuvoxCardId"] = osuvoxCardId
        }
        if let terminalId = body.terminalId {
            params["terminalId"] = terminalId
        }
        if let applePayToken = body.applePayToken {
            params["applePay"] = applePayToken
        }
        if let backLink = body.backLink {
            params["backLink"] = backLink
        }
        if let failureBackLink = body.failureBackLink {
            params["failureBackLink"] = failureBackLink
        }
        
        if let masterpass = body.masterpass {
            var masterPassAction: [String: Any] = [
                "SaveCard": body.cardSave,
                "updateSaveCard": body.cardSave,
                "recurring": body.masterpass?.masterPassAction.recurring ?? false
            ]
            var masterPassBody: [String: Any] = [
                "token": body.masterpass?.token ?? "",
                "merchantName": body.masterpass?.merchantName ?? "",
                "session": body.masterpass?.session ?? "",
                "isClientParticipation": body.masterpass?.isClientParticipation ?? false,
                "isVisible": body.masterpass?.isVisible ?? false,
                "MasterPassAction": masterPassAction
                
            ]
            params["masterpass"] = masterPassBody
        }

        //@Dos changed variable name from body to convert
        let convert = try! JSONSerialization.data(withJSONObject: params, options: [])
        var headers: [String: String] = ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)", "Platform": "SDK IOS"]

        if let homebankToken = homebankToken {
            headers["x-homebank-auth"] = "Bearer " + homebankToken
        }
        
        //@Dos added additional header
//        if let applePayToken = body.applePayToken {
//            headers["Self-Cert"] = "true"
//        }
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: convert) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(PaymentResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func requestGoBonus(token: String,
                               body: GoBonusRequestBody,
                               completion: @escaping (GoBonusResponseBody?, Error?) -> Void)
    {
        let urlString = "\(Constants.Url.base)/payment/checkgobonus"
        let params: [String: Any] = ["сryptogram": body.cryptogram]
        
        let body = try! JSONSerialization.data(withJSONObject: params, options: [])
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(GoBonusResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    public func subscribeToAutoPayment(token: String, body: AutoPaymentRequestBody, completion: @escaping (AutoPaymentResponseBody?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/recurrent/subscribe"
        let params: [String: Any] = [
            "transactionId": body.transactionId,
            "paymentFrequency": body.paymentFrequency.rawValue
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: params, options: [])
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let res = try decoder.decode(AutoPaymentResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func sendOrder(token: String, body: OrderRequestBody, completion: @escaping (OrderResponseBody?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/order"
        let params: [String: Any] = [
            "shopId": body.shopId,
            "amount": body.amount,
            "orderId": body.orderId,
            "creditConditionId": body.creditConditionId
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: params, options: [])
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(OrderResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    public func getMasterPassCardData(token: String, body: MasterPassCardRequestBody, completion: @escaping (MasterPassCardData?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/masterpass/getCard"
        let params: [String: Any] = [
            "Token": body.token,
            "Amount": body.amount,
            "MerchantName": body.merchantName,
            "Session": body.session,
            "CurrencyCode": body.currencyCode,
            "OriginalOrderId": ""
        ]
        
        let body = try! JSONSerialization.data(withJSONObject: params, options: [])
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .post, headers: headers, httpBody: body) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(MasterPassCardData.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        
    }
    
    public func getCreditConditions(token: String, shopId: String, completion: @escaping ([CreditConditionResponseBody]?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/credit-condition?shopId=\(shopId)"
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode([CreditConditionResponseBody].self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getTerminals(token: String, id: String, completion: @escaping (TerminalsResponseBody?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/terminals/\(id)"
        
        //let body = try! JSONSerialization.data(withJSONObject: [], options: [])
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(TerminalsResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getOrderStatus(token: String, orderId: String, completion: @escaping (OrderStatusResponseBody?, Error?) -> Void) {
        let urlString = "\(Constants.Url.base)/order/status?orderId=\(orderId)"

        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(OrderStatusResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    public func getQRStatus(
        accessToken: String,
        completion: @escaping (QRResponseBody?, Error?) -> Void
    ) {
        let urlString = Constants.Url.base + "/qr"
        let headers = ["Authorization": "Bearer \(accessToken)"]

        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { (data, error) in
            if let data = data, error == nil {
                do {
                    let res = try JSONDecoder().decode(QRResponseBody.self, from: data)
                    completion(res, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    public func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if (url.isEmpty == true) {
            completion(nil)
        } else {
            openUrlSessionWith(urlString: url, httpMethod: .get, headers: [:], httpBody: nil) { data, error in
                if let data = data, error == nil {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func loadHomebankCards(
        invoiceId: String,
        accessToken: String,
        homebankToken: String,
        completion: @escaping ([HomeBankCard], Error?) -> Void
    ) {
        let urlString = Constants.Url.base + "/hb-cards?invoiceId=" + invoiceId
        let headers = ["Authorization": "Bearer \(accessToken)", "x-homebank-auth": "Bearer " + homebankToken]

        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { data, error in
            if let data = data, error == nil {
                do {
                    let cards = try JSONDecoder().decode([HomeBankCard].self, from: data)
                    completion(cards, nil)
                } catch {
                    completion([], error)
                }
            } else {
                completion([], error)
            }
        }
    }

    func getGoBonusBy(
        iban: String,
        terminalId: String,
        accessToken: String,
        homebankToken: String,
        completion: @escaping (GoBonusResponseBody?, Error?) -> Void
    ) {
        let urlString = Constants.Url.base + "/payment/bonus-by-iban?iban=\(iban)&terminalId=\(terminalId)"
        let headers = ["Authorization": "Bearer \(accessToken)", "x-homebank-auth": "Bearer " + homebankToken]

        openUrlSessionWith(urlString: urlString, httpMethod: .get, headers: headers, httpBody: nil) { data, error in
            if let data = data, error == nil {
                do {
                    let cards = try JSONDecoder().decode(GoBonusResponseBody.self, from: data)
                    completion(cards, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    public func makeTransfer(
        for transferType: TransferType,
        accessToken: String,
        body: TransferRequestBody,
        completion: @escaping (TransferResponseBody?, ErrorResponseBody?) -> Void
    ) {
        var url = Constants.Url.base
        switch transferType {
        case .P2P, .CardId, .masterPass: url += "/p2p/transfer"
        case .AFT: url += "/chdebit/transfer"
        case .OCT, .byPhone: url += "/chpayment/transfer"
        }
        let headers: [String: String] = ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
        let parameters: [String: Any] = body.dictionary ?? [:]

        openUrlSessionWith(urlString: url, httpMethod: .post, headers: headers, httpBody: parameters) { (data, error) in
            if let data = data, error == nil {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponseBody.self, from: data) {
                    completion(nil, errorResponse)
                } else {
                    do {
                        let res = try JSONDecoder().decode(TransferResponseBody.self, from: data)
                        completion(res, nil)
                    } catch {
                        completion(nil, ErrorResponseBody(message: error.localizedDescription))
                    }
                }
            } else {
                completion(nil, ErrorResponseBody(message: error?.localizedDescription ?? ""))
            }
        }
    }
    
    func openUrlSessionWith(urlString: String, httpMethod: HTTPMethod, headers: [String: String], httpBody: Any?, completion: @escaping (Data?, Error?) -> ()) {
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if httpBody is [String: Any] {
            let body = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
            request.httpBody = body
        } else if httpBody is Data {
            request.httpBody = (httpBody as! Data)
        }
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key)}
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            NetworkLogger.log(
                request: request,
                response: response as? HTTPURLResponse,
                responseData: data,
                error: error as NSError?
            )

            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }.resume()
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}

extension URLRequest {
    
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
