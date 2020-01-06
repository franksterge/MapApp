//
//  BottomSlidableSheetViewController.swift
//  MapApp
//
//  Created by GeFrank on 1/1/20.
//  Copyright © 2020 GeFrank. All rights reserved.
//
//  update log:
//      1/1/20: Created bottom sheet + sheet slidable
//      1/2/20: modify pan gesture to enable animation

import UIKit

class BottomSlidableSheetViewController: UIViewController {
    
    let minYBound = UIScreen.main.bounds.height - 150
    let maxYBound = CGFloat(200)
    let tableView = UITableView()

    override func loadView() {
        super.loadView()
        
        let slidingGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(slidingGesture)
        roundViews()
        configureIndicator()
        
        let frame = self.view.frame
        tableView.frame = CGRect(x: 0, y: 30, width: frame.width, height: frame.height - maxYBound - 60)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.classForCoder(), forCellReuseIdentifier: String(describing: CustomCell.self))
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    private func prepareBackgroundView() {
        let blurEffect = UIBlurEffect.init(style: .dark)
        let blurView = UIVisualEffectView.init(effect: blurEffect)
        blurView.frame = self.view.bounds
        
        view.insertSubview(blurView, at: 0)
        tableView.backgroundColor = .none
        tableView.allowsSelection = false
    }
    
    @objc private func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let yAfterTransition = self.view.frame.minY
        let frame = self.view.frame

        let velocity = recognizer.velocity(in: self.view)
        
        if (translation.y + yAfterTransition >= self.maxYBound && translation.y + yAfterTransition <= self.minYBound) {
            self.view.frame = CGRect(x: 0, y: translation.y + yAfterTransition, width: frame.width, height: frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended{
            var duration = velocity.y < 0 ? Double((yAfterTransition - self.maxYBound) / -velocity.y) : Double((self.minYBound - yAfterTransition) / velocity.y)
            duration = duration > 0.3 ? 0.3 : duration
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.minYBound, width: frame.width, height: frame.height)
                    self.tableView.isScrollEnabled = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.maxYBound, width: frame.width, height: frame.height)
                    self.tableView.isScrollEnabled = true
                }
            })
        }

        print("min y location: \(frame.minY), delta: \(translation.y)\n ")
    }
    
    func roundViews() {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    func configureIndicator() {
        let rect = CGRect(x: self.view.frame.maxX / 2 - 30 , y: 7, width: 60, height: 6)
        let indicator = UIView(frame: rect)
        indicator.layer.cornerRadius = 3
        indicator.backgroundColor = .white
        
        NSLayoutConstraint.activate([indicator.heightAnchor.constraint(equalToConstant: 6.0)])
        self.view.addSubview(indicator)
    }
}

extension BottomSlidableSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as! CustomCell
        return cell
    }
}

//extension BottomSlidableSheetViewController: UIGestureRecognizerDelegate {
//     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
//        let y = view.frame.minY
//        if (y == maxYBound && self.tableView.contentOffset.y == 0 && direction > 0) || (y == self.minYBound) {
//            self.tableView.isScrollEnabled = false
//        } else {
//            self.tableView.isScrollEnabled = true
//        }
//        return false
//    }
//
//}
