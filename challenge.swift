import SwiftUI

struct chall: Identifiable {
    let id = UUID() // 고유한 식별자
    let category: String // 챌린지 종류
    let vegetable: String // 챌린지 채소
    let startDate: Date // 시작 날짜
    let endDate: Date // 종료 날짜
    let targetRepetitions: Int // 목표 횟수
    var currentRepetitions: Int = 3 // 현재 진행한 횟수, 초기값은 0으로 설정
}

var challenges: [chall] = [
    chall(category: "요리", vegetable: "당근", startDate: Date(), endDate: Date().addingTimeInterval(604800), targetRepetitions: 5),
    chall(category: "미식", vegetable: "고구마", startDate: Date(), endDate: Date().addingTimeInterval(1209600), targetRepetitions: 10),
    chall(category: "기록", vegetable: "비트", startDate: Date(), endDate: Date().addingTimeInterval(706000), targetRepetitions: 6),
    chall(category: "색다름", vegetable: "고구마", startDate: Date(), endDate: Date().addingTimeInterval(909600), targetRepetitions: 23)
]


struct challenge: View {
    let veget : String
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(veget)와 함께하는 여정")
                .font(.title)
                .foregroundColor(Color("Green"))
                .bold()
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    HStack {
                        NavigationLink(destination: WhatToView(category: "미식", veget: veget)) {
                            CategorView(imageName: "eat", label: "미식")
                                .padding(.leading, 10)
                        }
                        NavigationLink(destination: WhatToView(category: "요리", veget: veget)) {
                            CategorView(imageName: "chef", label: "요리")
                                .padding(.leading, 10)
                        }
                    }
                    .padding(.top, 300)
                    
                    HStack {
                        NavigationLink(destination: WhatToView(category: "기록", veget: veget)) {
                            CategorView(imageName: "write", label: "기록")
                                .padding(.leading, 10)
                        }
                        NavigationLink(destination: WhatToView(category: "색다름", veget: veget)) {
                            CategorView(imageName: "awesome", label: "색다름")
                                .padding(.leading, 10)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .frame(height: 160) // ScrollView의 높이를 고정
            
            Spacer() // 나머지 공간을 채우기 위해 Spacer 추가
        }
        .padding(.horizontal) // 좌우 여백 추가
        
    }
}

struct CategorView: View {
    let imageName: String
    let label: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 150, height: 150)
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 15)
        }
    }
}


struct WhatToView: View {
    @State private var showingStartDatePicker = false
    @State private var showingEndDatePicker = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showAlert = false
    @State private var repetitions = 1
    @State private var navigateToNextView = false
    
    let category : String
    let veget: String
    
    // 오늘부터 20년 뒤의 날짜 계산
    let futureDate: Date = {
        var dateComponents = DateComponents()
        dateComponents.year = 20
        return Calendar.current.date(byAdding: dateComponents, to: Date())!
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("계획을 짜볼까요?")
                    .font(.title)
                    .foregroundColor(Color("Green"))
                    .bold()
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                
                Divider()
                
                // 시작 날짜 버튼
                Button(action: {
                    showingStartDatePicker.toggle()
                }) {
                    Text("시작 날짜 선택: \(formattedDate(date: startDate))")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showingStartDatePicker) {
                    DatePicker("시작 날짜", selection: $startDate, in: Date()...futureDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                }
                .padding(.top, 40)
                
                // 종료 날짜 버튼
                Button(action: {
                    showingEndDatePicker.toggle()
                }) {
                    Text("종료 날짜 선택: \(formattedDate(date: endDate))")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showingEndDatePicker) {
                    DatePicker("종료 날짜", selection: $endDate, in: startDate...futureDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                }
                
                Spacer()
                
                // 횟수 설정
                VStack {
                    Text("횟수 설정: \(repetitions)회")
                        .font(.headline)
                        .padding()
                    
                    Picker("횟수", selection: $repetitions) {
                        ForEach(1..<101) { i in
                            Text("\(i)회").tag(i)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if endDate < startDate {
                            showAlert = true
                        } else {
                            navigateToNextView = true
                        }
                    }) {
                        Text("다음")
                            .padding()
                            .background(Capsule().fill(Color("Green")))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("잘못된 날짜"), message: Text("종료 날짜는 시작 날짜보다 앞설 수 없습니다."), dismissButton: .default(Text("확인")))
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal)
                
                // NavigationLink를 버튼 외부로 이동
                NavigationLink(destination: NextView(startDate: startDate, endDate: endDate, repetitions: repetitions, category: category, veget: veget)
                               , isActive: $navigateToNextView) {
                    EmptyView()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    // 날짜 포맷팅 함수
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


struct NextView: View {
    let startDate: Date
    let endDate: Date
    let repetitions: Int
    let category: String
    let veget: String
    @State private var showAlert = false
    @State private var showMainScreen = false
    
    var body: some View {
        VStack {
            Text("\(category) 챌린지가 \n 시작되었어요!")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("Green")) // 제목 색상 유지
            
            Image("vegetabl")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
                .padding(40)
            
            Text("선택한 채소: \(veget)")
                .font(.headline) // 부가 정보 폰트 크기 조정
                .padding(.bottom, 5) // 여백 조정
                .foregroundColor(.secondary) // 부가 정보 텍스트 색상 조정
            
            Text("시작 날짜: \(formattedDate(date: startDate))")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.secondary)
            
            Text("종료 날짜: \(formattedDate(date: endDate))")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.secondary)
            
            Text("횟수: \(repetitions)회")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                showAlert = true
            }) {
                Text("완료")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Green"))
                    .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("지금부터 챌린지를 시작합니다!"), message: Text("당신의 챌린지를 응원합니다"), dismissButton: .default(Text("확인"), action: {
                    let newChallenge = chall(category: category, vegetable: veget, startDate: startDate, endDate: endDate, targetRepetitions: repetitions)
                    challenges.append(newChallenge)
                    showMainScreen = true
                }))
            }
            .padding()
        }
        .padding()
        .background(Color.white) // 배경색을 흰색으로 설정합니다.
        .navigationTitle("") // 타이틀을 빈 문자열로 설정합니다.
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼을 숨깁니다.
        .navigationBarHidden(true) // 네비게이션 바를 숨깁니다.
        .fullScreenCover(isPresented: $showMainScreen, content: {
            ContentView() // 전체 화면을 덮는 형태로 MainScreen을 띄웁니다.
        })
    }
    
    // 날짜 포맷팅 함수
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DetailView: View {
    @State private var showAlert = false
    @State private var showCongratsAlert = false

    var challenge: chall
    
    var body: some View {
        VStack {
            Text("\(challenge.category) : \(challenge.vegetable)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Green"))
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Divider()
            
            VStack(alignment: .center) {
                CircleProgressBar(progress: calculateProgress(challenge: challenge))
                    .frame(width: 250, height: 250)
                    .overlay(
                        Image("vegetabl")
                            .resizable()
                            .frame(width: 235, height: 235)
                            .clipShape(Circle())
                    )
                
                Text("진행률: \(calculateProgress(challenge: challenge) ?? 0)%")
                    .font(.headline)
                    .foregroundColor(Color("Green"))
                
                Button(action: {
                    increaseCurrentRepetitions(for: challenge)
                }) {
                    Text("달성")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("Green"))
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("축하합니다!"),
                        message: Text("도전 과제를 달성하셨습니다!"),
                        dismissButton: .default(Text("확인")) {
                            removeChallenge(challenge)
                        }
                    )
                }
                .alert(isPresented: $showCongratsAlert) {
                    Alert(
                        title: Text("축하합니다!"),
                        message: Text("목표를 달성하셨습니다!"),
                        dismissButton: .default(Text("확인")) {
                            removeChallenge(challenge)
                        }
                    )
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    // 현재 횟수 증가 함수
    func increaseCurrentRepetitions(for challenge: chall) {
        challenges.firstIndex(where: { $0.id == challenge.id }).map { index in
            if challenges[index].currentRepetitions < challenges[index].targetRepetitions {
                challenges[index].currentRepetitions += 1
                showAlert = challenges[index].currentRepetitions == challenges[index].targetRepetitions
                showCongratsAlert = showAlert
            }
        }
    }
    
    // 도전 과제 제거 함수
    func removeChallenge(_ challenge: chall) {
        challenges.removeAll(where: { $0.id == challenge.id })
    }
    
    // 진행률 계산 함수
    func calculateProgress(challenge: chall) -> Int? {
        guard challenge.targetRepetitions > 0 else { return nil }
        let progress = Double(challenge.currentRepetitions) / Double(challenge.targetRepetitions) * 100
        return Int(progress)
    }
}


struct chall_list: View {
    @State private var showingAlert = false
    @State private var selectedChallenge: chall?

    var body: some View {
        
                VStack(spacing: 10) {
                    
                    NavigationView {
                        
                        ScrollView {
                    Text("현재 진행중인 챌린지")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Green"))
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                                
                    Divider()
                        ForEach(challenges) { challenge in
                            NavigationLink(destination: DetailView(challenge: challenge)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(getCategoryImage(category: challenge.category))
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(challenge.vegetable) \(challenge.category) \(challenge.targetRepetitions)회")
                                                .font(.headline)
                                                .foregroundColor(Color("Green"))
                                            Text("\(formattedDate(date: challenge.startDate)) ~ \(formattedDate(date: challenge.endDate))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            if let progress = calculateProgress(challenge: challenge) {
                                                Text("진행률: \(progress)%")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            selectedChallenge = challenge
                                            showingAlert = true
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .frame(width: 340, height: 100) // 고정 높이 설정
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                                    
        }
        .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("챌린지 포기"),
                    message: Text("정말로 이 챌린지를 포기하시겠습니까?"),
                    primaryButton: .destructive(Text("포기")) {
                    if let challenge = selectedChallenge {
                            challenges.removeAll(where: { $0.id == challenge.id })
                        }
                    },
                    secondaryButton: .cancel()
                )
        }
    }

    
    // 날짜 포맷팅 함수
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // 챌린지 종류에 따른 이미지 선택 함수
    func getCategoryImage(category: String) -> String {
        switch category {
        case "요리":
            return "chef" // 시스템 아이콘 예시
        case "미식":
            return "eat"
        case "기록":
            return "write"
        case "색다름":
            return "awesome"
        default:
            return "awesome"
        }
    }
    
    func calculateProgress(challenge: chall) -> Int? {
        guard challenge.targetRepetitions > 0 else { return nil }
        let progress = Double(challenge.currentRepetitions) / Double(challenge.targetRepetitions) * 100
        return Int(progress)
    }
}

struct CircleProgressBar: View {
    var progress: Int?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color("Green"))
            
            if let progress = progress {
                Circle()
                    .trim(from: 0, to: CGFloat(progress) / 100)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color("Green"))
                    .rotationEffect(Angle(degrees: -90))
            }
        }
    }
}
