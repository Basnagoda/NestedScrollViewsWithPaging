//
//  PageScrollView.swift
//  NestedScrollViewsWithPaging
//
//  Created by Sampath Basnagoda on 12/26/20.
//

import UIKit

class PageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
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

