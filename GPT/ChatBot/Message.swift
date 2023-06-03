import Foundation

// 메시지 소스
/// 메시지의 유형
enum MessageType {
    case myQuestion  // 나의 질문
    case BotAnswer   // 챗봇의 답변
}

/// 앱 사용자가 생성한 대화 항목
struct Message {
    let date: Date  // 날짜
    let text: String  // 텍스트 내용
    let type: MessageType  // 메시지의 유형
}

/// 대화를 시작하기 위해 표시되는 환영 메시지
let openingLine = Message(date: Date(), text: "안녕하세요! 사용자님의 고민을 털어놔 보세요.", type: .BotAnswer)

struct UserQuestion {
    let message: Message  // 메시지
    let isSent: Bool  // 전송 여부
}

struct BotAnswer {
    let message: Message  // 메시지
    let isReceived: Bool  // 수신 여부
}
