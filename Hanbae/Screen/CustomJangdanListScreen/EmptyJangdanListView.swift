//
//  EmptyJangdanListView.swift
//  Macro
//
//  Created by jhon on 11/20/24.
//

import SwiftUI

struct EmptyJangdanListView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                
                Text("아직 저장한 장단이 없어요")
                    .font(.Subheadline_R)
                    .foregroundColor(.labelSecondary)
                
                Text("장단 만들러 가기")
                    .font(.Title3_R)
                    .foregroundColor(.labelDefault)
                
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .fontWeight(.semibold)
                .frame(width: 20, height: 22)
                .foregroundColor(.labelSecondary)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.backgroundSubtle)
        .cornerRadius(16)
    }
}

#Preview {
    EmptyJangdanListView()
}
