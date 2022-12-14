import SwiftUI

struct CustomCameraView: View {
    @StateObject var cameraVM = CameraViewModel()
    
    //@EnvironmentObject var cameraVM: CameraViewModel
    
    var body: some View {
        ZStack{
            
            CameraPreview()
                .environmentObject(cameraVM)
            
            VStack{
                
                Spacer()
                
                HStack{
                    
                    if cameraVM.isTaken {
                        Button(action:{
                            if !cameraVM.isSaved{
                                //cameraVM.savePic(locationVM: locationVM, cameraVM: cameraVM)
                                print("saved")
                            }
                        }, label: {
                            Text(cameraVM.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                        
                        if cameraVM.isTaken{
                            Button(action:
                                cameraVM.reTakePic
                            ,label: {
                                Text("Retake")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
                            .padding(.trailing)
                        }
                    }
                    else{
                        Button(action: cameraVM.takePic, label: {
                            ZStack{
    
                                Circle()
                                    .fill(Color.white)
                                    .frame(width:70, height: 100, alignment: .center)
    
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform:{
            cameraVM.Check()
        })
    }
}
