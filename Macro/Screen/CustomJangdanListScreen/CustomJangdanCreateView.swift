//
//  CustomJangdanCreateView.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

struct CustomJangdanCreateView: View {
    
    @State var viewModel: CustomJangdanCreateViewModel
    var appState: AppState = DIContainer.shared.appState
    var router: Router = DIContainer.shared.router
    
    var jangdanName: String
    
    @State private var backButtonAlert: Bool = false
    @State private var initialJangdanAlert: Bool = false
    @State private var exportJandanAlert: Bool = false
    @State private var inputCustomJangdanName: String = ""
    
    var body: some View {
        MetronomeView(viewModel: DIContainer.shared.metronomeViewModel, jangdanName: jangdanName)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 뒤로가기 chevron
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.viewModel.effect(action: .exitMetronome)
                        backButtonAlert = true
                    } label: {
                        Image(systemName: "chevron.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.textDefault)
                    }
                    .alert("저장하지 않고\n나가시겠습니까?", isPresented: $backButtonAlert) {
                        HStack{
                            Button("취소") { }
                            Button("나가기") {
                                self.viewModel.effect(action: .exitMetronome)
                                router.pop()
                            }
                        }
                    }
                }
                
                
                // 장단 선택 List title
                ToolbarItem(placement: .principal) {
                    Text("\(self.viewModel.state.currentJangdanType ?? .굿거리) 장단 만들기")
                        .font(.Body_R)
                        .foregroundStyle(.textSecondary)
                }
                
                // 현재 장단 저장하기
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        // 초기화 버튼
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
                                    self.viewModel.effect(action: .initialJangdan)
                                }
                            }
                        } message: {
                            Text("기본값으로 되돌리겠습니까?")
                        }
                        
                        // 장단 저장 버튼
                        Button {
                            exportJandanAlert = true
                            
                            // 인앱리뷰 트리거 - 커스텀 장단 생성 횟수 증가
                            appState.increaseCreatedCustomJangdan()
                        } label: {
                            Text("저장")
                                .font(.Body_R)
                                .foregroundStyle(.textDefault)
                        }
                        .alert("저장할 장단 이름", isPresented: $exportJandanAlert) {
                            TextField("이름", text: $inputCustomJangdanName)
                                .onChange(of: inputCustomJangdanName) { oldValue, newValue in
                                    if newValue.count > 10 {
                                        inputCustomJangdanName = oldValue
                                    }
                                }
                            HStack{
                                Button("취소") { }
                                Button("확인") {
                                    if !inputCustomJangdanName.isEmpty {
                                        self.viewModel.effect(action: .exitMetronome)
                                        self.viewModel.effect(action: .createCustomJangdan(newJangdanName: inputCustomJangdanName))
                                        router.pop(2)
                                    }
                                }
                            }
                        } message: {
                            Text("저장될 이름을 작성해주세요.")
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
    CustomJangdanCreateView(viewModel: DIContainer.shared.customJangdanCreateViewModel, jangdanName: "진양")
}
