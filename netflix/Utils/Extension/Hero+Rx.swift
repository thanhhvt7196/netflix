//
//  Hero+Rx.swift
//  myNews
//
//  Created by kennyS on 12/16/19.
//  Copyright © 2019 kennyS. All rights reserved.
//

import Foundation
import RxSwift
import Hero
import RxCocoa

extension Reactive where Base: UIView {
    var heroId: Binder<String> {
        return Binder(base) { view, id in
            view.hero.id = id
        }
    }

}
