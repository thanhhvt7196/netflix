//
//  WebViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/29/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WebViewModel: ViewModel {
    let initialURL: String
    init(url: String) {
        initialURL = url
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension WebViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
