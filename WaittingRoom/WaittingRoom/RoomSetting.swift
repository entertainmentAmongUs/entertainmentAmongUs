//
//  RoomSetting.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/23.
//

import UIKit

class RoomSetting: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    // MARK: - Properties
    
    
    /* MARK: Views */
    
    var contentView: UIView?
    
    var settingStackView: UIStackView?
    var roomTitleTextField: UITextField?
    var passwordTextField: UITextField?
    var gameTypeSegment: UISegmentedControl?
    var maxUserNumberPicker: UIPickerView?
    var maxUserNumberLabel: UILabel?
    var subjectPicker: UIPickerView?
    
    var buttonStackView: UIStackView?
    var backButton: UIButton?
    var completeButton: UIButton?
    
    /* MARK: Others */
    var contentViewHeight: CGFloat
    
    // MARK: - Method
    
    func addContentView() {
        
        /* 다른 뷰들을 담는 컨테이너 뷰 설정 */
        let view = UIView()
        
        self.view.addSubview(view)
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        view.heightAnchor.constraint(equalToConstant: contentViewHeight).isActive = true
        
        self.contentView = view
        
    }
    
    func addSettingView() {
        
        guard let content = contentView else {return}

        /* 방 제목 설정 뷰 */
        let roomTitleView: UIView = {
            
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            view.frame.size = CGSize(width: 200, height: 200)
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "방 제목"
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true

            
            
            let textField = UITextField()
            
            view.addSubview(textField)
            
            textField.borderStyle = .roundedRect
            textField.font = .systemFont(ofSize: 18, weight: .regular)
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.delegate = self
            textField.text = Myroom.roomTitle
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            
            self.roomTitleTextField = textField
            
            
            return view
        }()
        
        
        /* 방 패스워드 설정 뷰 */
        let passwordView: UIView = {
            
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "비밀번호 활성화"
            label.font = .systemFont(ofSize: 20, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
            
            /* 방 비밀번호의 존재 여부에 따라 패스워드 입력 필드 상태 변경 */
            let active = Myroom.password != nil ? true : false
            
            let checkBox = UISwitch()
            
            view.addSubview(checkBox)
            
            checkBox.addTarget(self, action: #selector(togglePasswordSwitch(_:)), for: .valueChanged)
            
            /* 스위치 크기 변경 */
            checkBox.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5).isActive = true
            checkBox.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            checkBox.isOn = active
            
            
            let textField = UITextField()
            
            view.addSubview(textField)
            
            textField.borderStyle = .roundedRect
            textField.font = .systemFont(ofSize: 15, weight: .regular)
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.isEnabled = active
            textField.isHidden = !active
            textField.placeholder = "방 비밀번호를 입력하세요"
            textField.text = Myroom.password
            textField.delegate = self
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
            
            self.passwordTextField = textField
            
            
            
            return view
        }()
        
        
        /* 게임 타입 설정 뷰 */
        let settingGameTypeView: UIView = {
            
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "게임 타입"
            label.font = .systemFont(ofSize: 20, weight: .medium)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            
            /* 게임 설명을 표시하는 레이블을 설정 */
            let infoLable = UILabel()
            
            view.addSubview(infoLable)
            
            infoLable.text = games[Myroom.gameType.rawValue].info
            infoLable.font = .systemFont(ofSize: 18, weight: .medium)
            infoLable.backgroundColor = .systemGray6
            infoLable.clipsToBounds = true
            infoLable.layer.cornerRadius = 5
            infoLable.adjustsFontSizeToFitWidth = true
            infoLable.numberOfLines = 1
            infoLable.textAlignment = .center
            infoLable.shadowColor = .white
            infoLable.shadowOffset = CGSize(width: 3, height: 3)
            
            infoLable.translatesAutoresizingMaskIntoConstraints = false
            infoLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            infoLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            infoLable.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
            infoLable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            infoLable.setContentHuggingPriority(.defaultLow, for: .vertical)
            
            
            /* 게임 종류 변경 컨트롤 (세그먼트) */
            let segment = UISegmentedControl()
            
            view.addSubview(segment)
            
            for i in games {
                /* 세그먼트 변경에 대한 액션 */
                let action = UIAction { [weak self] _ in
                    
                    infoLable.text = i.info
                    
                    /* 변경된 게임의 최대 인원 수에 맞게 설정할 수 있는 인원 최댓값 조정*/
                    guard let picker = self?.maxUserNumberPicker else {return}
                    
                    picker.reloadComponent(0)
                }
                action.title = i.title
                segment.insertSegment(action: action, at: i.gameId.rawValue, animated: true)
            }
            
            segment.selectedSegmentIndex = Myroom.gameType.rawValue
            
            segment.translatesAutoresizingMaskIntoConstraints = false
            segment.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 15).isActive = true
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            segment.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            segment.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
            self.gameTypeSegment = segment
            
            
            return view
        }()
        
        
        
        /* 방 최대 인원 설정 뷰*/
        let settingMaxUserView: UIView = {
            
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "최대 인원"
            label.font = .systemFont(ofSize: 20, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant:  10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            
            /* 방 최대 인원 변경 컨트롤 (피커 뷰) */
            let picker = UIPickerView()
            
            view.addSubview(picker)
            
            picker.dataSource = self
            picker.delegate = self
            picker.selectRow(Myroom.maxUserNumber-3, inComponent: 0, animated: true)
            picker.tag = 0
            
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            
            
            self.maxUserNumberPicker = picker
            
            
            return view
        }()
        
        
        /* 제시어 주제 변경 뷰 */
        let settingSubjectView: UIView = {
            
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "주제 선택"
            label.font = .systemFont(ofSize: 20, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant:  10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            /* 제시어 주제 변경 컨트롤 (피커 뷰) */
            let picker = UIPickerView()
            
            view.addSubview(picker)
            
            picker.dataSource = self
            picker.delegate = self
            picker.tag = 1
            picker.selectRow(1, inComponent: 0, animated: false)
            
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            
            self.subjectPicker = picker
            
            
            return view
        }()
        
        
        /* 설정 뷰를 담는 스택뷰 설정 */
        let stack = UIStackView(arrangedSubviews: [roomTitleView, passwordView, settingGameTypeView, settingMaxUserView, settingSubjectView])
        
        content.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20).isActive = true
        stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -20).isActive = true
        
        self.settingStackView = stack
        
        
        
    }
    
    func addButton() {
        
        guard let content = self.contentView else {return}
        
        let back = UIButton(type: .system)
        
        back.addTarget(self, action: #selector(touchBackButton(_:)), for: .touchUpInside)
        back.setTitle("뒤로", for: .normal)
        back.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        
        self.backButton = back
        
        
        let complete = UIButton(type: .system)
        
        complete.addTarget(self, action: #selector(touchCompleteButton(_:)), for: .touchUpInside)
        complete.setTitle("완료", for: .normal)
        complete.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        self.completeButton = complete
        
        
        /* 버튼을 담는 스택 뷰 설정 */
        let stack = UIStackView(arrangedSubviews: [UIView(),back, UIView(), complete, UIView()])
        
        self.view.addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.backgroundColor = .white
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        self.buttonStackView = stack
        
        
    }
    
    
    // MARK: - PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        /* tag 0 : 최대 인원 설정 */
        case 0:
            return 1
        /* tag 1 : 제시어 주제 설정 */
        case 1:
            /* depth 1, 2*/
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
            
        case 0:
            /* 선택된 게임의 가능한 최대 인원 수 */
            guard let segment = self.gameTypeSegment else { return 0 }
            let index = segment.selectedSegmentIndex
            return games[index].maxUserNumber - 2
            
        case 1:
            switch component {
                
            case 0:
                /* 제시어 주제 개수 */
                return subjects.count
                
            case 1:
                /* 선택된 주제에 따른 카테고리 개수 */
                let index = pickerView.selectedRow(inComponent: 0)
                return subjects[index].category.count
                
            default: return 0
                
            }
        default:
            return 0
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 0:
            /* 설정 가능한 최대 인원 수 표시 */
            return "\(row+3)명"
        
        case 1:
            switch component {
                
            case 0:
                /* 주제 제목(타이틀) */
                return subjects[row].title
                
            case 1:
                /* 선택한 주제에 따라 카테고리 표시 */
                let index = pickerView.selectedRow(inComponent: 0)
                return subjects[index].category[row]
                
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        /* 주제 설정 뷰에서 0번 컴포넌트 (제시어 주제) 변경하면 카테고리 갱신 */
        if pickerView.tag == 1 && component == 0 {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
    

    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    // MARK: - Action
    
    @objc func touchBackButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func touchCompleteButton(_ sender: UIButton) {
        
        /* 현재 방 설정을 입력값으로 변경 */
        
        guard let title = roomTitleTextField?.text else {return}
        guard let maxUserNumber = maxUserNumberPicker?.selectedRow(inComponent: 0) else {return}
        guard let gameType = gameTypeSegment?.selectedSegmentIndex else {return}
        guard let subject = subjectPicker else {
            return
        }
        guard let password = self.passwordTextField else { return }

        
        Myroom.roomTitle = title
        Myroom.gameType = GameType(rawValue: gameType)!
        Myroom.maxUserNumber = maxUserNumber + 3
        Myroom.category = Category(categoryID: subject.selectedRow(inComponent: 1), subjectID: subject.selectedRow(inComponent: 0))
        
        
        /* 비밀번호가 공백이거나 nil이면 nil값을 설정 */
        if password.text == nil || password.text!.isEmpty {
            Myroom.password = nil
        }
        else {
            Myroom.password = password.text
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func togglePasswordSwitch(_ sender: UISwitch) {
        
        guard let text = self.passwordTextField else {return}
        let isOn = sender.isOn
        text.isHidden = !isOn
        text.isEnabled = isOn
        
        text.text = nil
    
    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.00)
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        
        self.addContentView()
        self.addSettingView()
        self.addButton()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        /* 현재 방에 설정돼있는 주제를 표시 */
        guard let subject = subjectPicker else {return}
        
        subject.selectRow(Myroom.category.subjectID, inComponent: 0, animated: true)
        subject.selectRow(Myroom.category.categoryID, inComponent: 1, animated: true)
        subject.reloadAllComponents()
        
    }
    

    
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("Do not implemented")
    }
    
    init(_ height: CGFloat) {
        contentViewHeight = height
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    	
    deinit {
        print("deinit RoomSetting")
    }

}
