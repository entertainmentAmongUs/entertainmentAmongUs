//
//  HintCell.swift
//  GameRoom
//
//  Created by 김윤수 on 2022/03/06.
//

import UIKit

class HintCell: UITableViewCell {
    
    var chatting: UILabel?
    
    func addChattingLabel() {
        
        
        // chattingLabel Setting
        
        let chatting = UILabel()
        
        self.contentView.addSubview(chatting)
        
        chatting.font = UIFont.systemFont(ofSize: 18)
        chatting.numberOfLines = 0
        chatting.lineBreakMode = .byWordWrapping
        
        chatting.translatesAutoresizingMaskIntoConstraints = false
        chatting.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        chatting.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        chatting.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        chatting.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        self.chatting = chatting
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addChattingLabel()
    }

}
