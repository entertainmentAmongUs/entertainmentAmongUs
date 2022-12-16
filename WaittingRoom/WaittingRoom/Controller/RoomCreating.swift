//
//  RoomCreating.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/04.
//

import UIKit
import AlertsAndPickers

class RoomCreating: UIViewController, UITextFieldDelegate {
    
    
    // MARK: - Properties
    
    /* MARK: Views */
    
    var contentView: UIView?
    
    var settingStackView: UIStackView?
    var roomTitleTextField: UITextField?
    var passwordTextField: UITextField?
    var gameTypeSegment: UISegmentedControl?
    var maxUserNumberLabel: UILabel?
    var maxUserNumberButton: UIButton?
    var subjectButton: UIButton?
    var categoryButton: UIButton?
    
    var completeButton: UIBarButtonItem?
    
    /* MARK: Others */
    var contentViewHeight: CGFloat
    var contentViewTopAnchor: CGFloat
    
    var maxUserNumber: Int = 3 {
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
    
    
    var myUserId: Int
    
    // MARK: - Method
    
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
        
        /*
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        naviItem.scrollEdgeAppearance = appearance
        naviItem.standardAppearance = appearance
        */
        
        /* 로비의 네비게이션 바 버튼 아이템 설정 */
        /*
        let sideButton = UIBarButtonItem(image: .init(systemName: "list.bullet")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchSideMenuButton(_:)))
        
         let createButton = UIBarButtonItem(image: UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchRoomCreateButton(_:)))
        */
        
        let completeButton = UIBarButtonItem(image: UIImage(systemName: "checkmark")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchCompleteButton(_:)))
        completeButton.isEnabled = false
        
        naviItem.setRightBarButtonItems([completeButton], animated: true)
//        naviItem.setLeftBarButton(UIBarButtonItem(customView: titleView), animated: true)
        
        self.completeButton = completeButton
        
        
    }
    
    func addContentView() {
        
        /* 다른 뷰들을 담는 컨테이너 뷰 설정 */
        let view = UIView()
        
        self.view.addSubview(view)
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        
        
        let safeLayout = self.view.safeAreaLayoutGuide
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 20).isActive = true
        view.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -20).isActive = true
        view.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -20).isActive = true
//        view.heightAnchor.constraint(equalToConstant: contentViewHeight).isActive = true
        
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
            
            let label = UILabel()
            
            view.addSubview(label)
            
            label.text = "방 제목"
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true

            
            
            let textField = UITextField()
            
            view.addSubview(textField)
            
            textField.borderStyle = .roundedRect
            textField.font = .systemFont(ofSize: 15, weight: .regular)
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.delegate = self
            textField.placeholder = "방 제목을 입력하세요"
            textField.enablesReturnKeyAutomatically = true
            
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
            label.font = .systemFont(ofSize: 15 , weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
            
            /* 방 비밀번호의 존재 여부에 따라 패스워드 입력 필드 상태 변경 */
            let active = false
            
            let checkBox = UISwitch()
            
            view.addSubview(checkBox)
            
            checkBox.addTarget(self, action: #selector(togglePasswordSwitch(_:)), for: .valueChanged)
            
            /* 스위치 크기 변경 */
            checkBox.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0).isActive = true
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
            textField.delegate = self
            textField.enablesReturnKeyAutomatically = true
            
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
            label.font = .systemFont(ofSize: 15, weight: .medium)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            
            /* 게임 설명을 표시하는 레이블을 설정 */
            let infoLable = UILabel()
            
            view.addSubview(infoLable)
            
            infoLable.text = games[0].info
            infoLable.font = .systemFont(ofSize: 15, weight: .medium)
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
            
            for i in 0...games.count-1 {
                /* 세그먼트 변경에 대한 액션 */
                let action = UIAction { [unowned self] _ in
                    
                    infoLable.text = games[i].info
                    
                    /* 최소 인원으로 변경 */
                    self.maxUserNumber = 3

                }
                action.title = games[i].title
                segment.insertSegment(action: action, at: i, animated: true)
            }
            
            segment.selectedSegmentIndex = 0
            
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
            label.font = .systemFont(ofSize: 15, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant:  10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            
            
            let picker = UIButton(type: .system)
            
            view.addSubview(picker)
            
            picker.setTitle("\(maxUserNumber)명", for: .normal)
            picker.setTitleColor(.black, for: .normal)
            picker.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            picker.backgroundColor = .systemGray6
            picker.clipsToBounds = true
            picker.layer.cornerRadius = 5
            picker.addTarget(self, action: #selector(touchMaxUserButton(_:)), for: .touchUpInside)
            
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            
            self.maxUserNumberButton = picker
            
            
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
            label.font = .systemFont(ofSize: 15, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor, constant:  10).isActive = true
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            
            let subject = UIButton(type: .system)
            
            subject.setTitle(subjects[self.subject].title, for: .normal)
            subject.setTitleColor(.black, for: .normal)
            subject.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            subject.backgroundColor = .systemGray6
            subject.clipsToBounds = true
            subject.layer.cornerRadius = 5
            subject.addTarget(self, action: #selector(touchSubjectButton(_:)), for: .touchUpInside)
            
            self.subjectButton = subject
            
            
            let category = UIButton(type: .system)
            
            category.setTitle(subjects[self.subject].category[self.category], for: .normal)
            category.setTitleColor(.black, for: .normal)
            category.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            category.backgroundColor = .systemGray6
            category.clipsToBounds = true
            category.layer.cornerRadius = 5
            category.addTarget(self, action: #selector(touchCategoryButton(_:)), for: .touchUpInside)
            
            self.categoryButton = category
            
            
            let stackView = UIStackView(arrangedSubviews: [subject, category])
            
            view.addSubview(stackView)
            
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 20
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            
            return view
        }()
        
        
        /* 설정 뷰를 담는 스택뷰 설정 */
        let stack = UIStackView(arrangedSubviews: [roomTitleView, passwordView, settingGameTypeView, settingMaxUserView, settingSubjectView])
        
        content.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 3
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20).isActive = true
        stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -20).isActive = true
        
        self.settingStackView = stack
        
    }
    
    /*
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
        complete.isEnabled = false
        
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
    */
    

    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
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
   
    
    // MARK: - Action
    
    @objc func touchBackButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func touchCompleteButton(_ sender: UIButton) {
        
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
    
    @objc func togglePasswordSwitch(_ sender: UISwitch) {
        
        guard let text = self.passwordTextField else {return}
        let isOn = sender.isOn
        text.isHidden = !isOn
        text.isEnabled = isOn
        
        text.text = nil
    
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
        
//        guard let subject = subject else { return }

        
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
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        
        self.setNavigationController()
        self.addContentView()
        self.addSettingView()
//        self.addButton()
        
    }

    
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("Do not implemented")
    }
    
    init(_ userId: Int, _ height: CGFloat, _ top: CGFloat) {
        contentViewHeight = height
        contentViewTopAnchor = top
        myUserId = userId
        super.init(nibName: nil, bundle: nil)
        
//        self.modalTransitionStyle = .crossDissolve
//        self.modalPresentationStyle = .overFullScreen
    }
        
    deinit {
        print("deinit RoomSetting")
    }

}
