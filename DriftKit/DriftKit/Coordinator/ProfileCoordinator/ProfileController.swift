//
//  ProfileController.swift
//  DriftKit
//
//  Created by batuhan on 18.12.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import PhotosUI

protocol ProfileControllerProtocol:AnyObject{
    func reloadData()
    func refreshControl()
    func setCollection()
    func setNavigation()
}

class ProfileController: UIViewController{

    var viewModel : ProfileViewModel?
    var gridView  : Bool = false
    
    private let collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(PostsCell.self, forCellWithReuseIdentifier: PostsCell.reuseIdentifier)
        cv.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: OBJC Funcs
    
    @objc private func refreshCollectionView(){
//        self.viewModel?.loadPhoto()
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.endRefreshing()
        
    }
    
    @objc private func signOut(){
        do{
           try viewModel?.singOut()
        }catch{
            print("ekrana error bas")
        }
    }
    
    
    
}
// MARK: CollectionView
extension ProfileController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if gridView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}
            cell.post      = viewModel?.cellForRow(indexPath: indexPath.row)
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseIdentifier, for: indexPath) as? PostsCell else {return UICollectionViewCell()}
            cell.post      = viewModel?.cellForRow(indexPath: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind        == UICollectionView.elementKindSectionHeader else {return UICollectionReusableView()}
        
        guard let header  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.reuseIdentifier, for: indexPath) as? ProfileHeaderView else {return UICollectionReusableView()}
        header.delegate   = self
        header.userHeader = viewModel?.user
        header.posts.setTitle("\(viewModel?.photosCount ?? 0) Posts", for: .normal)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelect(indexPath: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.gridView {
            return CGSize(width: view.frame.width/3 - 3,height: 200)
        }else {
            return CGSize(width: view.frame.width, height: 400)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
//MARK: Protocols Funcs
extension ProfileController : ProfileControllerProtocol{
   
    func refreshControl(){
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    func setNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func setCollection(){
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
    }
    
}

//MARK: HeaderDelegate
extension ProfileController:ProfileHeaderProtocol {
    
    func didTapImageButton() {
        viewModel?.changeProfilePhoto()
    }
    
    func didTapBackgroundImageTapped() {
        viewModel?.changeBackgroundPhoto()
    }
    
    func didTapGridButton() {
        gridView = true
        collectionView.reloadData()
    }
    
    func didTapListButton() {
        gridView = false
        collectionView.reloadData()
    }
}


    //
    //    func changeGridViewLayout()->UICollectionViewFlowLayout{
    //        if self.gridView{
    //
    //
    ////            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    ////            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
    ////            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)), subitems: [item])
    ////            let section = NSCollectionLayoutSection(group: group)
    ////            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
    ////            let layout = UICollectionViewCompositionalLayout(section: section)
    ////            return layout
    //        }else{
    ////            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    ////            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
    ////            let horizontal = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)), repeatingSubitem: item, count: 3)
    ////            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), subitems: [horizontal])
    ////            let section                        = NSCollectionLayoutSection(group: group)
    ////            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
    ////            let layout = UICollectionViewCompositionalLayout(section: section)
    ////            return layout
    //        }
    //
    //
    //    }
    
    
    

