//
//  ColorPalletView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import UIKit
import SnapKit
import RxSwift


enum ColorPalletType {
    case normal
    case showRuler
}

/// 원형의 Color Pallet 입니다.
class BackgroundColorPallet: UIView {
    
    var color: UIImage!
    var type: ColorPalletType!
    weak var target: MakeWallpaperViewController!
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    
    //MARK: - Init
    init(color: UIImage, target: MakeWallpaperViewController, type: ColorPalletType = .normal) {
        
        self.color = color
        self.type = type
        self.target = target

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func configureUI() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(color, for: .normal)
        addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        switch self.type {
        case .normal:
            let action = UIAction { _ in self.colorBtnTapped() }
            self.button.addAction(action, for: .touchDown)
        case .showRuler:
            let action = UIAction { _ in self.blurBtnTapped() }
            self.button.addAction(action, for: .touchDown)
        default :
            break
        }

    }
    
    private func colorBtnTapped() {
        
        if target.bgRulerView.alpha == 1 {
                self.target.bgRulerView.alpha = 0
                self.target.traySubViewInView.alpha = 0
        }
        
        target.bgImageView.image = self.color
    }
    
    private func blurBtnTapped() {
        
        RxImageViewModel.shared.backgroundImageTrigger.onNext("Go Bg Image")
        
        print("blur Button Tapped")
        RxImageViewModel.shared.backgroundImageSubject
            .subscribe { image in
                self.target.bgImageView.image = image
            }.dispose()
        // rulerView의 현재 값을 바로 호출하도록

        toggleViews(targetView: target.bgRulerView, bgView: target.traySubViewInView, hideViews: [])
        
    }

    
    func toggleViews(targetView: UIView, bgView: UIView, hideViews: [UIView], duration: CGFloat = 0.2) {

        if targetView.alpha == 0 { // 타겟뷰가 안보이면
            UIView.animate(withDuration: duration) {
                // 타겟 뷰 및 타겟 배경 뷰 보이게
                targetView.alpha = 1
                bgView.alpha = 0.4
                
                // 상관 없는 뷰는 숨기기
                hideViews.forEach { hideView in
                    hideView.alpha = 0
                }
            }
        } else {
            targetView.alpha = 0
            bgView.alpha = 0
        }
        
    }
}
