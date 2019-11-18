//
//  HomeViewController.swift
//  Roomr
//
//  Created by Katie Kwak on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Koloda


class HomeViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var userName_label: UILabel!
    var candidatesImages = [UIImage]()
    var likedCandidates = [UIImage]()
    
    let candidateNames = ["Abigail", "Aria", "Ava", "Benjamin", "Emma", "Hannah", "James", "Liam", "Mason", "Mila", "Noah", "Oliver", "Olivia", "William"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCandidates()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        //kolodaView.reloadData()
    } /* viewDidLoad() */
    
    
    
    func loadCandidates() {
        let assetsFolder = "Home_PotentialMatches/"
        
        // add images of each candidate to array
        let images = candidateNames.map { name -> UIImage? in
            if let candidate = UIImage(named: "\(assetsFolder)\(name)") {
                return candidate
            }
            return nil
        }
        
        candidatesImages = images.compactMap { $0 }
    } /* loadCandidates(): For now load pictures of potential matches */
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.kolodaView) else { return }
        
        let height = kolodaView.frame.height
        let width = kolodaView.frame.width
        
        let leftTapRegion = CGRect(x: 0, y: 0, width: (0.5 * width), height: (0.75 * height))
        let rightTapRegion = CGRect(x: (0.5 * width), y: 0, width:(0.5 * width), height: (0.75 * height))
        let downTapRegion = CGRect(x: 0, y: (0.75 * height), width: width, height: (0.25 * height))
        
        //if !kolodaView.frame.contains(location) {
            //print("Tapped inside the view")
        if leftTapRegion.contains(location) {
            print("left region tapped")
        } else if rightTapRegion.contains(location) {
            print("right region tapped")
        } else if downTapRegion.contains(location) {
            print("down region tapped")
        }
    }

} /* HomeViewController: Browse potential matches & navigate to other components */








extension HomeViewController: KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    } /* allowed directions to swipe card */



    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    } /* called before card swiped; allow/deny this swipe */



    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            self.likedCandidates.append(candidatesImages[index])
        }
    } /* called whenever card is swiped */



    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        userName_label.text = ""
        koloda.reloadData()
    } /* called when no more cards to display */



    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(index)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
    } /* called when a card is tapped */



    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true // apply appear animation
    } /* called when card is displayed */



    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true // move background card when front card is dragged
    } /* called @start of front card swiping */



    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true // make card below current card transparent
    } /* called after swiping */



    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {

    } /* called when card dragging event recognized */



    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return nil // threshold set to half the distance
    } /* % of distance between center of card & edge needed to trigger a swipe*/



    func kolodaDidResetCard(_ koloda: KolodaView) {

    } /* called after resetting a card */



    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        userName_label.text = candidateNames[index]
    } /* called after card is shown (animation complete) */



    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        return true // card moves in direction of drag
        // return false: card doesn't move
    } /* called when user begins dragging card */

} /* extend KolodaViewDelegate */








extension HomeViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return candidatesImages.count
    } /* return # items in koloda view */



    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIImageView(image: candidatesImages[index])
        view.layer.cornerRadius = 5
        view.clipsToBounds = true

        return view
    } /* return view to display at specific index */



//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        // set custom overlay action on swiping:
//            // override didSet of overlayState property in OverlayView
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    } /* return view for card overlay @index*/



    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    } /* manage swipe animation duration */
    
    
    
} /* extend KolodaViewDataSource */
