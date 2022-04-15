//
//  User.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/31.
//

import Foundation
import UIKit
import Alamofire




struct User: Codable {
    //혹시몰라서 만들어 놓음
    let userId: Int
    let nickname: String
    let password: String
    //굳이 필요없는 것이면 안만들어도 될듯.
    let confirmpassword: String
    let name: String
    let email: String
}


