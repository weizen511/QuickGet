//
//  TrayView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit
import SnapKit
import RxSwift

/**
 `BottomMenuView는 PhotoVC의 하단 편집 메뉴를 구성합니다.`
 >  Properties
 */
class BottomMenuView: UIView {
    
    /// 이 뷰를 호출한 뷰컨트롤러입니다.
    var parentVC: PhotoViewController?
    
    /// 뷰의 배경 레이어 입니다. 컨텐츠와 같이 투명해지지 않도록 배경을 분리합니다.
    let backgroundView = UIView()

    /// 뷰의 컨텐츠가 들어갈 뷰입니다.
    let contentView = UIView()

    /// 기능 버튼이 들어갈 스택뷰입니다.
    let centerStackView = UIStackView()
    let rightStackView = UIStackView()
    
    /// 현재 뷰를 초기화합니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundView(view: backgroundView)
        setupViewAlphaValue(view: backgroundView, alpha: 0.2)
        backgroundView.backgroundColor = .systemBackground
        setupContentView(view: contentView)
        setupStackView(stackView: centerStackView)
        setupStackView(stackView: rightStackView)
        stackViewLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 현재 뷰의 사이즈를 구성합니다.
    override var intrinsicContentSize: CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 80)
    }
    
    //MARK: - Layout Subview
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
    
    //MARK: END Layout Subview -

    /// 컨텐츠의 배경 뷰를 만듭니다.
    func setupBackgroundView(view: UIView) {
        self.addSubview(view)
        
        view.backgroundColor = .systemBackground
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 컨텐츠를 표현할 뷰를 만듭니다.
    func setupContentView(view: UIView) {
        self.addSubview(view)
        
        view.backgroundColor = .clear
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 뷰의 배경색이 투명하도록 설정합니다.
    func setupViewAlphaValue(view: UIView, alpha: CGFloat) {
        view.alpha = alpha
    }

    /// 기능버튼이 들어갈 스택뷰를 구성합니다.
    func setupStackView(stackView: UIStackView) {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.backgroundColor = .clear
    }
    
    func stackViewLayout() {
        centerStackView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100 + 5)
            make.height.equalTo(50)
        }
        rightStackView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        
    }
    

    
  
}