//
//  MoreViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class MoreViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var myListButton: UIButton!
    @IBOutlet weak var appSettingButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var viewModel: MoreViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configNavigationBar()
        setVersion()
    }
    
    private func handleAction() {
        signOutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showConfirmMessage(title: Strings.signOut, message: Strings.sureToSignOut) { selectedCase in
                    switch selectedCase {
                    case .confirm:
                        ProgressHUD.shared.show()
                        UserInfoService.logout {
                            SceneCoordinator.shared.transition(to: Scene.onboarding)
                            ProgressHUD.shared.hide()
                        }
                    case .cancel:
                        return
                    }
                }
            })
            .disposed(by: bag)
    }
}

extension MoreViewController {
    private func configNavigationBar() {
        navigationItem.title = Strings.settings
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "ver. " + version
        }
    }
}
