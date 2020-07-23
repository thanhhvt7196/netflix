//
//  ChooseCategoryTypeViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/23/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChooseCategoryTypeViewModel: ViewModel {
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        let types = CategoryType.allCases
        let selectedType = input.selectedItem.flatMapLatest { indexPath -> Driver<CategoryType> in
            guard types.indices.contains(indexPath.row) else {
                return .empty()
            }
            return .just(types[indexPath.row])
        }
        return Output(categoryTypes: Driver.just(types), selectedCategoryType: selectedType)
    }
}

extension ChooseCategoryTypeViewModel {
    struct Input {
        var selectedItem: Driver<IndexPath>
    }
    
    struct Output {
        var categoryTypes: Driver<[CategoryType]>
        var selectedCategoryType: Driver<CategoryType>
    }
}
