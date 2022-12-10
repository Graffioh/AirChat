//
//  CameraRowView.swift
//  ChatAppADA
//
//  Created by Giovanni Michele on 10/12/22.
//

import SwiftUI

struct CameraRowView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                } else {
                    Image(systemName: "snow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                }
                
                Button("fotocamera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                Button("galleria") {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }.padding()
            }
            .navigationBarTitle("Demo")
            .fullScreenCover(isPresented: self.$isImagePickerDisplay) {
                
                ZStack {
                    Color.primary.ignoresSafeArea()
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                }
            }
            
        }
    }
}

struct CameraRowView_Previews: PreviewProvider {
    static var previews: some View {
        CameraRowView()
    }
}
