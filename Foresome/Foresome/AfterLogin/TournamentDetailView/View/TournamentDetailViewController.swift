//
//  TournamentDetailViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 27/03/23.
//

import UIKit


class TournamentDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var participantNumberLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var viewOnMapBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var headerImage: UIImageView!
    
    //var presenter: TournamentDetailPresenterProtocol?
    var scrollView: UIScrollView!
        
        var label: UILabel!
        
        var headerContainerView: UIView!
        
      
    
    var imageViewHeight = NSLayoutConstraint()
        var imageViewBottom = NSLayoutConstraint()

        var containerView: UIView!
        var imageView: UIImageView!

        var containerViewHeight = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
                
                setViewConstraints()
                
                
                // Label Customization
                label.backgroundColor = .clear
                label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                label.textColor = .white

                
             imageView.image = UIImage(named: "pex")
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func variationAction(_ sender: Any) {
        let vc = VariationViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, true)
    }
    
    @IBAction func attendAction(_ sender: UIButton) {
        let vc = OrderSummaryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        
    }
    
    @IBAction func viewOnMapAction(_ sender: Any) {
        
    }
    func createViews() {
            // ScrollView
            scrollView = UIScrollView()
            scrollView.delegate = self
            self.view.addSubview(scrollView)
            
            // Label
            label = UILabel()
            label.backgroundColor = .white
            label.numberOfLines = 0
            self.scrollView.addSubview(label)
            
            // Header Container
            headerContainerView = UIView()
            headerContainerView.backgroundColor = .gray
            self.scrollView.addSubview(headerContainerView)
            
            // ImageView for background
            imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.backgroundColor = .green
            imageView.contentMode = .scaleAspectFill
            self.headerContainerView.addSubview(imageView)
        }
    func setViewConstraints() {
           // ScrollView Constraints
           self.scrollView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
               self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
           ])
           
           // Label Constraints
           self.label.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
               self.label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
               self.label.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10),
               self.label.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 280)
           ])

           // Header Container Constraints
           let headerContainerViewBottom : NSLayoutConstraint!
           
           self.headerContainerView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               self.headerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
               self.headerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               self.headerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
           ])
           headerContainerViewBottom = self.headerContainerView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -10)
           headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
           headerContainerViewBottom.isActive = true

           // ImageView Constraints
           let imageViewTopConstraint: NSLayoutConstraint!
           imageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               self.imageView.leadingAnchor.constraint(equalTo: self.headerContainerView.leadingAnchor),
               self.imageView.trailingAnchor.constraint(equalTo: self.headerContainerView.trailingAnchor),
               self.imageView.bottomAnchor.constraint(equalTo: self.headerContainerView.bottomAnchor)
           ])

           imageViewTopConstraint = self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
           imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
           imageViewTopConstraint.isActive = true
       }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
