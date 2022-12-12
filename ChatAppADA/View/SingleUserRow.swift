//
//  ListRowView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 07/12/22.
//

import SwiftUI

struct SingleUserRow: View {
    
    var user: User
    var body: some View {
        HStack {
            AsyncImage(url: user.imageURL){ image in
                image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            Text(user.fullName)
                .font(.headline)
            Spacer()
        }
    }
}

