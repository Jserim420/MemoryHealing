struct ConversationDelegate {
    let chatBot = ChatBot()

    /// 사용자 질문에 대한 응답을 생성하고 반환합니다.
    func responseTo(question: String, completion: @escaping (String?) -> Void) {
        chatBot.makeRequest(question: question) { reply in
            // 응답 처리
            completion(reply)
        }
    }
}
