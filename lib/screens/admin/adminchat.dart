import 'package:flutter/material.dart';
import '../../database/db_helper.dart';


class ChatBox extends StatefulWidget {
  final int userId;            // ID của user
  final bool isAdminView;      // True nếu là admin mở chat

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
        setState(() {
          _messages = List<Map<String, dynamic>>.from(data.map((m) => {
            'sender': m['sender'],
            'message': m['message'],
            'created_at': m['created_at']
          }));
        });


      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print("Lỗi load chat: $e");
    }
  }

  /// Gửi tin nhắn
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final sender = widget.isAdminView ? 'admin' : 'user';

    try {
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

  /// Hiển thị một bubble tin nhắn
  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isAdmin = msg['sender'] == 'admin';

    // Nếu là admin view, tin nhắn admin nằm bên phải, user bên trái
    // Nếu là user view, tin nhắn user nằm bên phải
    bool isCurrentSender = widget.isAdminView ? isAdmin : !isAdmin;

    return Align(
      alignment: isCurrentSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
        isCurrentSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentSender)
            CircleAvatar(
              radius: 16,
              backgroundColor: msg['sender'] == 'admin'
                  ? Colors.orange
                  : Colors.blue,
              child: Icon(
                msg['sender'] == 'admin'
                    ? Icons.admin_panel_settings
                    : Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isCurrentSender ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                msg['message'] ?? '',
                style: TextStyle(
                  color: isCurrentSender ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isCurrentSender)
            CircleAvatar(
              radius: 16,
              backgroundColor:
              widget.isAdminView ? Colors.orange : Colors.blue,
              child: Icon(
                widget.isAdminView
                    ? Icons.admin_panel_settings
                    : Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

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
