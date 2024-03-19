//
//  PublicProfileResponseBody.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 22.02.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

struct PublicProfileResponseBody: Decodable {

    let assets: Assets?
    let QR: String?
    let homebankLink: String?
    let onlinebankLink: String?

    struct Assets: Decodable {
        let shop_name: String?
        let logo_url: String?
        let lang: String?
        let email: String?
        let phone: String?
        let color_scheme: ColorScheme?
        let logo: String?
        let logo_file_name: String?
        let payment_view_settings: PaymentViewSettings?
        let p2p_view_settings: P2PViewSettings?
        let payment_system_humo: Bool?
        let payment_system_uzcard: Bool?

        struct ColorScheme: Decodable {
            let bg: String?
            let card_bg: String?
            let buttons: String?
            let text: String?
            let card_text: String?
        }

        struct PaymentViewSettings: Decodable {
            let logo: Bool?
            let additionalInfo: Bool?
            let byCard: Bool?
            let byHalykID: Bool?
            let byPayByHBCredit: Bool?
            let byApplePay: Bool?
            let bySamsungPay: Bool?
            let byGooglePay: Bool?
            let byMasterPass: Bool?
            let byGoBonuses: Bool?
            let byQR: Bool?
            let userContactsByEmail: Bool?
            let userContactsAll: Bool?
            let attemptsInfo: Bool?
            let payerName: Bool?
        }

        struct P2PViewSettings: Decodable {
            let checkboxSaveCardSender: Bool?
            let checkboxSaveCardReceiver: Bool?
            let notificationByEmail: Bool?
        }
    }
}

extension PublicProfileResponseBody {

    var qrImage: UIImage? { QR?.image }
}

extension PublicProfileResponseBody.Assets.ColorScheme {

    private func linearGradientParams(
        from string: String,
        firstColorHex: String,
        secondColorHex: String
    ) -> (angle: Int, color1: UIColor?, color2: UIColor?) {
        var angle: Int = 225 // diagonal
        var firstColor: UIColor?
        var secondColor: UIColor?

        guard let firstIndex = string.firstIndex(of: "("),
              let endIndex = string.firstIndex(of: ")") else { return (angle, firstColor, secondColor) }

        let range = string.index(before: firstIndex)..<string.index(after: endIndex)
        let components = string[range].components(separatedBy: ",")
        let angleComponent = components.first { $0.contains("deg") }
        let firstColorComponent = components.first { $0.contains(firstColorHex) }
        let secondColorComponent = components.first { $0.contains(secondColorHex) }
        let firstAlphaComponent = firstColorComponent?.components(separatedBy: " ").last
        let secondAlphaComponent = secondColorComponent?.components(separatedBy: " ").last

        if let number = angleComponent?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(),
           let integer = Int(number) {
            angle = integer
        }
        if let number = firstAlphaComponent?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(),
           let alpha = Double(number) {
            firstColor = UIColor(hexString: firstColorHex).withAlphaComponent(alpha)
        }
        if let number = secondAlphaComponent?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(),
           let alpha = Double(number) {
            secondColor = UIColor(hexString: secondColorHex).withAlphaComponent(alpha)
        }

        return (angle, firstColor, secondColor)
    }

    var bgGradientParams: (angle: Int, color1: UIColor?, color2: UIColor?) {
        let _bg = bg ?? Constants.ColorScheme.bg
        guard let gradient = _bg.dictionary?["gradient"]  as? String ?? Constants.ColorScheme.bg.dictionary?["gradient"] as? String,
              let firstColorHex = _bg.dictionary?["color1"]  as? String ?? Constants.ColorScheme.bg.dictionary?["color1"] as? String,
              let secondColorHex = _bg.dictionary?["color2"]  as? String ?? Constants.ColorScheme.bg.dictionary?["color2"] as? String else {
            return linearGradientParams(from: "", firstColorHex: "", secondColorHex: "")
        }
        let params = linearGradientParams(from: gradient, firstColorHex: firstColorHex, secondColorHex: secondColorHex)

        if params.color1 == nil && params.color2 == nil {
            return (params.angle, bgFirstColor, bgSecondColor)
        } else {
            return params
        }
    }

    var bgFirstColor: UIColor? {
        let _bg = bg ?? Constants.ColorScheme.bg
        guard let dict = _bg.dictionary ?? Constants.ColorScheme.bg.dictionary, let hexString = dict["color1"] as? String else { return nil }
        return UIColor(hexString: hexString)
    }

    var bgSecondColor: UIColor? {
        let _bg = bg ?? Constants.ColorScheme.bg
        guard let dict = _bg.dictionary ?? Constants.ColorScheme.bg.dictionary, let hexString = dict["color2"] as? String else { return nil }
        return UIColor(hexString: hexString)
    }

    var cardBgGradientParams: (angle: Int, color1: UIColor?, color2: UIColor?) {
        let _cardBg = card_bg ?? Constants.ColorScheme.cardBg
        guard let gradient = _cardBg.dictionary?["gradient"]  as? String ?? Constants.ColorScheme.cardBg.dictionary?["gradient"] as? String,
              let firstColorHex = _cardBg.dictionary?["color1"]  as? String ?? Constants.ColorScheme.cardBg.dictionary?["color1"] as? String,
              let secondColorHex = _cardBg.dictionary?["color2"]  as? String ?? Constants.ColorScheme.cardBg.dictionary?["color2"] as? String else {
            return linearGradientParams(from: "", firstColorHex: "", secondColorHex: "")
        }
        let params = linearGradientParams(from: gradient, firstColorHex: firstColorHex, secondColorHex: secondColorHex)

        if params.color1 == nil && params.color2 == nil {
            return (params.angle, cardBgFirstColor, cardBgSecondColor)
        } else {
            return params
        }
    }

    var cardBgFirstColor: UIColor? {
        let _cardBg = card_bg ?? Constants.ColorScheme.cardBg
        guard let dict = _cardBg.dictionary ?? Constants.ColorScheme.cardBg.dictionary, let hexString = dict["color1"] as? String else { return nil }
        return UIColor(hexString: hexString)
    }

    var cardBgSecondColor: UIColor? {
        let _cardBg = card_bg ?? Constants.ColorScheme.cardBg
        guard let dict = _cardBg.dictionary ?? Constants.ColorScheme.cardBg.dictionary, let hexString = dict["color2"] as? String else { return nil }
        return UIColor(hexString: hexString)
    }

    var buttonsColor: UIColor? {
        return UIColor(hexString: buttons ?? Constants.ColorScheme.buttons)
    }

    var textColor: UIColor? {
        return UIColor(hexString: text ?? Constants.ColorScheme.text)
    }

    var cardTextColor: UIColor? {
        return UIColor(hexString: card_text ?? Constants.ColorScheme.cardText)
    }
}
