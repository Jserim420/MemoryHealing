import Foundation

class ConversationDataSource {
    var messages = [openingLine]  // 대화 메시지 배열
    
    // 대화 메시지 개수
    var messageCount: Int {
        return messages.count  // 대화 메시지 개수를 반환하는 속성
    }
    
    // 질문을 대화 메시지로 추가
    func add(question: String) {
        print("Asked to add question: \(question)")
        let message = Message(date: Date(), text: question, type: .myQuestion)
        messages.append(message)
    }

    // 대답을 대화에 추가
    func add(answer: String) {
        print("대답 : \(answer)")
        let message = Message(date: Date(), text: answer, type: .BotAnswer)
        messages.append(message)
    }
    
    // 해당 대화의 메시지 찾기
    func messageAt(index: Int) -> Message {
        print("주어진 인덱스 \(index)")
        // 주어진 인덱스에 해당하는 메시지 반환
        return messages[index]
    }
}
