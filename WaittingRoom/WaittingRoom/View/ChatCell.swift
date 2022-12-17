//
//  ChatCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/16.
//

import UIKit

class ChatCell: UITableViewCell {
    
    var nickname: UILabel?
    var chatting: UILabel?
    var profileImage: UIImageView?
    
    func addView() {
        
        let content = self.contentView
        content.backgroundColor = .systemGray6
        
        /* 프로필 이미지 */
        
        let imageSize = content.frame.width/8
        
        let imageView = UIImageView(image: UIImage(named: "ic_user_loading"))
        
        content.addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.backgroundColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: content.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        self.profileImage = imageView
        
        
        // 닉네임 레이블
        
        let nickname = UILabel()

        content.addSubview(nickname)
        
        nickname.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nickname.numberOfLines = 1
        nickname.lineBreakMode = .byTruncatingTail
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.topAnchor.constraint(equalTo: content.topAnchor, constant: 5).isActive = true
        nickname.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        nickname.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -5).isActive = true
        
        self.nickname = nickname
        
        
        // chattingLabel Setting
        
        let chatting = MessageLabel()
        
        content.addSubview(chatting)
        
        chatting.font = UIFont.systemFont(ofSize: 18)
        chatting.backgroundColor = .white
        
        chatting.translatesAutoresizingMaskIntoConstraints = false
        chatting.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 5).isActive = true
        chatting.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        chatting.trailingAnchor.constraint(lessThanOrEqualTo: content.trailingAnchor, constant: -10).isActive = true
        chatting.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -10).isActive = true
        
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
        self.addView()
//        self.addNicknameLabel()
//        self.addChattingLabel()
    }

}
