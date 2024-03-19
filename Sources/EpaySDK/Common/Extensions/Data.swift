//
//  Data.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 01.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

extension Data {

    var jsonString: String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self),
           let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
            return String(data: data, encoding: .utf8)
        }
        return String(data: self, encoding: .utf8)
    }
}

extension Encodable {

    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
