//
//  SettingRoom.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/06.
//

import Foundation
import UIKit

class SettingRoom: SettingRoomController {
    
    var roomInfo: Room
    
     
    override func touchCompleteButton(_ sender: UIBarButtonItem) {
        
        /* 현재 방 설정을 입력값으로 변경 */
        
        guard let title = roomTitleTextField?.text else {return}
        guard let gameType = gameTypeSegment?.selectedSegmentIndex else {return}
        guard let passwordTextField = self.passwordTextField else { return }
        
        var password = passwordTextField.text
        
        /* 비밀번호가 공백이거나 nil이면 nil값을 설정 */
        if password != nil && password!.isEmpty {
            password = nil
        }
        
        let roomInfo: [String:Any] = ["roomId": roomInfo.roomId, "title": title, "password": password, "gameType": games[gameType].type.rawValue, "subject": subjects[subject].category[category], "maxUser": maxUserNumber]
        
        SocketIOManager.shared.editRoom(room: roomInfo) { [weak self] status in
            
            switch status {
                
            case .success:
                self?.navigationController?.popViewController(animated: true)
                
            case .overCount:
                let alertController = UIAlertController(title: "알림", message: "설정한 최대 인원이 방의 인원보다 작습니다. ", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                self?.present(alertController, animated: true)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.completeButton?.isEnabled = true
        if let titleView = self.navigationItem.titleView as? UILabel {
            titleView.text = "방 설정 변경하기"
        }
        
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? RoomTitleCell {
            cell.inputTextField?.text = roomInfo.title
        }
        
        if let cell = cell as? RoomPasswordCell {
            let active = roomInfo.password != nil ? true : false
            cell.checkBox?.isOn = active
            cell.inputTextField?.text = roomInfo.password
            cell.inputTextField?.isEnabled = active
            cell.inputTextField?.isHidden = !active
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    init(userId:Int, roomInfo: Room){
        self.roomInfo = roomInfo
        super.init(userId: userId)
    }
    
}
