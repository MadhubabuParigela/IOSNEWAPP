//
//  TextFieldMaxLengths.swift
//  ProfileApp
//


import UIKit
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLengthTextField: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLengthTextField)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c:String = ""
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}


