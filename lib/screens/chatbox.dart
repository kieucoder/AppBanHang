import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ChatBox extends StatefulWidget {
  final int userId;            // ID của user
  final bool isAdminView;      // Nếu là admin mở chat

  const ChatBox({
    super.key,
    required this.userId,
    this.isAdminView = false,
  });

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final DBHelper _db = DBHelper();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];



  final List<Map<String,dynamic>> _responseMessage = [
    {
      'keywords': ['giá','bao nhiêu', 'cost', 'price'],
      'response': 'Sản phẩm của chúng tôi có nhiều mức giá phù hợp, bạn vui lòng cho biết thêm thông tin sản phẩm'
    },
    {
      'keywords': ['ship','giao hàng','vận chuyển','giao'],
      'response': 'Shop chúng tôi hỗ trợ vận chuyển toàn quốc'
    },
    {
      'keywords': ['mua', 'đặt hàng', 'order'],
      'response': 'Bạn có thể đặt hàng qua COD hoặc liên hệ số 0899069754'
    },
    {
      'keywords': ['hỗ trợ','contact','liên hệ'],
      'response': 'Bạn cần hỗ trợ về điều gì cần tôi hỗ trợ vấn đề gì ?'
    }


  ];



  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  /// Tải lịch sử tin nhắn từ DB
  Future<void> _loadMessages() async {
    try {
      final data = await _db.getChatMessages(widget.userId);
      setState(() {
        // _messages = data;
        // _messages = List<Map<String, dynamic>>.from(data);
        setState(() {
          _messages = List<Map<String, dynamic>>.from(data.map((m) => {
            'sender': m['sender'],
            'message': m['message'],
            'created_at': m['created_at']
          }));
        });
      });

      // Cuộn xuống cuối
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print("Lỗi load chat: $e");
    }
  }



  //gọi danh sách các lệnh câu như ai
  String _getAdminResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    for (var pattern in _responseMessage) {
      for (var keyword in pattern['keywords']) {
        if (message.contains(keyword)) {
          return pattern['response'];
        }
      }
    }

    return "Cảm ơn bạn đã liên hệ, chúng tôi sẽ phản hồi sớm!";
  }



  /// Gửi tin nhắn
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final sender = widget.isAdminView ? 'admin' : 'user';

    try {
      // Lưu tin nhắn vào DB
      await _db.insertChatMessage(
        userId: widget.userId,
        sender: sender,
        message: text,
      );

      setState(() {
        _messages.add({
          'sender': sender,
          'message': text,
          'created_at': DateTime.now().toIso8601String(),
        });
        _messageController.clear();
      });

      _scrollToBottom();

      // Nếu là user -> giả lập admin trả lời
      // if (!widget.isAdminView) {
      //   Future.delayed(const Duration(seconds: 1), () async {
      //     final aiResponse = "Cảm ơn bạn! Chúng tôi sẽ liên hệ sớm.";
      //     await _db.insertChatMessage(
      //       userId: widget.userId,
      //       sender: 'admin',
      //       message: aiResponse,
      //     );
      //
      //     setState(() {
      //       _messages.add({
      //         'sender': 'admin',
      //         'message': aiResponse,
      //         'created_at': DateTime.now().toIso8601String(),
      //       });
      //     });
      //     _scrollToBottom();
      //   });
      // }
      if (!widget.isAdminView) {
        Future.delayed(const Duration(seconds: 1), () async {
          final aiResponse = _getAdminResponse(text);

          await _db.insertChatMessage(
            userId: widget.userId,
            sender: 'admin',
            message: aiResponse,
          );

          setState(() {
            _messages.add({
              'sender': 'admin',
              'message': aiResponse,
              'created_at': DateTime.now().toIso8601String(),
            });
          });
          _scrollToBottom();
        });
      }

    } catch (e) {
      print("Lỗi gửi tin nhắn: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không gửi được tin nhắn: $e")),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Bubble tin nhắn
  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    // final isUser = msg['sender'] == 'user'; //tin nhắn làm cho người gửi admin nằm bên trái
    bool isUser = false;
    if(widget.isAdminView){
      isUser = msg['seder'] == 'admin';
    }else{
      isUser = msg['sender'] == 'user';
    }
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.orange,
              child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 18),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[300] : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                msg['message'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }

  /// UI chính
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdminView
            ? "Chat với User #${widget.userId}"
            : "Hỗ trợ trực tuyến"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("Chưa có tin nhắn"))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
