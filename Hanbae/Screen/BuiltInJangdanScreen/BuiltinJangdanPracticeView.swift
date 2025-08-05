//
//  BuiltinJangdanPracticeView.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

struct BuiltinJangdanPracticeView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var viewModel: BuiltInJangdanPracticeViewModel
    
    @State private var appState: AppState = DIContainer.shared.appState
    
    private var jangdanName: String
    
    @State private var initialJangdanAlert: Bool = false
    @State private var isRepeatedName: Bool = false
    
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    @State private var toastAction: Bool = false
    @State private var toastOpacity: Double = 1
    
    init(viewModel: BuiltInJangdanPracticeViewModel, jangdanName: String) {
        self.jangdanName = jangdanName
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: self.jangdanName)
            
            if self.toastAction {
                Text("'내가 저장한 장단'에서 확인할 수 있습니다.")
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
                Button(action: {
                    self.viewModel.effect(action: .exitMetronome)
                    self.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // 장단 선택 List title
            ToolbarItem(placement: .principal) {
                Text(self.jangdanName)
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
                    .padding(.trailing, 6)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        // TODO: 데이터 초기화
                        self.initialJangdanAlert = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("장단 설정 초기화", isPresented: $initialJangdanAlert) {
                        HStack{
                            Button("취소") { }
                            Button("완료") {
                                self.viewModel.effect(action: .initialJangdan)
                            }
                        }
                    } message: {
                        Text("기본값으로 되돌리겠습니까?")
                    }
                    
                    Menu {
                        Button {
                            self.exportJandanAlert = true
                        } label: {
                            Text("나만의 장단 저장하기")
                        }
                        
                    } label: {
                        Image(.save)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textSecondary)
                    }
                    .alert("나만의 장단으로 저장", isPresented: $exportJandanAlert) {
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
                                if !self.inputCustomJangdanName.isEmpty {
                                    self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                    guard !self.viewModel.state.isRepeatedName else {
                                        self.isRepeatedName = true
                                        return
                                    }
                                    self.toastAction = true
                                }
                            }
                        }
                    } message: {
                        Text("저장될 이름을 작성해주세요.\n장단종류, 강세, 빠르기값이 저장됩니다.")
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
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    BuiltinJangdanPracticeView(viewModel: DIContainer.shared.builtInJangdanPracticeViewModel, jangdanName: "진양")
}
