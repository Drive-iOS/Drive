//
//  DriveInfoVC.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

enum DriveState: Equatable {
    case readyToStart
    case inProgress
    case completed
}

protocol DriveDelegate: AnyObject {
    func didUpdate(_ driveState: DriveState)
}

class DriveVC: UIViewController, SlidingCardViewController, StoryboardInstantiable {
    enum Section {
        case drives
    }

    enum ItemType {
        case drive
    }

    struct Item: Hashable {
        let name: String
    }

    // MARK: - IBOutlets

    @IBOutlet private var driveButton: DriveButton!
    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Properties

    static var appStoryboard: Storyboard {
        return .trackDrive
    }

    weak var delegate: DriveDelegate?

    private var currentDriveState: DriveState = .readyToStart
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    // MARK: SlidingCardViewController

    var fullHeight: CGFloat = 500
    var partialHeight: CGFloat = 300
    var almostHiddenHeight: CGFloat = 30

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpDataSource()
        setUpSnapshot()
        setUpLayout()
        setUpDriveButton()
    }

    // MARK: - Set Up

    private func setUpCollectionView() {
        let nib = UINib(nibName: "DriveCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: DriveCell.reuseIdentifier)
    }

    private func setUpDataSource() {
        // swiftlint:disable line_length
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let driveCell = collectionView.dequeueReusableCell(withReuseIdentifier: DriveCell.reuseIdentifier,
                                                                     for: indexPath) as? DriveCell else {
                fatalError("Programmer Error: Expected reuse cell to exist")
            }

            driveCell.nameLabel.text = item.name
            driveCell.backgroundColor = .systemPink

            return driveCell
        }
        // swiftlint:enable line_length
    }

    private func setUpSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.drives])
        snapshot.appendItems([.init(name: "Drive1"), .init(name: "Drive2")])

        dataSource?.apply(snapshot)
    }

    private func setUpLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }

    private func setUpDriveButton() {
        updateButton(withDriveState: currentDriveState)
    }

    // MARK: - Updating UI

    @IBAction func tappedDriveButton(_ sender: UIButton) {
        let updatedDriveState: DriveState

        switch currentDriveState {
        case .readyToStart:
            updatedDriveState = .inProgress

        case .inProgress:
            updatedDriveState = .completed

        case .completed:
            updatedDriveState = .readyToStart
        }

        updateButton(withDriveState: updatedDriveState)
    }

    private func updateButton(withDriveState driveState: DriveState) {
        self.currentDriveState = driveState
        driveButton.update(withViewModel: DriveButtonViewModel(driveState: driveState))
        delegate?.didUpdate(driveState)
    }
}
