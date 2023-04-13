//
//  VariationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 28/03/23.
//

import UIKit
protocol VariationViewControllerDelegate {
    func playerCount(text: String)
}

class VariationViewController: PresentableController {
    
    @IBOutlet weak var foresomeBtn: UIButton!
    @IBOutlet weak var singlePlayerBtn: UIButton!
    
    @IBOutlet weak var firstButtonImageView: UIImageView!
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondsButtonImageView: UIImageView!
    @IBOutlet weak var secondButtonTitle: UILabel!
    
    var delegate: VariationViewControllerDelegate?
    var isFromProfile: Bool?
    
    init (isFromProfileVc: Bool) {
        self.isFromProfile = isFromProfileVc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileAndVariationView()
    }
    
    func setProfileAndVariationView() {
        isFromProfile == true ? (self.firstButtonImageView.image = UIImage(named: "ic_camera")) : (self.firstButtonImageView.image = UIImage(named: "ic_single_player"))
        isFromProfile == true ? (self.firstButtonTitle.text = "Camera") : (self.firstButtonTitle.text = "Single Player")
        isFromProfile == true ? (self.secondsButtonImageView.image = UIImage(named: "ic_gallery")) : (self.firstButtonImageView.image = UIImage(named: "ic_foursome"))
        isFromProfile == true ? (self.secondButtonTitle.text = "Phone gallery") : (self.secondButtonTitle.text = "Foursome")
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func singlePlayerAction(_ sender: Any) {
        isFromProfile == true ? self.delegate?.playerCount(text: "Camera") : self.delegate?.playerCount(text: "Single Player")
        self.dismiss(animated: false)
    }
    
    @IBAction func foursomeAction(_ sender: Any) {
        isFromProfile == true ? self.delegate?.playerCount(text: "Phone gallery") : self.delegate?.playerCount(text: "Foresome")
        self.dismiss(animated: false)
    }
}
