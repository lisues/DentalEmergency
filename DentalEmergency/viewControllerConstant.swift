//
//  viewControllerConstant.swift
//  DentalEmergency
//
//  Created by Lisue She on 8/13/17.
//
//

import Foundation


enum ViewControllerEnum {
    case startView, selectedView, practiceView, reviewView, directionView
}

func convertViewControllerConstantToEnum( viewController: Int ) -> ViewControllerEnum {
    
    if viewController == 0 {
        return .startView
    } else if viewController == 1 {
        return .selectedView
    } else if viewController == 2 {
        return .practiceView
    } else if viewController == 3 {
        return .reviewView
    } else if viewController == 4 {
        return .directionView
    } else  {
        return .startView
    }
}


func convertViewControllerEnumToInt( viewController: ViewControllerEnum ) -> Int {
    switch viewController {
    case .startView:
         return 0
    case .selectedView:
        return 1
    case .practiceView:
        return 2
    case .reviewView:
        return 3
    case .directionView:
        return 4
    default:
        return 0
    }
}
