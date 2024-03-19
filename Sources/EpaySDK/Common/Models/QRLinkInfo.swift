//
//  QRInfo.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 15.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

struct QRLinkInfo {
    var orderNumber: String = ""
    var shopName: String = ""
    var creditPeriod: Int = 0
    
    var link: String {
        return "https://developer.homebank.kz/epay?orderNumber=\(orderNumber)&shopName=\(shopName)&creditPeriod=\(creditPeriod)"
    }
    
    var deepLink: String {
        return "homebank://epay?orderNumber=\(orderNumber)&shopName=\(shopName)&creditPeriod=\(creditPeriod)"
    }

    var customLink: String = ""
}

extension String {
    var image: UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
