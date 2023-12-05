
import Foundation
import SwiftUI

struct CardView: View {
    let course: Course
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(course.courseName)
                    .font(.headline)
                    .padding(.bottom, 8)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
