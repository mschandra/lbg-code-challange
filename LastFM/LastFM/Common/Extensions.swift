//
//  Extensions.swift
//  last-fm
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation
import  UIKit
// MARK: Date formatting extension
extension Date {
    var displayText : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}
// MARK: Add query param to NSURLComponents
extension NSURLComponents {
    func addParams(_ input:[String:String]){
        self.queryItems = []
        for (key,value) in input {
            self.queryItems?.append(URLQueryItem(name: key, value: value))
        }
    }
}
// MARK: Dateformatter for backendAPI
extension DateFormatter {
    static let backendAPIFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter
    }()
}
// MARK: Split mins into hour and min
extension Int {
    func minutesToHoursMinutes () -> (hours : Int , minutes : Int) {
        return (self / 60, (self % 60))
    }
}
extension Decimal {
    var int: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
// MARK: Extension to view controller to show error
extension UIViewController {
    func showError(message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))

        self.present(alert, animated: true, completion: nil)
    }
}
