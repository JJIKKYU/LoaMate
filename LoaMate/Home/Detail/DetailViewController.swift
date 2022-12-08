//
//  DetailViewController.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/08.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import RxRelay
import Kingfisher

protocol DetailPresentableListener: AnyObject {
    func pressedBackBtn(isOnlyDetach: Bool)
    var characterProfileModelRelay: BehaviorRelay<ArmoryProfileModel?> { get }
}

final class DetailViewController: UIViewController, DetailPresentable, DetailViewControllable {

    weak var listener: DetailPresentableListener?
    private let disposeBag = DisposeBag()
    
    private lazy var naviView = NaviView(type: .detail).then {
        $0.backButton.addTarget(self, action: #selector(pressedBackBtn), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let characterImageView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setViews()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent || isBeingDismissed {
            listener?.pressedBackBtn(isOnlyDetach: true)
        }
    }
    
    func setViews() {
        view.backgroundColor = Colors.bacgkround
        view.addSubview(naviView)
        view.addSubview(characterImageView)

        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.topSafeAreaHeight)
            make.width.equalTo(170)
            make.height.equalTo(250)
        }
    }
    
    func bind() {
        listener?.characterProfileModelRelay
            .subscribe(onNext: { [weak self] model in
                guard let self = self,
                      let model = model
                else { return }
                
                DispatchQueue.main.async {
                    guard let url = URL(string: model.CharacterImage ?? "") else { return }
                    self.characterImageView.kf.setImage(with: url,
                                                        placeholder: nil,
                                                        options: [.transition(.fade(1))],
                                                        progressBlock: nil) { result in
                        switch result {
                        case .success(let imageResult):
                            self.characterImageView.image = imageResult.image
                        case .failure(let error):
                            print("error! \(error)")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
//
//        if let thumbnailUrl = URL(string: item.thumbnailUrl!) {
//            KingfisherManager.shared.retrieveImage(with: thumbnailUrl, completionHandler: { result in
//            switch(result) {
//                case .success(let imageResult):
//                    let resized = imageResult.image.resizedImageWithContentMode(.scaleAspectFit, bounds: CGSize(width: 84, height: 84), interpolationQuality: .medium)
//                    imageView.isHidden = false
//                    imageView.image = resized
//                case .failure(let error):
//                    imageView.isHidden = true
//                }
//            })
//        }
    }
}

// MARK: - IBAction
extension DetailViewController {
    @objc
    func pressedBackBtn() {
        listener?.pressedBackBtn(isOnlyDetach: false)
    }
}


// MARK: - resizeImage
extension DetailViewController {
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
