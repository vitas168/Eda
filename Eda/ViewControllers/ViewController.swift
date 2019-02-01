//
//  ViewController.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 14/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PinLayout

class ViewController: UIViewController {

    private let tableView = TableView()
    private let librarySelector = ImageLibrarySelector()
    private let buttonClearCache = UIButton()
    private let networkModel = RestaurantNetworkModel()
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    private lazy var dataDriver = networkModel.fetchRestaurants(onFailure: { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.didFinishLoadingData()
        strongSelf.display(message: strongSelf.errorMessage)
    })
    private let tableCellReuseId = "restaurantCell"
    private var selectedLibrary: ImageLibrary?
    private let errorMessage = "Что-то пошло не так.\nПопробуйте повторить запрос через некоторое время."
    private let clearCacheMessage = "Вы очистили кэш"
    private let alertAction = "OK"
    private let buttonTitle = "Очистить кэш"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        librarySelector.pin.top(40).left(10).right(10).height(50)
        tableView.pin.below(of: librarySelector).left(10).right(10).marginTop(10).bottom(60)
        buttonClearCache.pin.below(of: tableView).left(10).right(10).marginTop(10).height(40).bottom(10)
        activityIndicator.pin.center()
    }
}

// MARK: - Private functions
private extension ViewController {
    
    private func configureUI() {
        tableView.separatorStyle = .none
        
        librarySelector.customDelegate = self
        
        buttonClearCache.setTitle(buttonTitle, for: .normal)
        buttonClearCache.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        buttonClearCache.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
        buttonClearCache.titleLabel?.font = .boldSystemFont(ofSize: 14)
        buttonClearCache.layer.cornerRadius = 8.0
        buttonClearCache.layer.borderWidth = 1.0
        buttonClearCache.layer.borderColor = UIColor.gray.cgColor
        buttonClearCache.addTarget(self, action: #selector(clearCache), for: .touchDragInside)
        
        activityIndicator.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(tableView)
        view.addSubview(librarySelector)
        view.addSubview(buttonClearCache)
        view.addSubview(activityIndicator)
        view.bringSubview(toFront: activityIndicator)
    }
    
    private func bindRestaurantsDataToTableView() {
        dataDriver
            .do(onNext: { [weak self] _ in
                self?.didFinishLoadingData()
            })
            .drive(tableView.rx.items) { [weak self] (tableView, index, restaurant) in
                guard let strongSelf = self,
                    let library = strongSelf.selectedLibrary else { return UITableViewCell() }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: strongSelf.tableCellReuseId,
                                                         for: IndexPath(row: index, section: 0)) as! RestaurantCell
                cell.setupCell()
                cell.injectData(restaurant: restaurant, library: library)
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func display(message: String) {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)
        let alertOK = UIAlertAction(title: alertAction, style: .default, handler: nil)
        alertController.addAction(alertOK)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func didStartLoadingData() {
        activityIndicator.startAnimating()
        tableView.dataSource = nil
        tableView.reloadData()
        bindRestaurantsDataToTableView()
    }
    
    private func didFinishLoadingData() {
        activityIndicator.stopAnimating()
    }
    
    @objc private func clearCache() {
        DispatchQueue.global(qos: .background).async {
            CacheCleaner.clearAllCaches()
        }
        display(message: clearCacheMessage)
    }
}

// MARK: - ImageLibrarySelectorDelegate functions
extension ViewController: ImageLibrarySelectorDelegate {
    func didSelectLibrary(_ library: ImageLibrary) {
        selectedLibrary = library
        didStartLoadingData()
    }
}

