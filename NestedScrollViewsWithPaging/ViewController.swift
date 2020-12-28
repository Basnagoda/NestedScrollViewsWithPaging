//
//  ViewController.swift
//  NestedScrollViewsWithPaging
//
//  Created by Sampath Basnagoda on 12/26/20.
//

import UIKit

class ViewController: UIViewController {
    
    let pagingScrollView = UIScrollView()
    let pagingStackView = UIStackView()
    let toolBarView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolBar() // red color toolbar
        setupPagingScrollView()
        self.view.bringSubviewToFront(self.toolBarView)
        addPages()

        
        //panGestureRecognizer of the outer scroll view requires panGestureRecognizers of the outer scrollViews to fail.
        for (_, scrollView) in pagingStackView.arrangedSubviews.enumerated() {
            guard let scrollView = scrollView as? PageScrollView else { return }

             pagingScrollView.panGestureRecognizer.require(toFail: scrollView.panGestureRecognizer)
        }
    }
    
    func setupToolBar() {
        toolBarView.backgroundColor = .red
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toolBarView)
        NSLayoutConstraint.activate([
            toolBarView.heightAnchor.constraint(equalToConstant: 50),
            toolBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            toolBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
       
    }
    
    func setupPagingScrollView(){
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.isScrollEnabled = true // TRUE
        pagingScrollView.pinchGestureRecognizer?.isEnabled = false
        pagingScrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        pagingScrollView.panGestureRecognizer.maximumNumberOfTouches = 2
        pagingScrollView.delaysContentTouches = false
        pagingScrollView.canCancelContentTouches = true
        pagingScrollView.bounces = false
        pagingScrollView.alwaysBounceVertical = false
        pagingScrollView.alwaysBounceHorizontal = false
        pagingScrollView.tag = 999
        pagingScrollView.backgroundColor = .gray
        pagingScrollView.delegate = self
        
        self.view.addSubview(pagingScrollView)
        
        NSLayoutConstraint.activate([
            pagingScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            pagingScrollView.topAnchor.constraint(equalTo: self.toolBarView.bottomAnchor, constant: -20),
            pagingScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            pagingScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20),
        ])
        
        pagingStackView.translatesAutoresizingMaskIntoConstraints = false
        pagingStackView.axis = .vertical
        pagingStackView.distribution = .equalCentering
        pagingStackView.alignment = .center
        pagingStackView.spacing = 40
        pagingStackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        pagingStackView.isLayoutMarginsRelativeArrangement = true
        
        //     add the stack view to the scroll view
        pagingScrollView.addSubview(pagingStackView)
        
        // this *also* controls the .contentSize of the scrollview
        NSLayoutConstraint.activate([
            pagingStackView.leftAnchor.constraint(equalTo: pagingScrollView.leftAnchor),
            pagingStackView.rightAnchor.constraint(equalTo: pagingScrollView.rightAnchor),
            pagingStackView.topAnchor.constraint(equalTo: pagingScrollView.topAnchor),
            pagingStackView.bottomAnchor.constraint(equalTo: pagingScrollView.bottomAnchor, constant: -20),
            pagingStackView.widthAnchor.constraint(equalTo: pagingScrollView.widthAnchor)
        ])
        
    }
    
    func addPages(){
        for index in 0...2  {
            let pageScrollView = PageScrollView()
            pageScrollView.translatesAutoresizingMaskIntoConstraints = false
            pageScrollView.alwaysBounceVertical = true
            pageScrollView.alwaysBounceHorizontal = true
            pageScrollView.bounces = true
            pageScrollView.minimumZoomScale = 0.1
            pageScrollView.maximumZoomScale = 5
            pageScrollView.backgroundColor = .lightGray
            pageScrollView.isScrollEnabled = true
            pageScrollView.panGestureRecognizer.minimumNumberOfTouches = 2
            pageScrollView.panGestureRecognizer.maximumNumberOfTouches = 2
            pageScrollView.delaysContentTouches = false
            pageScrollView.canCancelContentTouches = true
            pageScrollView.showsVerticalScrollIndicator = false
            pageScrollView.showsHorizontalScrollIndicator = false
            pageScrollView.delegate = self
            
            var imageName : String = ""
            if index == 0 {
                imageName = "cat.jpg"
            }else if index == 1 {
                imageName = "dog.jpg"
            } else if index == 2 {
                imageName = "lion.jpg"
            }
            
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.contentMode = .center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            pageScrollView.addSubview(imageView)
            
            pageScrollView.zoomScale = 0.6

            pagingStackView.addArrangedSubview(pageScrollView)
            
            NSLayoutConstraint.activate([
                pageScrollView.heightAnchor.constraint(equalTo: pagingScrollView.heightAnchor, constant: -40),
                pageScrollView.widthAnchor.constraint(equalTo: pagingScrollView.widthAnchor)
            ])
            
            // add swipe gestures
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
            swipeUpGesture.direction = .up
            swipeUpGesture.numberOfTouchesRequired = 2
            swipeUpGesture.delegate = pageScrollView
            pageScrollView.addGestureRecognizer(swipeUpGesture)
            
            let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
            swipeDownGesture.direction = .down
            swipeDownGesture.numberOfTouchesRequired = 2
            swipeDownGesture.delegate = pageScrollView
            pageScrollView.addGestureRecognizer(swipeDownGesture)
        }
    }
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        guard let pageScrollView = sender.view as? PageScrollView else { return }
        
        let scrollPosition = pageScrollView.getContentScrollPosition()
        
        // if scrollView is at the bottom and swipe direction is up,then disable scrolling
        if scrollPosition == .bottom && sender.direction == .up {
            print("scrollView is at the bottom and swipe direction is up,so disable scrolling")
            pageScrollView.isScrollEnabled = false
            pagingScrollView.isScrollEnabled = true
        }
        
        // else if scrollView is at the top and swipe direction is down,then disable scrolling
        else if scrollPosition == .top && sender.direction == .down {
            print("scrollView is at the top and swipe direction is down,so disable scrolling")
            pageScrollView.isScrollEnabled = false
        }
        
        // else enable scrolling
        else if scrollPosition == .none {
            print("scroll position is none. Disable scrolling")
            pageScrollView.isScrollEnabled = false
        }
        
        else {
            print("ENABLE scrollView")
            pageScrollView.isScrollEnabled = true
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // perform following for updating navigation bar layout (this is an iOS issue in iOS 13+), otherwise wrong navigation bar height will results for page not being centered properly.
        if #available(iOS 13.0, *) {
            self.view.layoutIfNeeded()
        }
        for (_, scrollView) in pagingStackView.arrangedSubviews.enumerated() {
            guard let scrollView = scrollView as? PageScrollView else { return }
            scrollView.centerContent()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (success) -> Void in
            
            for (_, scrollView) in self.pagingStackView.arrangedSubviews.enumerated() {
                guard let scrollView = scrollView as? PageScrollView else { return }
                scrollView.centerContent()
            }
        })
        
    }
    
}

//MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        guard let scrollView = scrollView as? PageScrollView else { return nil }
        return scrollView.subviews.first // imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let scrollView = scrollView as? PageScrollView {
            centerScrollView(scrollView)
            
//            if (scrollView.contentSize.height > scrollView.frame.size.height) {
//                scrollView.isScrollEnabled = true
//            }
//            else {
//                scrollView.isScrollEnabled = false
//            }
        }

    }
    
    func centerScrollView(_ scrollView: UIScrollView) {
        let offsetX: CGFloat = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        self.view.layoutIfNeeded()
    }
}



extension UIScrollView {
    func centerContent(){
        let offsetX: CGFloat = max((self.bounds.size.width - self.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((self.bounds.size.height - self.contentSize.height) * 0.5, 0.0)

        self.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        self.layoutIfNeeded()
    }
    
    func getCurrentPage() -> Int {
        let pageHeight = self.frame.height
        let page = floor((self.contentOffset.y - pageHeight / 2) / pageHeight) + 1
        return Int(page)
    }
}

