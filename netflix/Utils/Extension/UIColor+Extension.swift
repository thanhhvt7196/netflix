//
//  UIColor+Extension.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hexString: String, alpha: Double = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        guard let hexValue = Int(string, radix: 16) else { return nil }
        var a = alpha
        if a < 0 { a = 0 }
        if a > 1 { a = 1 }

        let red = CGFloat((hexValue >> 16) & 0xff) / 255
        let green = CGFloat((hexValue >> 8) & 0xff) / 255
        let blue = CGFloat(hexValue & 0xff) / 255

        self.init(red: red, green: green, blue: blue, alpha: CGFloat(a))
    }

    func toImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    @nonobjc static let mediumGrey = UIColor(red: 77/255, green: 96/255, blue: 107/255, alpha: 1)
    @nonobjc static let darkViolet = UIColor(red: 37/255, green: 25/255, blue: 64/255, alpha: 1)
    @nonobjc static let lightViolet = UIColor(red: 85/255, green: 70/255, blue: 226/255, alpha: 1)
    @nonobjc static let tomato = UIColor(red: 160/255, green: 15/255, blue: 24/255, alpha: 1)
    @nonobjc static let darkBlue = UIColor(red: 12/255, green: 44/255, blue: 90/255, alpha: 1)
    @nonobjc static let mediumViolet = UIColor(red: 57/255, green: 32/255, blue: 143/255, alpha: 1)
    @nonobjc static let superOrange = UIColor(red: 242/255, green: 134/255, blue: 3/255, alpha: 1)
    @nonobjc static let darkOrange = UIColor(red: 185/255, green: 56/255, blue: 16/255, alpha: 1)
    @nonobjc static let darkTomato = UIColor(red: 88/255, green: 13/255, blue: 12/255, alpha: 1)
    @nonobjc static let lightCyan = UIColor(red: 111/255, green: 207/255, blue: 228/255, alpha: 1)
    @nonobjc static let brownGrey = UIColor(red: 77/255, green: 73/255, blue: 97/255, alpha: 1)
    @nonobjc static let mediumBlue = UIColor(red: 33/255, green: 53/255, blue: 121/255, alpha: 1)
    @nonobjc static let mediumLightBlue = UIColor(red: 23/255, green: 55/255, blue: 111/255, alpha: 1)
    @nonobjc static let mediumBrown = UIColor(red: 113/255, green: 66/255, blue: 35/255, alpha: 1)
    @nonobjc static let darkGreen = UIColor(red: 34/255, green: 56/255, blue: 37/255, alpha: 1)
    @nonobjc static let lightTomato = UIColor(red: 209/255, green: 9/255, blue: 7/255, alpha: 1)
    @nonobjc static let ultraLightOrange = UIColor(red: 255/255, green: 145/255, blue: 92/255, alpha: 1)
    @nonobjc static let ultraDarkBrown = UIColor(red: 42/255, green: 19/255, blue: 2/255, alpha: 1)
    @nonobjc static let lightGreen = UIColor(red: 56/255, green: 176/255, blue: 121/255, alpha: 1)
    @nonobjc static let semiDarkBlue = UIColor(red: 44/255, green: 49/255, blue: 123/255, alpha: 1)
    @nonobjc static let ultraDarkGrey = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
    @nonobjc static let ultraDarkBlue = UIColor(red: 42/255, green: 56/255, blue: 90/255, alpha: 1)
    @nonobjc static let mediumRed = UIColor(red: 147/255, green: 16/255, blue: 25/255, alpha: 1)
    @nonobjc static let normalBlue = UIColor(red: 25/255, green: 45/255, blue: 150/255, alpha: 1)
    @nonobjc static let darkPurple = UIColor(red: 76/255, green: 46/255, blue: 71/255, alpha: 1)
    @nonobjc static let semiDarkGreen = UIColor(red: 38/255, green: 88/255, blue: 57/255, alpha: 1)
    @nonobjc static let darkYellowGreen = UIColor(red: 86/255, green: 97/255, blue: 7/255, alpha: 1)
    @nonobjc static let ultraDarkGreyBrown = UIColor(red: 50/255, green: 37/255, blue: 33/255, alpha: 1)
    @nonobjc static let mediumLightGreen = UIColor(red: 45/255, green: 112/255, blue: 76/255, alpha: 1)
    @nonobjc static let lightOrange = UIColor(red: 235/255, green: 170/255, blue: 77/255, alpha: 1)
    @nonobjc static let mediumPink = UIColor(red: 158/255, green: 26/255, blue: 97/255, alpha: 1)
    @nonobjc static let themeOrange = UIColor(red: 240/255, green: 110/255, blue: 48/255, alpha: 1)
    @nonobjc static let borderGray = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
}
