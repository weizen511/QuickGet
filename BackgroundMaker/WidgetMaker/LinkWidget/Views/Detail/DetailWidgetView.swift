//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI

struct DetailWidgetView: View {
    
    @State var selectedWidget: DeepLink
    
    @StateObject var viewModel = LinkWidgetModel()
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    
    @State var isEditingMode: Bool = false

    
    // init(widget: DeepLink) {
    //     // selectedWidget = widget
    // }
    
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color(uiColor: AppColors.blackDarkGrey)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .center) {
                    Text(viewModel.name)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                }.background(Color(uiColor: AppColors.buttonPurple))
                
                Spacer()
                // 앱 선택 이미지
                PhotoEditMenu(isEditingMode: $isEditingMode,
                          isPhotoViewPresent: $isPhotoViewPresent,
                          viewModel: viewModel)


                Spacer()
                
                EditTextField(title: "위젯 이름", placeHolder: "위젯 이름", isEditingMode: $isEditingMode, text: $viewModel.name)
                EditTextField(title: "URL", placeHolder: "예시: youtube://", isEditingMode: $isEditingMode, text: $viewModel.url)
                Spacer()
                
                VStack(alignment: .center) {
                    // 편집 버튼
                    EditingToggleButton(isEditingMode: $isEditingMode, viewModel: viewModel, selectedWidget: selectedWidget)
                    
                    // 삭제 버튼
                    DetailWidgetButton(text: "삭제", buttonColor: Color("DeleteColor")) {
                        isDeleteAlertPresent.toggle()
                    }
                    .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                        Button("삭제", role: .destructive) {
                            WidgetCoreData.shared.deleteData(data: selectedWidget)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("취소", role: .cancel) {}
                    }, message: { Text("정말 삭제 하시겠습니까?") })
                    
                    // 닫기 버튼
                    DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .darkGray)) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                }
                
                Spacer()
                
            }
        }.onAppear {
            viewModel.name = selectedWidget.name!
            viewModel.url = selectedWidget.url!
            viewModel.image = UIImage(data: selectedWidget.image ?? UIColor.white.image().pngData()!)
        }
        .frame(width: 300, height: 450)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
    }
    
  

}

struct EditWidgetView_Previews: PreviewProvider {


    static var previews: some View {
        NavigationView {
            DetailWidgetView(selectedWidget: DeepLink.example)
        }
    }

}


