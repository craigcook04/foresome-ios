//
//  Tutorial Model.swift
//  Foresome
//
//  Created by Piyush Kumar on 17/03/23.
//

import Foundation
import UIKit

class TutorialDataModel: NSObject {
    var tutorialImage: UIImage?
    var tutorialTitle: String?
    var tutorialDescription: String?
    
    public init(tutorialImage: UIImage?, tutorialTitle: String?, tutorialDescription: String?) {
        self.tutorialImage = tutorialImage
        self.tutorialTitle = tutorialTitle
        self.tutorialDescription = tutorialDescription
    }
}
class Tutorial{
    static var array: [TutorialDataModel] = [
        TutorialDataModel.init(tutorialImage: UIImage(named: "tutorial_screen"), tutorialTitle: "Invite and play together with friends", tutorialDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis."),
        TutorialDataModel.init(tutorialImage: UIImage(named: "tutorial_screen"), tutorialTitle: "Invite and play together with friends", tutorialDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis."),
        TutorialDataModel.init(tutorialImage: UIImage(named: "tutorial_screen"), tutorialTitle: "Invite and play together with friends", tutorialDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis.")
    ]
}

