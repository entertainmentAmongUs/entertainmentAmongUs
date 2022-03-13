
import UIKit

class ChatCell: UITableViewCell {
    
    var nickname: UILabel?
    var chatting: UILabel?
    
    func addNicknameLabel() {
        
        // nicknameLabel Setting
        
        let nickname = UILabel()

        self.contentView.addSubview(nickname)
        
        nickname.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nickname.numberOfLines = 1
        nickname.lineBreakMode = .byTruncatingTail
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        nickname.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        nickname.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.nickname = nickname
        
    }
    
    func addChattingLabel() {
        
        guard let nickname = self.nickname else {
            return
        }
        
        // chattingLabel Setting
        
        let chatting = UILabel()
        
        self.contentView.addSubview(chatting)
        
        chatting.font = UIFont.systemFont(ofSize: 18)
        chatting.numberOfLines = 0
        chatting.lineBreakMode = .byWordWrapping
        
        chatting.translatesAutoresizingMaskIntoConstraints = false
        chatting.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        chatting.leadingAnchor.constraint(equalTo: nickname.trailingAnchor, constant: 5).isActive = true
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
        
        self.addNicknameLabel()
        self.addChattingLabel()
    }

}
