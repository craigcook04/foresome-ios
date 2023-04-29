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

class VariationViewController: UIViewController {
    
    @IBOutlet weak var foresomeBtn: UIButton!
    @IBOutlet weak var singlePlayerBtn: UIButton!
    @IBOutlet weak var firstButtonImageView: UIImageView!
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondsButtonImageView: UIImageView!
    @IBOutlet weak var secondButtonTitle: UILabel!
    @IBOutlet weak var variationTitle: UILabel!
    @IBOutlet weak var variationView: UIView!
    
    var delegate: VariationViewControllerDelegate?
    var isFromProfile: Bool?
    var isEditProfile: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    init (isFromProfileVc: Bool) {
        self.isFromProfile = isFromProfileVc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapToDismiss()
        setProfileAndVariationView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.variationView.transform = CGAffineTransform.identity
        }
    }
    
    func tapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissController))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func dismissController() {
        UIView.animate(withDuration: 0.3) {
            self.variationView.transform = CGAffineTransform(translationX: 0, y: self.variationView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
    }
    
    func setProfileAndVariationView() {
        isFromProfile == true ? (self.firstButtonImageView.image = UIImage(named: "ic_camera")) : (self.firstButtonImageView.image = UIImage(named: "ic_single_player"))
        isFromProfile == true ? (self.firstButtonTitle.text = "Camera") : (self.firstButtonTitle.text = "Single Player")
        isFromProfile == true ? (self.secondsButtonImageView.image = UIImage(named: "ic_gallery")) : (self.firstButtonImageView.image = UIImage(named: "ic_foursome"))
        isFromProfile == true ? (self.secondButtonTitle.text = "Phone gallery") : (self.secondButtonTitle.text = "Foursome")
        if isFromProfile == true {
            isEditProfile == true ? (self.variationTitle.text = "Edit profile picture") : (self.variationTitle.text = "Add profile picture")
        } else {
            variationTitle.text = "Variation"
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismissWithAnimation()
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.variationView.transform = CGAffineTransform(translationX: 0, y: self.variationView.frame.height)
        } completion: { isSucceed in
            self.dismiss(animated: false)
        }
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
extension VariationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.variationView) == true {
            return false
        }
        return true
    }
}
