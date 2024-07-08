import SwiftUI

struct CustomToastMessage: View {
    let text: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom,20)
        .padding(.horizontal, 20)
        .transition(.move(edge: .top))
    }
}

struct CustomToastMessage_Previews: PreviewProvider {
    static var previews: some View {
        CustomToastMessage(text: "This is my warning message for user that receive this warning", backgroundColor: .blue)
    }
}
