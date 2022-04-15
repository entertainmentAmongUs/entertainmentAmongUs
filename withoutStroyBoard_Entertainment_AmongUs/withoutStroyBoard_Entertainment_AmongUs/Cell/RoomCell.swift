//
//  RoomCell.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/05.
//

import UIKit

class RoomCell: UITableViewCell {
    
    var gameType: UILabel?
    var roomName: UILabel?
    var passWord: UILabel?
    var keyImage: UIImageView?
    var roomPersonNum: UILabel?
 
    func addgametypeLabel(){
        let gametype = UILabel()
        self.contentView.addSubview(gametype)
        
        gametype.font  = UIFont.systemFont(ofSize: 12, weight: .medium)
        gametype.numberOfLines = 0
        gametype.lineBreakMode = .byTruncatingTail
        gametype.textAlignment = .left
        
        gametype.translatesAutoresizingMaskIntoConstraints = false
        gametype.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        gametype.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5).isActive = true
        gametype.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.gameType = gametype
        
        
        
        let roomname = UILabel()
        self.contentView.addSubview(roomname)
        
        roomname.font  = UIFont.systemFont(ofSize: 12, weight: .medium)
        roomname.numberOfLines = 0
        roomname.lineBreakMode = .byTruncatingTail
        roomname.textAlignment = .left
        
        roomname.translatesAutoresizingMaskIntoConstraints = false
        roomname.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        roomname.leadingAnchor.constraint(equalTo: gametype.leadingAnchor,constant: 20).isActive = true
        roomname.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.roomName = roomname
        
        
    
        
        let imagekey = UIImageView()
        self.contentView.addSubview(imagekey)
                
        //imagekey.image = UIImage(systemName: "key")
        //imagekey.tintColor = .black
        imagekey.translatesAutoresizingMaskIntoConstraints = false
                
        imagekey.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        imagekey.leadingAnchor.constraint(equalTo: roomname.leadingAnchor,constant: 225).isActive = true
        imagekey.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.keyImage = imagekey
 
        
        
        
        
        guard let roomname = self.roomName else { return }
        
        let roompersonnum = UILabel()
        
        self.contentView.addSubview(roompersonnum)
        
        roompersonnum.font = UIFont.systemFont(ofSize: 12)
        roompersonnum.numberOfLines = 0
        roompersonnum.lineBreakMode = .byWordWrapping
        roomname.textAlignment = .center
        
        roompersonnum.translatesAutoresizingMaskIntoConstraints = false
        roompersonnum.topAnchor.constraint(equalTo: self.topAnchor,constant: 5).isActive = true
        roompersonnum.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -15).isActive = true
        
        self.roomPersonNum = roompersonnum

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
        self.addgametypeLabel()

    }
    
}
