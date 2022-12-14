
import SwiftUI
 
//MARK: Onboarding

struct OnboardingView: View {

    @Binding var shouldShowOnboarding: Bool
    @Binding var userSelected: User
    
    var body: some View {
        TabView {
            PageView (imageName: "message.circle.fill",
                      title: "Messaging System ",
                      subtitle: "New at the Academy? Find your new friends on Air Chat",
                      showDismissButton: false ,
            shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected)
                          .background(Color.blue)
        
            PageView (imageName: "bell",
                      title: "Notification ",
                      subtitle: "Do we have notifications(?)",
                      showDismissButton: false ,
                      shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected)
               .background(Color.red)
        
            PageView ( imageName : "hand.thumbsup",
                      title: "Get Started ",
                       subtitle: "Select your Name and Surname and come meet your new friends!",
                       showDismissButton: true ,
                       shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected)               .background(Color.green)
        
           }
        .tabViewStyle( PageTabViewStyle())
    }
}

struct PageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    let showDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @Binding var userSelected: User
    
    @EnvironmentObject var dbManager: DbManager
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
            Text (subtitle)
            
            if showDismissButton {
                Picker("Please select a user", selection: $userSelected) {
                    ForEach(dbManager.users, id: \.self){ user in
                        Text(user.fullName)
                    }
                }
                Text("You selected: \(userSelected.fullName)")
                
                Button {
                    shouldShowOnboarding.toggle()
                } label: {
                    Text("Close")
                }
            }
            
            

        }
    }
}
