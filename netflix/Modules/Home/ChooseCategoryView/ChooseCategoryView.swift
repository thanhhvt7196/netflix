//
//  ChooseCategoryView.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class ChooseCategoryView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: ChooseCategoryViewModel!
    let selectedGenre = PublishSubject<Genre>()
    private let bottomInset: CGFloat = 180
    private let tableViewRowHeight: CGFloat = 60
    
    let bag = DisposeBag()
    
    private func commonInit() {
        loadNibContent()
        prepareUI()
        bind()
        handleAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(viewModel: ChooseCategoryViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        commonInit()
    }
    
    private func prepareUI() {
        containerView.blur(withStyle: .dark)
        configTableView()
        configCloseButton()
    }
    
    private func bind() {
        let input = ChooseCategoryViewModel.Input(selectedItem: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.genreList
            .drive(tableView.rx.items) { tableView, row, genre in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(for: indexPath) as HomeChooseCategoryCell
                cell.configCell(genre: genre)
                return cell
            }
            .disposed(by: bag)
        
        output.genreList
            .delay(DispatchTimeInterval.milliseconds(100))
            .drive(onNext: { [weak self] genres in
                guard let self = self else { return }
                if let currentGenresIndex = genres.firstIndex(where: { $0.id == PersistentManager.shared.currentGenre }) {
                    let indexPath = IndexPath(row: currentGenresIndex, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                }
            })
            .disposed(by: bag)
        
        output.selectedGenre.drive(selectedGenre).disposed(by: bag)
    }
    
    private func handleAction() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismissWithAnimation()
            })
            .disposed(by: bag)
    }
    
    private func configCloseButton() {
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = closeButton.bounds.height/2
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: .leastNonzeroMagnitude))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        tableView.backgroundColor = .clear
        tableView.rowHeight = tableViewRowHeight
        tableView.register(cellType: HomeChooseCategoryCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

extension ChooseCategoryView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let rows = tableView.indexPathsForVisibleRows else {
            return
        }
        for index in rows {
            if let cell = tableView.cellForRow(at: index) {
                let cellRect = tableView.rectForRow(at: index)
                let rect = CGRect(x: 0, y: tableView.bounds.origin.y + tableViewRowHeight, width: tableView.bounds.size.width, height: tableView.bounds.size.height - bottomInset)
                
                if rect.contains(cellRect) {
                    cell.alpha = 1
                } else {
                    let cellRectLocation = tableView.convert(cell.frame, to: tableView.superview)
                    cell.alpha = cellRectLocation.origin.y < 0 ? 1 : (tableView.bounds.height - cellRectLocation.origin.y)/(bottomInset + tableViewRowHeight)
                }
            }
        }
    }
}
