//

import SwiftUI

struct SingleUserRow: View {
    
    var user: User
    var body: some View {
        HStack {
            Image(systemName: "person.fill").resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
            
            Text(user.fullName)
                .font(.headline)
            Spacer()
        }
    }
}

