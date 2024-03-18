//
//  CameraController.swift
//  DriftKit
//
//  Created by batuhan on 5.01.2024.
//

import Foundation
import AVFoundation
import SnapKit
import UIKit

class CameraController: UIViewController {

    var viewModel      : CameraViewModel?
    var session        : AVCaptureSession?
    var output         = AVCapturePhotoOutput()
    let previewLayer   = AVCaptureVideoPreviewLayer()
    var selectedImage  : UIImage?
    
    var cameraButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "camera")?.withConfiguration(UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 40), scale: .large)), for: .normal)
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    let reverseCameraButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "repeat.circle")?.withConfiguration(UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(reverseCameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left")?.withConfiguration(UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 20))), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    let shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func shareButtonTapped(){
//        StorageManager.shared.uploadStory(file: self.selectedImage ?? UIImage()) { [weak self] success in
//            if success{
//                print("başarılı")
//            }
//        }
    }
    
    @objc private func backButtonTapped(){
        if self.selectedImage == nil {
            viewModel?.backToHomeController()
        }else {
            self.selectedImage = nil
            takePicture()
            hideButtons(hide: false)
            collectionView.reloadData()
        }
    }
    @objc private func reverseCameraButtonTapped(){
        if let session = session {
            let currentCameraInput : AVCaptureInput = session.inputs[0]
            session.removeInput(currentCameraInput)
            var newCamera = AVCaptureDevice.default(for: .video)
            
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back{
                UIView.transition(with: self.view, duration: 0.5) {
                    newCamera = self.cameraWithPosition(.front)
                }
            }else {
                UIView.transition(with: self.cameraView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    newCamera = self.cameraWithPosition(.back)!
                }, completion: nil)
            }
            do {
                try self.session?.addInput(AVCaptureDeviceInput(device: newCamera!))
            }
            catch {
                print("error: \(error.localizedDescription)")
            }
            
        }
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
       
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)

        for device in deviceDiscoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    
    
    private lazy var collectionView : UICollectionView = {
        let layout                     = UICollectionViewFlowLayout()
        layout.scrollDirection         = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        let collection                 = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.delegate            = self
        collection.dataSource          = self
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(previewLayer)
        view.addSubview(collectionView)
        view.addSubview(cameraButton)
        previewLayer.frame = view.bounds
        takePicture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchPhotos()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    
    let backgroundQueue = DispatchQueue(label: "camera",qos: .background)
    
    
    func takePicture(){
        let captureSession = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
            if captureSession.canAddOutput(output){
                captureSession.addOutput(output)
            }
            
            self.previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer.session = captureSession
            
            backgroundQueue.async {
                captureSession.startRunning()
            }
            self.session = captureSession
        }catch let error{
            print(error)
        }
    }
    
    @objc private func didTapCameraButton(){
        Task{
            do {
                try await StorageManager.shared.saveStoryToStorage(file: selectedImage ?? UIImage())
            }catch let error {
               print(error)
            }
        }
        
//        StorageManager.shared.uploadStory(file: UIImage(named: "gtr") ?? UIImage()) { [weak self] success in
//            if success{
//                print("başarılı")
//            }
//        }
//        let settings = AVCapturePhotoSettings()
//        output.capturePhoto(with: settings, delegate: self)
        hideButtons(hide: true)
    }
    
    
    func hideButtons(hide:Bool){
        if hide{
            collectionView.isHidden = true
            cameraButton.isHidden = true
            shareButton.isHidden = false
            reverseCameraButton.isHidden = true
//            takenImage.isHidden = false
        }else {
            collectionView.isHidden = false
            cameraButton.isHidden = false
            shareButton.isHidden = true
            reverseCameraButton.isHidden = false
//            takenImage.isHidden = true
        }
        
    }
    
    
    var cameraView = UIView()
    
    func setLayout(){
      
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        self.view.addSubview(cameraView)
        cameraView.addSubview(cameraButton)
        cameraView.addSubview(reverseCameraButton)
        self.view.addSubview(backButton)
        self.view.addSubview(shareButton)
//        self.view.addSubview(takenImage)
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.right.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.bottom.equalTo(cameraView.snp_topMargin).offset(0)
        }
        
        cameraView.snp.makeConstraints { make in
            make.right.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.height.equalTo(200)
            make.bottom.equalTo(self.view.snp_bottomMargin)
        }
        backButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.left.equalTo(cameraView.snp_leftMargin).offset(10)
            make.top.equalTo(self.view.snp_topMargin).offset(10)
        }
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.right.equalTo(cameraView.snp_rightMargin).offset(-10)
            make.top.equalTo(self.view.snp_topMargin).offset(10)
        }
        
        cameraButton.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.width.equalTo(50)
            make.center.equalTo(cameraView)
        }
        reverseCameraButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.right.equalTo(cameraView.snp_rightMargin).offset(-10)
            make.top.equalTo(cameraView.snp_topMargin).offset(10)
        }
        
//        takenImage.snp.makeConstraints { make in
//            make.right.equalTo(self.view).offset(0)
//            make.left.equalTo(self.view).offset(0)
//            make.top.equalTo(self.view).offset(0)
//            make.bottom.equalTo(self.view).offset(0)
//        }
        
    }


}
extension CameraController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {return}
        let image = UIImage(data: data)
        self.selectedImage = image
        session?.stopRunning()
//        viewModel?.showTakenPhoto(image: image ?? UIImage())
    }
}


extension CameraController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCell else {return UICollectionViewCell()}
        cell.imageView.image = viewModel?.cellForRow(indexPath: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var image = viewModel?.selectedImage(indexPath: indexPath.row)
        self.selectedImage = image
        self.hideButtons(hide: true)
//        self.session?.addOutput(.)

    }

}

