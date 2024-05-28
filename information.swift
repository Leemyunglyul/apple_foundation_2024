import SwiftUI


struct InformationView: View {
    @AppStorage("nickname") private var nickname: String = ""
    @AppStorage("age") private var age: String = ""
    @AppStorage("goal") private var goal: String = ""
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 20) {
                Text("정보를 입력해주세요")
                    .font(.title)
                    .foregroundColor(Color("Green"))
                    .bold()
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        Text("닉네임")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("닉네임을 입력해주세요.", text: $nickname)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    Divider()
                    
                    Group {
                        Text("나이")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("나이를 입력해주세요.", text: $age)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    Divider()
                    
                    Group {
                        Text("목표")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("목표를 입력해주세요.", text: $goal)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    Divider()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: ContentView()) {
                        Text("다음")
                    }
                    .frame(width: 100, height: 40)
                    .background(Capsule().fill(Color("Green")))
                    .foregroundColor(.white)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
    }
}
