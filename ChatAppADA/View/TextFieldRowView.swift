
import SwiftUI

import SwiftUI

struct TextfieldRowView: View {
    
    @Binding var input: String
    @StateObject var dbManager = UserViewModel()
    
    @State private var sourceType1: UIImagePickerController.SourceType = .camera
    @State private var selectedImage1: UIImage?
    @State private var isImagePickerDisplay1 = false
    
    //@StateObject var cameraVM = CameraViewModel()
    
    var body: some View {
        HStack {
            NavigationLink {
                CustomCameraView()
            } label: {
                Image(systemName: "camera.fill").bold()
                   .foregroundColor(.white)
                   .padding(8)
                   .background(Color.secondary)
                   .cornerRadius(50)
            }

//            Button {
//                self.sourceType1 = .photoLibrary
//                self.isImagePickerDisplay1.toggle()
//
//            } label: {
//                Image(systemName: "camera.fill").bold()
//                    .foregroundColor(.white)
//                    .padding(8)
//                    .background(Color.secondary)
//                    .cornerRadius(50)
//            }
//            .fullScreenCover(isPresented: self.$isImagePickerDisplay1) {
//                ZStack {
//                    Color.black.ignoresSafeArea()
//                    ImagePickerView(selectedImage: self.$selectedImage1, sourceType: self.sourceType1)
//                }
//            }
            
 
            TextField("Write message", text: $input)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(Color.secondary.opacity(0.2).cornerRadius(50))
                .font(.headline)

                
            
            
        }
       .padding(.horizontal)
        
    }
}

//struct TextifieldRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextfieldRowView(input: $input)
//    }
//}

