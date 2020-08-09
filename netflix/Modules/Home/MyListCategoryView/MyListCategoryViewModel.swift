//
//  MyListCategoryViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/9/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyListCategoryViewModel: ViewModel {
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension MyListCategoryViewModel {
    struct Input {
        var fetchDataTrigger: Driver<Void>
        var clearDataTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
}
