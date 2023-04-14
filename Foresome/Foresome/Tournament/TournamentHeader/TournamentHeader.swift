//
//  TournamentHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 24/03/23.
//

import Foundation
import UIKit

class TournamentHeader: UIView {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottom = NSLayoutConstraint()
    var containerView: UIView!
    var imageView: UIImageView!
    var containerViewHeight = NSLayoutConstraint()
    
    var nibname = "TournamentHeader"
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.commonInit(frame: frame)
//        createViews()
//        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit(frame: CGRect.zero)
    }
    
    func commonInit(frame:CGRect) {
//        Bundle.main.loadNibNamed(nibname, owner: self)
//        self.autoresizingMask = [.flexibleHeight]
//        self.frame = frame
    }
    
    func setHeaderData() {
        let strings = UserDefaults.standard.object(forKey: "myUserData") as? [String: Any]
        if let data = strings {
            self.usernameLabel.text = "HELLO,\(data["name"] as? String ?? "")!"
        }
    }
    
    func createViews() {
        containerView = UIView()
        self.addSubview(containerView)
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scroll view scrolling called.")
//        self.contentViewHeight.constant = scrollView.contentInset.top
////        self.superview?.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: scrollView.contentInset.top)
//        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
////        self.clipsToBounds = offsetY <= 0
//        self.contentViewBottomConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
//        let height = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
//        self.superview?.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: height)
//        self.clipsToBounds = true
    }
}
