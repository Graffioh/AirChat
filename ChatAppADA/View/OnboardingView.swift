
import SwiftUI

//MARK: Onboarding

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding: Bool
    @Binding var userSelected: User
    @Binding var userSelectedData: Data
    
    var body: some View {
 
        TabView {
            PageView (imageName: "MockupChats",
                      title: "Messaging System",
                      subtitle: "New at the Academy? Find your new friends on Air Chat",
                      showDismissButton: false ,
                      shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected, userSelectedData: $userSelectedData)
            
            PageView ( imageName : "MockupPersonalChatpng",
                       title: "Get Started ",
                       subtitle: "Select your Name and Surname and come \nmeet your new friends!",
                       showDismissButton: true ,
                       shouldShowOnboarding:$shouldShowOnboarding, userSelected: $userSelected, userSelectedData: $userSelectedData)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
        }
    
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
            
            Spacer()
            
            VStack(spacing: 20) {
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 400)
                    .cornerRadius(20)
                
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.title2.bold())
                        .padding()
                    Text (subtitle)
                        .font(.headline)
                        .padding()
                    
                    
                    
                }
                VStack(alignment: .center, spacing: 20){
                    if showDismissButton {
                        Picker("Please select a user", selection: $userSelected) {
                            ForEach(dbManager.users, id: \.self){ user in
                                if !user.picked {
                                    Text(user.fullName)
                                }
                            }
                        }
                        
                        Button {
                            shouldShowOnboarding.toggle()
                            // When closed save the user in app storage
                            dbManager.pickUser(id: userSelected.id)
                            guard let userSelectedData = try? JSONEncoder().encode(userSelected) else {return}
                            self.userSelectedData = userSelectedData
                        } label: {
                            
                            Text("Done")
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal, 50)
                                .background{
                                    Rectangle()
                                        .cornerRadius(20)
                                }
                            
                            
                        }
                    }
                }
                Spacer()
            }
            
        }
        
    }
}
