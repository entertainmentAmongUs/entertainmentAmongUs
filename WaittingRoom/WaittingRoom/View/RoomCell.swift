//
//  RoomCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/02.
//

import UIKit

class RoomCell: UITableViewCell {
    
    var gameTypeLabel: UILabel?
    var roomTitleLabel: UILabel?
    var keyImageView: UIImageView?
    var userCountLabel: UILabel?
 
    func addLabel(){
        
        let gameType = UILabel()
        
        gameType.font = UIFont.systemFont(ofSize: 15)
        gameType.lineBreakMode = .byTruncatingTail
        gameType.textAlignment = .left
        gameType.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        gameType.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        
        self.gameTypeLabel = gameType
        
        
        
        let roomTitle = UILabel()
        
        roomTitle.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        roomTitle.lineBreakMode = .byTruncatingTail
        roomTitle.textAlignment = .center
        roomTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
        roomTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        self.roomTitleLabel = roomTitle
        
        
    
        
        let image = UIImageView()
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.image = UIImage(systemName: "key")
        
        self.keyImageView = image
 
        
        
        let userCount = UILabel()
        
        userCount.font = UIFont.systemFont(ofSize: 15)
        userCount.lineBreakMode = .byWordWrapping
        userCount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        self.userCountLabel = userCount
        
        
        let stackView = UIStackView(arrangedSubviews: [gameType, roomTitle, image, userCount])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addLabel()

    }
    
}

