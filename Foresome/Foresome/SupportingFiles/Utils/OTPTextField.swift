//
//  OTPTextField.swift
//  Pouch
//
//  Created by Raman choudhary on 06/02/23.
//

import Foundation
import UIKit

protocol MyOTPTFDelegate: AnyObject {
    func textFieldDidDelete(_ textField: UITextField)
}

class MyOTPTF: UITextField {
    weak var myDelegate: MyOTPTFDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(self)
    }
}
