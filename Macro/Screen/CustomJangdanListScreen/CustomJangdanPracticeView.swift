//
//  CustomJangdanPracticeView.swift
//  Macro
//
//  Created by Lee Wonsun on 11/26/24.
//

import SwiftUI

enum ToastType {
    case save
    case export(jangdanName: String)
    case changeName
    
    var massage: String {
        switch self {
        case .save:
            return "장단을 저장했습니다."
        case let .export(jangdanName):
            return "'\(jangdanName)' 내보내기가 완료되었습니다."
        case .changeName:
            return "장단명을 변경했습니다."
        }
    }
}

struct CustomJangdanPracticeView: View {
    
    @State var viewModel: CustomJangdanPracticeViewModel
    
    @State private var appState: AppState = DIContainer.shared.appState
    var router: Router = DIContainer.shared.router
    
    @State var jangdanName: String
    var jangdanType: String
    
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    @State private var toastType: ToastType = .save
    
    @State private var deleteJangdanAlert: Bool = false
    @State private var updateJandanNameAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdanName)
            
            if toastAction {
                Text(self.toastType.massage)
                    .font(.Body_R)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .foregroundStyle(Color.white)
                    .background(.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(height: 372)
                    .opacity(self.toastOpacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn) {
                                self.toastOpacity = 0
                            } completion: {
                                self.toastAction = false
                                self.toastOpacity = 1
                                inputCustomJangdanName = ""
                            }
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 chevron
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.viewModel.effect(action: .exitMetronome)
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            
            // 연습 장단 이름
            ToolbarItem(placement: .principal) {
                Text("\(jangdanType) | \(jangdanName)")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200)
            }
            
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        initialJangdanAlert = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 설정 초기화", isPresented: $initialJangdanAlert) {
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                self.viewModel.effect(action: .initialJangdan(jangdanName: self.jangdanName))
                            }
                        }
                    } message: {
                        Text("기본값으로 되돌리겠습니까?")
                    }
                    
                    Menu {
                        Button {
                            self.viewModel.effect(action: .updateCustomJangdan(newJangdanName: nil))
                            self.toastType = .save
                            self.toastAction = true
                        } label: {
                            Text("장단 저장하기")
                        }
                        
                        Button {
                            self.exportJandanAlert = true
                        } label: {
                            Text("장단 내보내기")
                        }
                        
                        Button {
                            self.inputCustomJangdanName = jangdanName
                            self.updateJandanNameAlert = true
                        } label: {
                            Text("장단이름 변경하기")
                        }
                        
                        
                        Button {
                            self.deleteJangdanAlert = true
                        } label: {
                            Text("장단 삭제하기")
                        }
                        
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 삭제하기", isPresented: $deleteJangdanAlert) {
                        Button("예") {
                            deleteJangdanAlert = false
                            self.viewModel.effect(action: .deleteCustomJangdanData(jangdanName: jangdanName))
                            router.pop()
                        }
                        Button("아니오") {
                            deleteJangdanAlert = false
                        }
                    } message: {
                        Text("현재 장단을 삭제하시겠습니까?")
                    }
                    .alert("저장 할 장단 이름", isPresented: $exportJandanAlert) {
                        TextField("이름", text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { oldValue, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = oldValue
                                }
                            }
                        HStack{
                            Button("취소", role: .cancel) {
                                self.inputCustomJangdanName.removeAll()
                            }
                            Button("확인") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                    self.toastType = .export(jangdanName: self.inputCustomJangdanName)
                                    self.toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("저장될 이름을 작성해주세요.")
                    }
                    .alert("변경 할 장단 이름", isPresented: $updateJandanNameAlert) {
                        TextField(jangdanName, text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { oldValue, newValue in
                                if newValue.count > 10 {
                                    inputCustomJangdanName = oldValue
                                }
                            }
                        HStack{
                            Button("취소", role: .cancel) {
                                self.inputCustomJangdanName.removeAll()
                            }
                            Button("확인") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .updateCustomJangdan(newJangdanName: self.inputCustomJangdanName))
                                    self.viewModel.effect(action: .selectJangdan(jangdanName: self.inputCustomJangdanName))
                                    self.jangdanName = inputCustomJangdanName
                                    self.toastType = .changeName
                                    self.toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("변경할 이름을 작성해주세요.")
                    }
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    CustomJangdanPracticeView(viewModel: DIContainer.shared.customJangdanPracticeViewModel, jangdanName: "진양", jangdanType: "진양")
}
