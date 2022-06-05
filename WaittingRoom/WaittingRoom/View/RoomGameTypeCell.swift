//
//  GameTypeCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class RoomGameTypeCell: UITableViewCell {
    
    var gameTypeLabel: UILabel?
    var segment: UISegmentedControl?
    var gameInfoLabel: UILabel?
    
    func addView(){
        
        let label = UILabel()
        
        contentView.addSubview(label)
        
        label.text = "게임 선택"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.gameTypeLabel = label
        
        
        /* 게임 설명을 표시하는 레이블을 설정 */
        let infoLabel = MessageLabel()
        
        contentView.addSubview(infoLabel)
        
        infoLabel.text = games[0].info
        infoLabel.font = .systemFont(ofSize: 25, weight: .regular)
        infoLabel.backgroundColor = .systemGray6
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.numberOfLines = 1
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.textAlignment = .center

//        infoLable.shadowColor = .white
//        infoLable.shadowOffset = CGSize(width: 3, height: 3)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        infoLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        infoLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        self.gameInfoLabel = infoLabel
        
        /* 게임 종류 변경 컨트롤 (세그먼트) */
        let segment = UISegmentedControl()
        
        contentView.addSubview(segment)
        
        segment.title(font: .systemFont(ofSize: 15, weight: .medium))
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 15).isActive = true
        segment.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20).isActive = true
        segment.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        segment.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        self.segment = segment
        
        
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
