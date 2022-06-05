//
//  RoomTitleCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class RoomTitleCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var inputTextField: UITextField?
    
    func addView() {
        
        let label = UILabel()
        
        contentView.addSubview(label)
        
        label.text = "방 제목"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true

        self.titleLabel = label
        
        let textField = UITextField()
        
        contentView.addSubview(textField)
        
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 25, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "방 제목을 입력하세요"
        textField.enablesReturnKeyAutomatically = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20).isActive = true
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        self.inputTextField = textField
        
        
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
        addView()
    }

}
