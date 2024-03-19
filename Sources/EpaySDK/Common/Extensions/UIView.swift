//
//  UIView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/3/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(color: UIColor) {
        let v = UIView()
        v.backgroundColor = color
        self.init()
    }
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, right: superview?.rightAnchor, left: superview?.leftAnchor, bottom: superview?.bottomAnchor)
    }
    
    func fillToEdges(padding: CGFloat) {
        anchor(top: superview?.topAnchor, right: superview?.rightAnchor, left: superview?.leftAnchor, bottom: superview?.bottomAnchor, paddingTop: padding, paddingRight: padding, paddingLeft: padding, paddingBottom: padding)
    }
    
    func setGradientBackground(angle: Int = 225, colors: CGColor...) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.colors = colors
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer.startPoint = startAndEndPointsFrom(angle: angle).startPoint
        gradientLayer.endPoint = startAndEndPointsFrom(angle: angle).endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingRight: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

extension UIView {

    private func startAndEndPointsFrom(angle: Int) -> (startPoint: CGPoint, endPoint: CGPoint) {
        func degreesToRads(_ degree: Int) -> Double {
            return (Double(degree) * .pi / 180)
        }

        func opposite(of point: CGPoint) -> CGPoint {
            let originXValue = point.x
            let originYValue = point.y

            var oppositePoint = CGPoint()
            oppositePoint.x = 1.0 - originXValue
            oppositePoint.y = 1.0 - originYValue

            return oppositePoint
        }

        var startPointX: CGFloat = 1
        var startPointY: CGFloat = 0

        var startPoint:CGPoint
        var endPoint:CGPoint

        switch true {
        case angle == 0:
            startPointX = 0.5
            startPointY = 1.0
        case angle == 45:
            startPointX = 0.0
            startPointY = 1.0
        case angle == 90:
            startPointX = 0.0
            startPointY = 0.5
        case angle == 135:
            startPointX = 0.0
            startPointY = 0.0
        case angle == 180:
            startPointX = 0.5
            startPointY = 0.0
        case angle == 225:
            startPointX = 1.0
            startPointY = 0.0
        case angle == 270:
            startPointX = 1.0
            startPointY = 0.5
        case angle == 315:
            startPointX = 1.0
            startPointY = 1.0
            // Define calculated points
        case angle > 315 || angle < 45:
            startPointX = 0.5 - CGFloat(tan(degreesToRads(angle)) * 0.5)
            startPointY = 1.0
        case angle > 45 && angle < 135:
            startPointX = 0.0
            startPointY = 0.5 + CGFloat(tan(degreesToRads(90) - degreesToRads(angle)) * 0.5)
        case angle > 135 && angle < 225:
            startPointX = 0.5 - CGFloat(tan(degreesToRads(180) - degreesToRads(angle)) * 0.5)
            startPointY = 0.0
        case angle > 225 && angle < 359:
            startPointX = 1.0
            startPointY = 0.5 - CGFloat(tan(degreesToRads(270) - degreesToRads(angle)) * 0.5)
        default: break
        }

        startPoint = CGPoint(x: startPointX, y: startPointY)
        endPoint = opposite(of: startPoint)

        return (startPoint, endPoint)
    }
}

extension UIApplication {

    static func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
   }
}
