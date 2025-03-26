//
//  JangdanTypeSelectView.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import SwiftUI

struct JangdanTypeSelectView: View {
    
    @State private var appState: AppState = DIContainer.shared.appState
    var router: Router = DIContainer.shared.router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("만들 장단의\n종류를 선택해주세요.")
                .multilineTextAlignment(.leading)
                .font(.Title1_R)
                .foregroundStyle(.textDefault)
                .padding(.leading, 20)
                .padding(.top, 36)
                .padding(.bottom, 24)
            
            List {
                // TODO: - 악기 종류에 따라 표시되는 장단 리스트 달라야함
                ForEach(Jangdan.allCases, id: \.self) { jangdan in
                    Button {
                        router.push(.customJangdanCreate(jangdanName: jangdan.name))
                    } label: {
                        Text(jangdan.name)
                            .padding(.vertical, 9)
                    }
                }
            }
            .contentMargins(.top, 0, for: .scrollContent)
            .foregroundStyle(.primary)
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            // 뒤로가기버튼
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // Title
            ToolbarItem(placement: .principal) {
                Text("장단 만들기")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    JangdanTypeSelectView()
}
