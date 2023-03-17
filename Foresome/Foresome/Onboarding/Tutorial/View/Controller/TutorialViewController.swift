//
//  TutorialViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 16/03/23.
//

import UIKit

class TutorialViewController: UIViewController {
    
    var tutorialData:[TutorialDataModel] = Tutorial.array
    var begin = false
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    func setCollectionView() {
        self.tutorialCollectionView.delegate = self
        self.tutorialCollectionView.dataSource = self
        tutorialCollectionView.register(cellClass: TutorialCollectionCell.self)
    }
}


extension TutorialViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: IndexPath()) as! TutorialCollectionCell
        cell.pageControl.numberOfPages = tutorialData.count
        return tutorialData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as! TutorialCollectionCell
        cell.pageControl.numberOfPages =  tutorialData.count
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
        cell?.pageControl.currentPage = indexPath.item

    }
}
