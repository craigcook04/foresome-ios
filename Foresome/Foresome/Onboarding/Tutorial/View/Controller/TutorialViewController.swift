//
//  TutorialViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 16/03/23.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var tutorialData:[TutorialDataModel] = Tutorial.array
    var begin = false
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = 0
        setCollectionView()
    }
    
    func setCollectionView() {
        self.tutorialCollectionView.delegate = self
        self.tutorialCollectionView.dataSource = self
        tutorialCollectionView.register(cellClass: TutorialCollectionCell.self)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension TutorialViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        return tutorialData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as! TutorialCollectionCell
        self.pageControl.numberOfPages =  tutorialData.count
        self.pageControl.currentPage = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = tutorialCollectionView.contentOffset
        visibleRect.size = tutorialCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = tutorialCollectionView.indexPathForItem(at: visiblePoint) else { return }
        let cell = tutorialCollectionView.cellForItem(at: indexPath) as? TutorialCollectionCell
        self.pageControl.currentPage = indexPath.item
        
    }
    
    @objc func changeImage() {
        if counter < tutorialData.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.tutorialCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.tutorialCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            counter = 1
            self.pageControl.currentPage = counter
        }
        let cell = tutorialCollectionView.cellForItem(at: IndexPath(item: counter, section: 0)) as? TutorialCollectionCell
        //self.pageControl.currentPage = counter
    }
}
