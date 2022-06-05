//
//  RoomPasswordCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class RoomPasswordCell: UITableViewCell {
    
    var passwordLabel: UILabel?
    var inputTextField: UITextField?
    
    func addView(){
        
        let label = UILabel()
        
        contentView.addSubview(label)
        
        label.text = "비밀번호 활성화"
        label.font = .systemFont(ofSize: 20 , weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        
        /* 방 비밀번호의 존재 여부에 따라 패스워드 입력 필드 상태 변경 */
        let active = false
        
        let checkBox = UISwitch()
        
        contentView.addSubview(checkBox)
        
        checkBox.addTarget(self, action: #selector(togglePasswordSwitch(_:)), for: .valueChanged)
        
        /* 스위치 크기 변경 */
        checkBox.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        checkBox.isOn = active
        
        
        let textField = UITextField()
        
        contentView.addSubview(textField)
        
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isEnabled = active
        textField.isHidden = !active
        textField.placeholder = "방 비밀번호를 입력하세요"
        textField.enablesReturnKeyAutomatically = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
        
        self.inputTextField = textField
        
    }
    
    @objc func togglePasswordSwitch(_ sender: UISwitch) {
        
        guard let text = self.inputTextField else {return}
        
        let isOn = sender.isOn
        text.isHidden = !isOn
        text.isEnabled = isOn
        
        text.text = nil
    
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
