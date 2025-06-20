import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;

  // Ganti dengan API Key kamu dari openrouter.ai
  final String apiKey =
      "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";

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      isLoading = true;
    });

    final uri = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": "https://yourapp.com",
          "X-Title": "TaniCerdas Chatbot",
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": text},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];
        setState(() {
          messages.add({"role": "bot", "text": reply});
        });
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text": "Gagal menjawab (kode: ${response.statusCode})",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "text": "Terjadi kesalahan jaringan: $e"});
      });
    }

    setState(() {
      isLoading = false;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanya AI (OpenRouter)'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ...messages.map((msg) {
                  final isUser = msg['role'] == 'user';
                  return Container(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  );
                }).toList(),
                if (isLoading)
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      const CircularProgressIndicator(strokeWidth: 2),
                      const SizedBox(width: 12),
                      Text(
                        "Bot sedang mengetik...",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: sendMessage,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pertanyaan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.green[700],
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
