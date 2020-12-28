//
//  PageScrollView.swift
//  NestedScrollViewsWithPaging
//
//  Created by Sampath Basnagoda on 12/26/20.
//

import UIKit

class PageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    enum ContentScrollPosition: String {
        case none
        case top
        case middle
        case bottom
    }
    
    enum ScrollDirection: String {
        case none
        case up
        case down
    }
    
    let SCROLL_THRESHOLD: CGFloat = 5.0
    
    func getContentScrollPosition() -> ContentScrollPosition {
        if self.contentSize.height <= self.frame.size.height {
            return .none
        } else if (self.contentOffset.y >= (self.contentSize.height - self.frame.size.height).rounded() - SCROLL_THRESHOLD) {
            // content bottom is the Region from bottom edge to another edge which is located 5 points above the bottom edge
            return .bottom
        } else if (self.contentOffset.y <= SCROLL_THRESHOLD){
            // content top is the Region from top edge to another edge which is located 5 points below the top edge
            return .top
        } else {
            return .middle
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}

extension UIScrollView {
    var currentPage: Int{
        let pageHeight = self.frame.height
        let page = floor((self.contentOffset.y - pageHeight / 2) / pageHeight) + 1
        return Int(page)
        //return Int((self.contentOffset.y+(0.5*self.frame.size.height))/self.frame.height)
    }
}

