//
//  Singleton.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/04.
//

import Foundation

class Singleton: NSObject {
    
    static let shared = Singleton()
    
    var userId = -1
    var nickName = ""
    
    
    override init() {
        super.init()
    }
    
    
}
