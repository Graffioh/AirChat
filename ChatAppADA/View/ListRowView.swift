//
//  ListRowView.swift
//  chat-app-ada
//
//  Created by Giovanni Michele on 07/12/22.
//

import SwiftUI

struct ListRowView: View {
    
    var name: String
    var body: some View {
        HStack {
            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            Text(name)
                .font(.headline)
            Spacer()
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(name: "Umberto Breglia")
    }
}
