import SwiftUI

let rootlist: Array<String> = ["비트", "고구마", "당근", "무", "생강"]
let stemlist: Array<String> = ["대파", "셀러리", "콜라비", "감자", "마늘"]
let leaflist: Array<String> = ["양파", "배추", "상추", "근대", "부추"]
let flowerlist: Array<String> = ["청경채", "브로콜리", "컬리플라워", "아티초크", "케일꽃"]
let fruitlist: Array<String> = ["파프리카", "딸기", "토마토", "고추", "오이"]

struct mainscreen: View {
    @State private var searchText: String = ""
    @State private var selectedItem: String? // 선택된 아이템을 나타내는 변수
    
    var body: some View {
        VStack {

            Text("누구와 챌린지를 함께 할까요?")
                .font(.title)
                .foregroundColor(Color("Green"))
                .bold()
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Divider()
            // Categories
            VStack {
                HStack(spacing: 20) {
                    CategoryView(imageName: "root_v", label: "뿌리채소") {
                        self.selectedItem = "뿌리채소"
                    }
                    .padding(.leading, 20)
                    //.padding(.top, 20)
                    CategoryView(imageName: "stem_v", label: "줄기채소") {
                        self.selectedItem = "줄기채소"
                    }
                    .padding(.leading, 20)
                    CategoryView(imageName: "leaf_v", label: "잎채소") {
                        self.selectedItem = "잎채소"
                    }
                    .padding(.leading, 20)
                    
                }
                .padding(.top, 20)
                HStack(spacing: 20) {
                    CategoryView(imageName: "fruit", label: "열매채소") {
                        self.selectedItem = "열매채소"
                    }
                    .padding(.leading, 30)
                    .padding(.top, 10)
                    CategoryView(imageName: "flower", label: "꽃채소") {
                        self.selectedItem = "꽃채소"
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 15)
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // 선택된 카테고리에 따라 목록을 표시
            if let category = selectedItem {
                NewListView(category: category)
            }
            
            Spacer()
        }
    }
}

// 카테고리 버튼에 클로저를 추가하여 버튼이 눌렸을 때 실행할 코드를 전달할 수 있도록 수정
struct CategoryView: View {
    let imageName: String
    let label: String
    let action: () -> Void // 버튼이 클릭되었을 때 실행할 액션
 
    var body: some View {
        Button(action: action) { // 버튼에 클로저를 실행할 액션으로 설정
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                Text(label)
                    .font(.body)
                    .foregroundColor(Color.black)
            }
        }
    }
}

// 새로운 목록을 표시하는 View
struct NewListView: View {
    let category: String
    //@State private var veget : String = ""
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10) // 둥근 모서리 상자
                .foregroundColor(Color.gray.opacity(0.3)) // 회색
                .padding() // 안쪽 여백
                .overlay(
                    VStack {
                        Text("\(category) 목록")
                            .font(.headline)
                            .padding()
                        List(getList(for: category), id: \.self) { item in
                            NavigationLink(destination: challenge(veget: item)) {
                                Text(item)
                            }
                        }
                        .cornerRadius(8)
                        
                    }
                    .padding(20)
                )
        }
    }
    
    func getList(for category: String) -> [String] {
        switch category {
        case "뿌리채소":
            return rootlist
        case "줄기채소":
            return stemlist
        case "잎채소":
            return leaflist
        case "꽃채소":
            return flowerlist
        case "열매채소":
            return fruitlist
        default:
            return []
        }
    }
    
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                mainscreen()
            }
            .tabItem {
                Image(systemName: "house")
                Text("홈")
            }
            
            NavigationView {
                chall_list()
            }
            .tabItem {
                Image(systemName: "flame")
                Text("챌린지")
            }
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                    .renderingMode(.original)
                Text("프로필")
            }
        }
        .navigationBarBackButtonHidden()
        .accentColor(Color("Green"))
    }
}




// 간단한 프로필 뷰
struct ProfileView: View {
    @AppStorage("nickname") private var nickname: String = ""
    @AppStorage("age") private var age: String = ""
    @AppStorage("goal") private var goal: String = ""
    var body: some View {
        VStack {

            Text("\(nickname)")
                .font(.title)
                .foregroundColor(Color("Green"))
                .bold()
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Divider()
            
            Text("목표 : \(goal)")
                .foregroundColor(Color("Green"))
                .bold()
            Spacer()
            
            }
            .padding(.horizontal)
            .padding(.top)
    }
}

