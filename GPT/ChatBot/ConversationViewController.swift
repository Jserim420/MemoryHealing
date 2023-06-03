import UIKit

/// 사용자 상호작용 및 테이블 뷰 표시를 관리합니다.
class ConversationViewController: UITableViewController {
    
    var questionAnswerer = ConversationDelegate()
    let conversationSource = ConversationDataSource()
    
    private let thinkingTime: TimeInterval = 2
    fileprivate var isThinking = false
    
    /// 사용자가 질문을 입력할 때 호출됩니다.
    fileprivate func respondToQuestion(_ questionText: String) {
        print("main.respondToQuestion()")
        // 앱이 생각하는 동안에는 질문을 할 수 없습니다.
        isThinking = true
        // 이 체크는 테이블에 셀을 추가할 때 메시지 개수가 변경되어야 하기 때문에 필요합니다.
        let countBefore = conversationSource.messageCount
        conversationSource.add(question: questionText)
        let count = conversationSource.messageCount
        // 질문이 추가된 경우에만 질문 셀에 대한 인덱스 패스를 저장합니다.
        var questionPath: IndexPath?
        if count != countBefore {
            // 대화의 끝에 새로운 셀을 위한 인덱스 패스를 생성합니다.
            questionPath = IndexPath(row: count - 1, section: ConversationSection.history.rawValue)
        }
        // 생각하는 셀과 새로 추가된 질문 셀(있는 경우)을 삽입합니다.
        tableView.insertRows(at: [questionPath, ConversationSection.thinkingPath].compactMap { $0 }, with: .bottom)
        tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        
        
        // 생각하는 시간이 지난 후에 답변을 추가하기 위해 대기합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + thinkingTime) {
            // 다른 질문을 할 수 있도록 설정합니다.
            self.isThinking = false
            let dispatchGroup = DispatchGroup()
            var answer = ""
            // 동기적 실행
            dispatchGroup.enter()
            // 질문에 대한 답변을 질문 답변기에서 가져옵니다.let conversationDelegate = ConversationDelegate()
            self.questionAnswerer.responseTo(question: questionText) { response in
                if let response = response {
                    print("main.응답: \(response)")
                    answer = response
                } else {
                    print("응답을 가져오지 못했습니다.")
                    // 에러 처리
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
            //let answer = self.questionAnswerer.responseTo(question: questionText)
            // 답변을 추가하면 메시지 개수가 실제로 증가하는지 확인합니다.
            let countBefore = self.conversationSource.messageCount
            self.conversationSource.add(answer: answer)
            let count = self.conversationSource.messageCount
            // 테이블에 여러 업데이트가 발생하므로 begin / end 업데이트 호출 내에서 그룹화합니다.
            self.tableView.beginUpdates()
            // 답변 셀을 추가합니다(있는 경우).
            if count != countBefore {
                self.tableView.insertRows(at: [IndexPath(row: count - 1, section: ConversationSection.history.rawValue)], with: .fade)
            }
            // 생각하는 셀을 삭제합니다.
            self.tableView.deleteRows(at: [ConversationSection.thinkingPath], with: .fade)
            self.tableView.endUpdates()
            // 질문 입력 셀이 보이도록 스크롤합니다.
            self.tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
    }
}

/// 텍스트 필드의 delegate는 텍스트 필드에 흥미로운 일이 발생할 때 호출됩니다.
/// (사용자가 질문을 입력하는 영역입니다.)
extension ConversationViewController: UITextFieldDelegate {
    
    // 사용자가 Return 키를 누를 때 호출됩니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 텍스트가 없는 경우 아무 작업도 수행하지 않습니다.
        guard let text = textField.text else {
            return false
        }
        
        // 앱이 생각하는 중인 경우 아무 작업도 수행하지 않습니다.
        if isThinking {
            return false
        }
        
        // 텍스트를 지웁니다.
        textField.text = nil
        // 질문에 대한 응답 처리
        respondToQuestion(text)
        return false
    }
}

// MARK: - Table view data source
// 대화 데이터 소스와 비슷하지만 더 많은 세부 정보를 처리합니다.
extension ConversationViewController {
    
    // 테이블의 섹션을 정의하는 데 사용됩니다.
    fileprivate enum ConversationSection: Int {
        // 대화가 진행되는 곳
        case history = 0
        // 생각하는 표시기가 있는 곳
        case thinking = 1
        // 질문 상자가 있는 곳
        case ask = 2
        
        static var sectionCount: Int {
            return self.ask.rawValue + 1
        }
        
        static var allSections: IndexSet {
            return IndexSet(integersIn: 0..<sectionCount)
        }
        
        static var askPath: IndexPath {
            return IndexPath(row: 0, section: self.ask.rawValue)
        }
        
        static var thinkingPath: IndexPath {
            return IndexPath(row: 0, section: self.thinking.rawValue)
        }
    }
    
    // 테이블의 섹션 수는 몇 개인가요?
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationSection.sectionCount
    }
    
    // 특정 섹션의 테이블에 몇 개의 행이 있나요?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ConversationSection(rawValue: section)! {
        case .history:
            // 이것은 대화 데이터 소스에 의해 물어보는 질문 중 하나입니다.
            return conversationSource.messageCount
        case .thinking:
            // 생각 중이 아닌 경우 셀이 없음, 생각 중인 경우 1개의 셀
            return isThinking ? 1 : 0
        case .ask:
            // 질문 섹션에는 항상 1개의 셀이 있음
            return 1
        }
    }
    
    // 테이블에서 특정 셀을 요청합니다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .history:
            // 적절한 메시지를 가져오기 위해 대화 데이터 소스에 요청합니다.
            let message = conversationSource.messageAt(index: indexPath.row)
            
            // 메시지 유형에 따라 올바른 식별자를 가져옵니다.
            let identifier: String
            switch message.type {
            case .myQuestion: identifier = "Question"
            case .BotAnswer: identifier = "Answer"
            }
            // 스토리보드에서 올바른 디자인의 셀을 가져옵니다.
            let cell: ConversationCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConversationCell
            // 메시지와 함께 셀의 필드를 설정합니다.
            cell.configureWithMessage(message)
            return cell
        case .thinking:
            // 생각 중인 셀은 항상 동일합니다.
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thinking", for: indexPath) as! ThinkingCell
            cell.thinkingImage.startAnimating()
            return cell
        case .ask:
            // 질문 섹션은 항상 동일합니다. 텍스트 필드 delegate가 설정되어 있어 사용자가 질문을 했을 때 알 수 있습니다.
            let cell: AskCell = tableView.dequeueReusableCell(withIdentifier: "Ask", for: indexPath) as! AskCell
            if cell.textField.delegate == nil {
                cell.textField.becomeFirstResponder()
                cell.textField.delegate = self
            }
            return cell
        }
    }
}

// MARK: - Table view delegate
extension ConversationViewController {
    // 각 행의 예상 높이입니다.
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    // 콘텐츠를 기반으로 셀의 올바른 높이를 설정하는 데 사용됩니다.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
