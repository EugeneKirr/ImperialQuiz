//
//  SectionListViewController.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataProvider = SectionListDataProvider()
    
    private let networkManager = NetworkManager()
    
    private var isDownloadingInProgress: Bool? {
        didSet {
            switch isDownloadingInProgress {
            case true:
                navigationItem.title = "Downloading..."
                showActivityIndicator()
            case false:
                navigationItem.title = "Section List"
                showBookmarksButton()
            default:
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SectionListCell.self)
        collectionView.delegate = dataProvider
        collectionView.dataSource = dataProvider
        dataProvider.delegate = self
        configureNavBar()
        fetchDefaultSectionAtFirstLaunch("Orks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

}

extension SectionListViewController {
    
    func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemYellow
        isDownloadingInProgress = false
        updateTrashButton()
    }
    
    func showBookmarksButton() {
        let bookmarks = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(fetchAvailableSections))
        navigationItem.rightBarButtonItem = bookmarks
    }
    
    func updateTrashButton() {
        let trashImage = dataProvider.isSectionRemovingActivated ? UIImage(systemName: "trash.fill") : UIImage(systemName: "trash")
        let trash = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(tapTrashButton))
        navigationItem.leftBarButtonItem = trash
    }
    
    @objc func fetchAvailableSections() {
        networkManager.fetchRawSectionData { [weak self] result in
            switch result {
            case .success(let rawModels): self?.showAvailableSectionsSheet(rawModels)
            case .failure(let networkError): self?.showNetworkErrorAlert(networkError)
            }
        }
    }
    
    @objc func tapTrashButton() {
        dataProvider.isSectionRemovingActivated = !dataProvider.isSectionRemovingActivated
        updateTrashButton()
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .link
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
}

extension SectionListViewController {
    
    func showAvailableSectionsSheet(_ sections: [RawSectionData]) {
        let ac = UIAlertController(title: "Available Sections", message: nil, preferredStyle: .actionSheet)
        let existingSections = dataProvider.currentSections
        for availableSection in sections {
            let sectionAction = UIAlertAction(title: availableSection.title, style: .default) { [weak self] _ in
                self?.isDownloadingInProgress = true
                self?.dataProvider.createNewSection(from: availableSection) {
                    self?.isDownloadingInProgress = false
                    self?.collectionView.reloadData()
                }
            }
            if let _ = existingSections.firstIndex(where: { $0.title == availableSection.title }) {
                sectionAction.setValue(UIImage(systemName: "checkmark.square"), forKey: "image")
                sectionAction.isEnabled = false
            } else {
                sectionAction.setValue(UIImage(systemName: "square.and.arrow.down"), forKey: "image")
                sectionAction.isEnabled = true
            }
            ac.addAction(sectionAction)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIImage(systemName: "xmark"), forKey: "image")
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
}

extension SectionListViewController {
    
    func fetchDefaultSectionAtFirstLaunch(_ defaultSectionTitle: String) {
        let firstLaunchFlag = UserDefaults.standard.object(forKey: UDKeys.isFirstLaunchHappened.key)
        guard firstLaunchFlag == nil || firstLaunchFlag as? Bool == false else { return }
        networkManager.fetchRawSectionData { [weak self] result in
            switch result {
            case .success(let rawModels):
                guard let defaultSectionRawData = rawModels.first(where: { $0.title == defaultSectionTitle }) else { fatalError("No Such Section Available") }
                self?.isDownloadingInProgress = true
                self?.dataProvider.createNewSection(from: defaultSectionRawData) {
                    self?.isDownloadingInProgress = false
                    self?.collectionView.reloadData()
                    UserDefaults.standard.set(true, forKey: UDKeys.isFirstLaunchHappened.key)
                }
            case .failure(let networkError): self?.showNetworkErrorAlert(networkError)
            }
        }
    }
    
}
