import SwiftUI

struct SocialLoginButton: View {
    var title: String
    var imageName: String
    var hasBackground: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing:20) {
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
                   
                Text(title)
                    .font(.caption)
                    .foregroundColor(hasBackground ? .black : .white)
                
                    
            }
            .padding()
            .frame(height: 55)
            .frame(maxWidth:.infinity)
            .background(hasBackground ? Color.white : Color.clear)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: hasBackground ? 0 : 2)
            )
        }
    }
}

struct SocialLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SocialLoginButton(title: "Login with Facebook", imageName: "Apple", hasBackground: true) {
                print("Login with Facebook tapped")
                // Add your action for Facebook login here
            }
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)

            SocialLoginButton(title: "Login with Google", imageName: "Google", hasBackground: false) {
                print("Login with Google tapped")
                // Add your action for Google login here
            }
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
        }
    }
}
