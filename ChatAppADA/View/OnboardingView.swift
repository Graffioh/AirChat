
import SwiftUI

//MARK: Onboarding

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding: Bool
    @Binding var userSelected: User
    @Binding var userSelectedData: Data
    var body: some View {
        TabView {
            PageView (imageName: "message.circle.fill",
                      title: "Messaging System ",
                      subtitle: "New at the Academy? Find your new friends on Air Chat",
                      showDismissButton: false ,
                      shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected, userSelectedData: $userSelectedData)
            .background(Color.blue)
            
            PageView (imageName: "bell",
                      title: "Notification ",
                      subtitle: "Do we have notifications(?)",
                      showDismissButton: false ,
                      shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected, userSelectedData: $userSelectedData)
            .background(Color.red)
            
            PageView ( imageName : "hand.thumbsup",
                       title: "Get Started ",
                       subtitle: "Select your Name and Surname and come meet your new friends!",
                       showDismissButton: true ,
                       shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected, userSelectedData: $userSelectedData)
            .background(Color.green)
            
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
    
    @Binding var userSelectedData: Data
    
    @EnvironmentObject var dbManager: DbManager
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
            Text (subtitle)
            
            if showDismissButton {
                Picker("Please select a user", selection: $userSelected) {
                    ForEach(dbManager.users, id: \.self){ user in
                        if !user.picked {
                            Text(user.fullName)
                        }
                    }
                }
                Text("You selected: \(userSelected.fullName)")
                
                Button {
                    shouldShowOnboarding.toggle()
                    // When closed save the user in app storage
                    dbManager.pickUser(id: userSelected.id)
                    guard let userSelectedData = try? JSONEncoder().encode(userSelected) else {return}
                    self.userSelectedData = userSelectedData
                } label: {
                    Text("Done")
                }.padding()
            }
        }
    }
}
