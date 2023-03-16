//
//  CustomNavigationBar.swift
//  Challenger
//
//  Created by Admin on 18/04/22.
//

import UIKit


class CustomNavigationBar: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressBar: CustomProgressBar!
    
    var isPresentedVC:Bool = false
    
    var progressValue:Float?{
        get{return self.progressBar.progress}
        set{self.progressBar.progress = newValue ?? 0}
    }
    
    var viewController:UIViewController?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubViews()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.initSubViews()
    }
    
    
    func initSubViews(){
        _ = UINib(nibName: "CustomNavigationBar", bundle: nil).instantiate(withOwner: self, options: nil)
        self.contentView.frame = bounds
        addSubview(self.contentView)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
       
        if self.isPresentedVC{
            viewController?.dismiss(animated: true)
        }else{
            viewController?.popVC()
        }
    }
}
