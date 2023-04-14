//
//  NewsHeader.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import Foundation
import UIKit

class NewsHeader: UIView {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var eventLbl: UILabel!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var bellButton: UIButton!
    
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottom = NSLayoutConstraint()
    var containerView: UIView!
    var imageView: UIImageView!
    var containerViewHeight = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createViews() {
        // Container View
        containerView = UIView()
        self.addSubview(containerView)
        
        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        // UIView Constraints
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        // Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        // ImageView Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    
    @IBAction func memberAction(_ sender: UIButton) {
        
        self.memberButton.titleLabel?.textColor = UIColor.appColor(.green_main)
        self.membersView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsButton.titleLabel?.textColor = UIColor.appColor(.white_title)
        
    }
    
    @IBAction func friendAction(_ sender: UIButton) {
        
        self.memberButton.titleLabel?.textColor = UIColor.appColor(.white_title)
        self.membersView.backgroundColor = UIColor.appColor(.themeWhite)
        self.friendsView.backgroundColor = UIColor.appColor(.green_main)
        self.friendsButton.setTitleColor(.appColor(.green_main), for: .normal)
    }
}
