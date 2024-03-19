//
//  NetworkLogger.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 01.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

class NetworkLogger {

    /// Network request logging
    class func log(request: URLRequest) {
        DispatchQueue.main.async { Self.log(request) }
    }

    private class func log(_ request: URLRequest) {
        var log = ""

        log += "\n" + [String](repeating: "☰", count: 64).joined() + "\n\n"
        log += "➤ REQUEST TIME: " + Date().description + "\n\n"
        log += Self.getLog(for: request)
        log += [String](repeating: "☰", count: 64).joined() + "\n\n"

        print(log)
    }

    private class func getLog(for request: URLRequest) -> String {
        var log = ""

        if let url = request.url,
           let method = request.httpMethod {
            var urlString = url.absoluteString
            if urlString.last == "?" { urlString.removeLast() }
            log += "➤ URL: " + urlString + "\n\n"
            log += "➤ METHOD: " + method + "\n\n"
        }

        if let headerFields = request.allHTTPHeaderFields,
           !headerFields.isEmpty,
           let data = try? JSONSerialization.data(withJSONObject: headerFields, options: [.prettyPrinted]),
           let jsonString = Self.convertToPrintableJSON(data) {
            log += "➤ REQUEST HEADERS: " + jsonString + "\n\n"
        }

        if let data = request.httpBody {
            if let jsonString = convertToPrintableJSON(data) {
                log += "➤ REQUEST BODY: " + jsonString + "\n\n"
            } else {
                log += "➤ REQUEST BODY (FAILED TO PRINT)\n\n"
            }
        }

        return log
    }

    /// Network response logging
    class func log(request: URLRequest, response: HTTPURLResponse?, responseData: Data?, error: NSError?) {
        DispatchQueue.main.async { Self.log(request, response, responseData, error) }
    }

    private class func log(
        _ request: URLRequest,
        _ response: HTTPURLResponse?,
        _ responseData: Data?,
        _ error: NSError?
    ) {
        var log = ""

        log += "\n" + [String](repeating: "☰", count: 64).joined() + "\n\n"

        log += "➤ RESPONSE TIME: " + Date().description + "\n\n"

        if let statusCode = response?.statusCode {
            let emoji: String
            if let response = response, 200..<300 ~= response.statusCode {
                emoji = "✅"
            } else {
                emoji = "⚠️"
            }
            log += "➤ STATUS CODE: " + statusCode.description + " " + emoji + "\n\n"
        }

        log += Self.getLog(for: request)

        if let headerFields = response?.allHeaderFields,
           !headerFields.isEmpty,
           let data = try? JSONSerialization.data(withJSONObject: headerFields, options: [.prettyPrinted]),
           let jsonString = Self.convertToPrintableJSON(data) {
            log += "➤ RESPONSE HEADERS: " + jsonString + "\n\n"
        }

        if let data = responseData {
            if let jsonString = convertToPrintableJSON(data) {
                log += "➤ RESPONSE BODY: " + jsonString + "\n\n"
            } else {
                log += "➤ RESPONSE BODY (FAILED TO PRINT)\n\n"
            }
        }

        if let error = error {
            log += "➤ ERROR: " + error.localizedDescription + "\n\n"
        }
        log += [String](repeating: "☰", count: 64).joined() + "\n\n"

        print(log)
    }

    private class func convertToPrintableJSON(_ data: Data) -> String? {
        guard var jsonString = data.jsonString else { return nil }

        let specials = [("\\/", "/"), ("\\t", "\t"), ("\\n", "\n"), ("\\r", "\r"), ("\\\"", "\""), ("\\\'", "\'")]
        for special in specials {
            jsonString = jsonString.replacingOccurrences(of: special.0, with: special.1, options: .literal)
        }
        jsonString = jsonString.replacingOccurrences(of: "\" : ", with: "\": ", options: .literal)

        return jsonString
    }
}
