//
//  PostShareController.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import UIKit
import Photos

protocol PostShareControllerProtocol:AnyObject{
    func setCollection()
    func setNavigation()
    func reloadData()
    var headerImage : UIImage? {get set}
}

final class PostShareController: UIViewController{
    
    var viewModel     : ShareViewModel?
    weak var delegate : HeaderViewDelegate?
    var headerImage   : UIImage?
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(PostHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PostHeaderView.reuseIdentifier)
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
        checkPermissionForPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    @objc private func shareController(){
        let shareController = ShareController()
        shareController.selectedImage = headerImage
        shareController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(shareController, animated: true)
    }
     
    
   
    
//    private func compositionalLayout()->UICollectionViewCompositionalLayout{
//        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
//        
//        let horizontal = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)), repeatingSubitem: item, count: 3)
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), subitems: [horizontal])
//        
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
//     return UICollectionViewCompositionalLayout(section: section)
//        
//        
//    }
    
    
//    private func createLayoutSection(_ index : Int)-> NSCollectionLayoutSection{
//        
//        
//        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
//        
//        let horizontal = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)), repeatingSubitem: item, count: 3)
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), subitems: [horizontal])
//        
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
//        return section
//    }
  

}
extension PostShareController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCell else {return UICollectionViewCell() }
        cell.backgroundImage.image = viewModel?.cellForRow(indexPath: indexPath.row).withRenderingMode(.alwaysOriginal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {return UICollectionReusableView()}
        
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostHeaderView.reuseIdentifier, for: indexPath) as? PostHeaderView else {return UICollectionReusableView()}
        self.delegate = header
        header.backgroundImage.image = self.headerImage
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.headerImage = viewModel?.selectedImage(indexPath: indexPath.row)
        delegate?.didTapImage(headerImage ?? UIImage())
//        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 - 1, height: 100)
    }

}

//MARK: UI Stuff
extension PostShareController : PostShareControllerProtocol{
    func setCollection(){
       view.addSubview(collectionView)
       collectionView.delegate = self
       collectionView.dataSource = self
   }
    
    func setNavigation(){
       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .done, target: self, action: #selector(shareController))
   }
   
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
     
    }
    
    func checkPermissionForPhotos(){
        let permission = PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                self.showAlert(message: "Fotoğraflarınıza erişemediğimiz için fotoğraflarınızı getiremiyoruz.Ayarlardan değişirin.")
            case .restricted:
                self.showAlert(message: "Fotoğraflarınıza erişemediğimiz için fotoğraflarınızı getiremiyoruz.Ayarlardan değişirin.")
            case .denied:
                self.showAlert(message: "Fotoğraflarınıza erişemediğimiz için fotoğraflarınızı getiremiyoruz.Ayarlardan değişirin.")
            case .authorized:
                self.viewModel?.fetchPhotos()
                self.reloadData()
            case .limited:
                self.viewModel?.fetchPhotos()
                self.reloadData()
            }
        }
    }
}





