//
//  CustomJangdanListView.swift
//  Macro
//
//  Created by jhon on 11/19/24.
//

import SwiftUI
import StoreKit

struct CustomJangdanListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) private var editMode
    @Environment(\.requestReview) private var requestReview
    
    @State var viewModel: CustomJangdanListViewModel
    @State private var appState: AppState = DIContainer.shared.appState
    var router: Router = DIContainer.shared.router
    
    @State private var deleteButtonAlert: Bool = false
    @State private var deletedJangdanName: String?
    
    var body: some View {
        List {
            if self.viewModel.state.customJangdanList.isEmpty {
                if editMode?.wrappedValue == .inactive {
                    ZStack {
                        EmptyJangdanListView()
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                router.push(.jangdanTypeSelect)
                            }
                    }
                    .buttonStyle(PlainListButton())
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            } else {
                ForEach(self.viewModel.state.customJangdanList, id: \.name) { jangdan in
                    HStack(spacing: 0) {
                        if editMode?.wrappedValue == .active {
                            ZStack {
                                Color.red
                                // 삭제버튼 위치(opacity로 조정)
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 17))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 25)
                                    .onTapGesture {
                                        self.deletedJangdanName = jangdan.name
                                        self.deleteButtonAlert = true
                                    }
                            }
                        }
                        
                        ZStack {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(jangdan.type.name)
                                        .font(.Subheadline_R)
                                        .foregroundStyle(.textSecondary)
                                    
                                    Text(jangdan.name)
                                        .font(.Title3_R)
                                        .foregroundStyle(.textDefault)
                                }
                                
                                Spacer()
                                
                                Text(jangdan.lastUpdate.format("yyyy.MM.dd."))
                                    .font(.Subheadline_R)
                                    .foregroundStyle(.textSecondary)
                            }
                            .animation(.easeInOut, value: editMode?.wrappedValue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(.backgroundCard)
                            .onTapGesture {
                                router.push(.customJangdanPractice(jangdanName: jangdan.name, jangdanType: jangdan.type.rawValue))
                            }
                        }
                        .layoutPriority(2)
                    }
                    .buttonStyle(PlainListButton())
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            }
        }
        .onChange(of: self.router.path) {
            if self.router.path.last == .customJangdanList {
                self.viewModel.effect(action: .fetchCustomJangdanData)
            }
        }
        .onAppear {
            self.viewModel.effect(action: .fetchCustomJangdanData)
            if self.appState.numberOfCreatedCustomJangdan == 3 {
                self.requestReview()
            }
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .padding(.top, 32)
        .alert("'\(deletedJangdanName?.truncated(5) ?? "")'를\n삭제하시겠습니까?", isPresented: $deleteButtonAlert) {
            Button("취소", role: .cancel) {
                self.deletedJangdanName = nil
            }
            Button("삭제", role: .destructive) {
                guard let deletedJangdanName else { return }
                self.viewModel.effect(action: .deleteCustomJangdanData(jangdanName: deletedJangdanName))
                withAnimation {
                    self.viewModel.effect(action: .fetchCustomJangdanData)
                }
            }
        }
        .toolbar {
            // MARK: - 뒤로가기
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.textDefault)
                }
            }
            
            // MARK: - Title
            ToolbarItem(placement: .principal) {
                Text("내가 저장한 장단")
                    .font(.Body_R)
                    .foregroundStyle(.textSecondary)
            }
            
            // MARK: - EditMode
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        self.router.push(.jangdanTypeSelect)
                        if editMode?.wrappedValue == .active {
                            editMode?.wrappedValue = .inactive
                        }
                    } label: {
                        Image(systemName: "plus")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.textDefault)
                    }
                    
                    EditButton()
                        .foregroundStyle(.textDefault)
                }
            }
        }
        .toolbarBackground(.backgroundNavigationBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

extension CustomJangdanListView {
    private struct PlainListButton: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .animation(nil, value: configuration.isPressed)
        }
    }
}
