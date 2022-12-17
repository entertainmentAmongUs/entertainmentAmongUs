//
//  MessageLabel.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class MessageLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.right + padding.left
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }
    
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: padding))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
