//
//  MakeWallpaperViewController+bgEditSubview.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/29.
//

import UIKit
import SnapKit
import RxSwift
import RulerView


extension MakeWallpaperViewController {

    /// `배경화면 편집` 버튼을 누르면 생성되는 Subview를 구성합니다.
    func makeBGEditView(view bgView: MainEditMenuView) {
        
        view.addSubview(bgView)
        bgView.isHidden = true
        
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }

    }

    
    func configureSubmenuBackground() {
        
        view.addSubview(trayRootView)
        trayRootView.snp.makeConstraints { make in
            make.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-65)
        }
        
        let subviewHeight: CGFloat = 50
        view.addSubview(traySubView)
        traySubView.snp.makeConstraints { make in
            make.bottom.equalTo(trayRootView.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(subviewHeight)
        }
        
        view.addSubview(traySubViewInView)
        traySubViewInView.snp.makeConstraints { make in
            make.bottom.equalTo(traySubView.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(subviewHeight)
        }

    }
    
    //MARK: - ColorPicker 셋업
    func makeBGColorPicker() {
        
        view.addSubview(colorPickerView)
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.alpha = 0
        colorPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(50)
        }
        
    }


}
