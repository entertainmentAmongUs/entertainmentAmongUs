//
//  SettingRoomController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit
import AlertsAndPickers

class SettingRoomController: UITableViewController {
    
    // MARK: - Properties
    
    var myUserId: Int
    var maxUserNumber = 3 {
        willSet {
            self.maxUserNumberButton?.setTitle("\(newValue)명", for: .normal)
        }
    }
    var subject = 0 {
        willSet {
            self.subjectButton?.setTitle(subjects[newValue].title, for: .normal)
        }
    }
    var category = 0 {
        willSet {
            self.categoryButton?.setTitle(subjects[subject].category[newValue], for: .normal)
        }
    }
    
    var roomTitleTextField: UITextField?
    var passwordTextField: UITextField?
    var passwordCheckBox: UISwitch?
    var gameTypeSegment: UISegmentedControl?
    var maxUserNumberButton: UIButton?
    var subjectButton: UIButton?
    var categoryButton: UIButton?
    
    var completeButton: UIBarButtonItem?
    var cancleButton: UIBarButtonItem?
    
    /* Cell Identifier */
    
    let cellIdentifiers = ["titleCell", "passwordCell", "gameTypeCell", "maxUserCell", "subjectCell"]
    
    // MARK: - Method
    
    func registerCell() {
        
        self.tableView.register(RoomTitleCell.self, forCellReuseIdentifier: cellIdentifiers[0])
        self.tableView.register(RoomPasswordCell.self, forCellReuseIdentifier: cellIdentifiers[1])
        self.tableView.register(RoomGameTypeCell.self, forCellReuseIdentifier: cellIdentifiers[2])
        self.tableView.register(RoomMaxUserCell.self, forCellReuseIdentifier: cellIdentifiers[3])
        self.tableView.register(RoomSubjectCell.self, forCellReuseIdentifier: cellIdentifiers[4])
        
    }
    
    func setNavigationController() {
        
        /* 네비게이션 아이템 설정 */
        let naviItem = self.navigationItem
        
        let titleView: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .black
            label.text = "방 만들기"
            label.textAlignment = .center
            
            return label
            
        }()
        
        naviItem.titleView = titleView
        
        
        let completeButton = UIBarButtonItem(image: UIImage(systemName: "checkmark")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchCompleteButton(_:)))
        completeButton.isEnabled = false
        
        let cancleButton = UIBarButtonItem(image: .init(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchCancleButton(_:)))
        
        naviItem.setRightBarButtonItems([completeButton], animated: true)
        naviItem.setLeftBarButton(cancleButton, animated: true)
        
        self.completeButton = completeButton
        self.cancleButton = cancleButton
        
        
    }
    
    // MARK: - Action
    
    @objc func touchCancleButton(_ sender: UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func touchSubjectButton(_ sender: UIButton){
        
        let alert = UIAlertController(title: "주제", message: "게임에 사용할 주제를 선택하세요", preferredStyle: .actionSheet)
        
        let subjectValue = (0..<subjects.count).map { $0 }
        let pickerViewValues: [[String]] = [subjectValue.map { subjects[$0].title }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: subject)
        
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {
            [unowned self] vc, picker, index, values in
            self.subject = index.row
            self.category = 0
        }
        
        alert.addAction(title: "확인", style: .cancel)
        
        self.present(alert, animated: true)
        
        
    }
    
    @objc func touchCategoryButton(_ sender: UIButton){
        
        let alert = UIAlertController(title: "카테고리", message: "세부 카테고리를 선택하세요", preferredStyle: .actionSheet)
        
        let subjectIndex = subjects[subject].category
        let pickerViewValues = [subjectIndex]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: category)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {
            [unowned self] vc, picker, index, values in
            
            self.category = index.row
        }
        
        alert.addAction(title: "확인", style: .cancel)
        
        self.present(alert, animated: true)
        
    }
    
    @objc func touchMaxUserButton(_ sender: UIButton) {
        
        guard let gameIndex = gameTypeSegment?.selectedSegmentIndex else { return }

        let alert = UIAlertController(title: "최대 인원", message: "방에 입장할 수 있는 최대 인원 수를 선택하세요", preferredStyle: .actionSheet)

        let userNumbers: [Int] = (3...games[gameIndex].maxUserNumber).map { Int($0) }
        let pickerViewValues: [[String]] = [userNumbers.map { "\($0)명" }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: maxUserNumber-3)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {
            [unowned self] vc, picker, index, values in
            
            self.maxUserNumber = userNumbers[index.row]
        }
        
        alert.addAction(title: "확인", style: .cancel)
        
        self.present(alert, animated: true)
        
    }
    
    @objc open func touchCompleteButton(_ sender: UIBarButtonItem) {
        
        /* 현재 방 설정을 입력값으로 변경 */
        
        guard let title = roomTitleTextField?.text else {return}
        guard let gameType = gameTypeSegment?.selectedSegmentIndex else {return}
        guard let passwordTextField = self.passwordTextField else { return }

        var password = passwordTextField.text
        
        /* 비밀번호가 공백이거나 nil이면 nil값을 설정 */
        if password != nil && password!.isEmpty {
            password = nil
        }
        
        let newRoom: [String:Any] = ["userId": myUserId, "title": title, "password": password, "gameType": games[gameType].type.rawValue, "subject": subjects[subject].category[category], "maxUser": maxUserNumber]
         
        SocketIOManager.shared.createRoom(room: newRoom)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    
    // MARK: - LifeCycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        
        self.setNavigationController()
        self.tableView.allowsSelection = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.section], for: indexPath)
        
        if let titleCell = cell as? RoomTitleCell {
            self.roomTitleTextField = titleCell.inputTextField
            
            roomTitleTextField?.delegate = self
        }
        
        if let passwordCell = cell as? RoomPasswordCell {
            self.passwordTextField = passwordCell.inputTextField
            self.passwordCheckBox = passwordCell.checkBox
            passwordTextField?.delegate = self
        }
        
        if let gameTypeCell = cell as? RoomGameTypeCell {
            
            guard let segment = gameTypeCell.segment else { return gameTypeCell }
            guard let infoLabel = gameTypeCell.gameInfoLabel else { return gameTypeCell }
            
            for i in 0...games.count-1 {
                /* 세그먼트 변경에 대한 액션 */
                let action = UIAction { [unowned self] _ in
                    
                    infoLabel.text = games[i].info
                    
                    /* 최소 인원으로 변경 */
                    self.maxUserNumber = 3

                }
                action.title = games[i].title
                segment.insertSegment(action: action, at: i, animated: true)
            }
            
            segment.selectedSegmentIndex = 0
            
            self.gameTypeSegment = segment
            
        }
        
        if let maxUserCell = cell as? RoomMaxUserCell {
            
            guard let button = maxUserCell.maxUserNumberButton else { return maxUserCell }
            
            button.setTitle("\(maxUserNumber)명", for: .normal)
            button.addTarget(self, action: #selector(touchMaxUserButton(_:)), for: .touchUpInside)
            
            self.maxUserNumberButton = button
            
        }
        
        if let subjectCell = cell as? RoomSubjectCell {
            
            guard let subject = subjectCell.subjectButton else { return subjectCell }
            guard let category = subjectCell.categoryButton else { return subjectCell }
            
            subject.setTitle(subjects[self.subject].title, for: .normal)
            subject.addTarget(self, action: #selector(touchSubjectButton(_:)), for: .touchUpInside)
            
            category.setTitle(subjects[self.subject].category[self.category], for: .normal)
            category.addTarget(self, action: #selector(touchCategoryButton(_:)), for: .touchUpInside)
            
            self.subjectButton = subject
            self.categoryButton = category
            
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    init(userId: Int){
        self.myUserId = userId
        super.init(nibName: nil, bundle: nil)
        
        self.registerCell()
        
    }
    
    deinit {
        print("룸 생성 메모리 해제")
    }

}

extension SettingRoomController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == roomTitleTextField {
            
            if let text = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) {
                completeButton?.isEnabled = text.isEmpty ? false : true
            } else {
                completeButton?.isEnabled = false
            }
            
        }
        
        return true
    }
    
    
    
}
