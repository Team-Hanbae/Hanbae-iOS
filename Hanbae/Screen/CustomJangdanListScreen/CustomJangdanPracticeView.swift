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
    
    @Environment(\.dismiss) var dismiss
    @State var viewModel: CustomJangdanPracticeViewModel
    
    @State private var appState: AppState = DIContainer.shared.appState
    var router: Router = DIContainer.shared.router
    
    @State var jangdanName: String
    var jangdanType: String
    
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var isRepeatedName: Bool = false
    
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    @State private var toastType: ToastType = .save
    
    @State private var deleteJangdanAlert: Bool = false
    @State private var updateJandanNameAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: self.jangdanName)
            
            if self.toastAction {
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
                                self.inputCustomJangdanName = ""
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
                    self.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.labelPrimary)
                }
            }
            
            
            // 연습 장단 이름
            ToolbarItem(placement: .principal) {
                Text("\(self.jangdanType) | \(self.jangdanName)")
                    .font(.Body_R)
                    .foregroundStyle(.labelDefault)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200)
            }
            
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        self.initialJangdanAlert = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.labelPrimary)
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
                            Text("변경사항 저장하기")
                        }
                        
                        Button {
                            self.exportJandanAlert = true
                        } label: {
                            Text("다른 이름으로 저장하기")
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
                            .foregroundStyle(.labelPrimary)
                    }
                    .alert("다른 이름으로 저장", isPresented: $exportJandanAlert) {
                        TextField("이름", text: $inputCustomJangdanName)
                            .onChange(of: self.inputCustomJangdanName) { oldValue, newValue in
                                if newValue.count > 10 {
                                    self.inputCustomJangdanName = oldValue
                                }
                            }
                        HStack{
                            Button("취소", role: .cancel) {
                                self.inputCustomJangdanName.removeAll()
                            }
                            Button("확인") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .createCustomJangdan(newJangdanName: self.inputCustomJangdanName))
                                    guard !self.viewModel.state.isRepeatedName else {
                                        self.isRepeatedName = true
                                        return
                                    }
                                    self.toastType = .export(jangdanName: self.inputCustomJangdanName)
                                    self.toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("저장될 이름을 작성해주세요.")
                    }
                    .alert("장단이름 변경하기", isPresented: $updateJandanNameAlert) {
                        TextField(self.jangdanName, text: $inputCustomJangdanName)
                            .onChange(of: inputCustomJangdanName) { oldValue, newValue in
                                if newValue.count > 10 {
                                    self.inputCustomJangdanName = oldValue
                                }
                            }
                        HStack{
                            Button("취소", role: .cancel) {
                                self.inputCustomJangdanName.removeAll()
                            }
                            Button("확인") {
                                if !inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .updateCustomJangdan(newJangdanName: self.inputCustomJangdanName))
                                    guard !self.viewModel.state.isRepeatedName else {
                                        self.isRepeatedName = true
                                        return
                                    }
                                    self.viewModel.effect(action: .selectJangdan(jangdanName: self.inputCustomJangdanName))
                                    self.jangdanName = self.inputCustomJangdanName
                                    self.toastType = .changeName
                                    self.toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("변경할 이름을 작성해주세요.")
                    }
                    .alert("장단 삭제하기", isPresented: $deleteJangdanAlert) {
                        Button("취소", role: .cancel) {
                            self.deleteJangdanAlert = false
                        }
                        
                        Button("삭제", role: .destructive) {
                            self.deleteJangdanAlert = false
                            self.viewModel.effect(action: .deleteCustomJangdanData(jangdanName: jangdanName))
                            self.viewModel.effect(action: .exitMetronome)
                            self.dismiss()
                        }
                    } message: {
                        Text("현재 장단을 삭제하시겠습니까?")
                    }
                    .alert("이미 등록된 장단 이름입니다.", isPresented: $isRepeatedName) {
                        Button("확인") {
                            self.viewModel.effect(action: .repeatedNameNoticed)
                        }
                    } message: {
                        Text("다른 이름으로 다시 시도해주세요.")
                    }
                }
            }
        }
        .toolbarBackground(.backgroundMute, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    CustomJangdanPracticeView(viewModel: DIContainer.shared.customJangdanPracticeViewModel, jangdanName: "진양", jangdanType: "진양")
}
