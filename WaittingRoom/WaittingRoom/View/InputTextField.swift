//
//  InputTextField.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/06.
//

import UIKit

class InputTextField: UITextField {
    
    private var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds.inset(by: padding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds.inset(by: padding))
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
