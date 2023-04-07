//
//  UserSkillProtocol.swift
//  Foresome
//
//  Created by Deepanshu on 04/04/23.
//

import Foundation

protocol UserSkillViewProtocol {
    var presenter: UserSkillPresenterProtocol? { get set }
}
 
protocol UserSkillPresenterProtocol {
    var view : UserSkillViewProtocol? { get set }
    func updateUserSkillToFirestore(skillType: String)
}




