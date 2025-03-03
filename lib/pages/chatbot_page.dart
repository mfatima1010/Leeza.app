import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_leeza_app/widgets/growing_tree_loader.dart';

/// ChatMessage model.
class ChatMessage {
  final String message;
  final bool isUser; // true if sent by the user, false if by the bot.
  ChatMessage({required this.message, required this.isUser});

  Map<String, dynamic> toJson() => {
        'message': message,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      isUser: json['isUser'],
    );
  }
}

/// ChatBubble widget with markdown support.
/// If the bot message starts with "Chain of Thought:", it will be displayed in an ExpansionTile.
class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isExpanded = false;
  static const int maxLength = 300;

  @override
  Widget build(BuildContext context) {
    final text = widget.message.message;
    bool shouldTruncate = !widget.message.isUser && text.length > maxLength;
    String displayText = shouldTruncate && !isExpanded
        ? text.substring(0, maxLength) + "..."
        : text;

    // If this is a bot message that starts with "Chain of Thought:",
    // display it as a collapsible tile.
    if (!widget.message.isUser && text.startsWith("Chain of Thought:")) {
      final cotText = text.replaceFirst("Chain of Thought:", "").trim();
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Card(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ExpansionTile(
            title: const Text(
              "Chain of Thought",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MarkdownBody(
                  data: cotText,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    // For normal messages, use MarkdownBody for bot messages and Text for user messages.
    final Widget messageWidget = widget.message.isUser
        ? Text(
            displayText,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        : MarkdownBody(
            data: displayText,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      alignment:
          widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.message.isUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            messageWidget,
            if (shouldTruncate && !isExpanded)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                child: const Text("Read More", style: TextStyle(fontSize: 14)),
              ),
          ],
        ),
      ),
    );
  }
}

/// ChatbotPage widget.
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

/// Enum for chat modes
enum ChatMode { general, assessment, therapy, crisis, caregiver }

class _ChatbotPageState extends State<ChatbotPage>
    with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isSearchMode = false;
  bool _isDeepReasoningMode = false; // Toggle for deep reasoning mode

  // Gemini API configuration.
  final String geminiApiKey = "AIzaSyCH6YR-GckxCuv7Qn4zbiWIdhMafbf4JaY";
  final String geminiEndpoint =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  // Groq API configuration (for deep reasoning mode).
  final String groqApiKey =
      "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";
  final String groqEndpoint = "https://api.groq.com/openai/v1/chat/completions";
  final String groqModel =
      "deepseek-r1-distill-llama-70b"; // (Adjust model as needed)

  // SerpAPI configuration.
  final String serpApiKey =
      "cf82979d88fca7a1df9450bbf042918740356f083feb4ce5a30021496b9b4559";
  final String serpEndpoint = "https://serpapi.com/search";

  // Tavily Search API configuration.
  final String tavilyApiKey = "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";
  final String tavilyEndpoint = "https://api.tavily.com/search";

  ChatMode _currentMode = ChatMode.general;

  // Updated prompts based on categories
  final Map<ChatMode, List<String>> _categoryPrompts = {
    ChatMode.general: [
      "What is autism spectrum disorder?",
      "How can I support daily routines?",
      "What are common autism myths?",
      "Where can I find local support groups?",
      "How does autism affect social interaction?",
    ],
    ChatMode.assessment: [
      "What are early signs of autism?",
      "When should I seek professional evaluation?",
      "What screening tools are available?",
      "How is autism diagnosed?",
      "What developmental milestones should I watch for?",
    ],
    ChatMode.therapy: [
      "What therapy options are available?",
      "How does ABA therapy work?",
      "What is speech therapy's role?",
      "How can I support therapy at home?",
      "How to track therapy progress?",
    ],
    ChatMode.crisis: [
      "How to handle a meltdown?",
      "What are calming techniques?",
      "When should I seek emergency help?",
      "How to create a safety plan?",
      "What are sensory overload signs?",
    ],
    ChatMode.caregiver: [
      "How can I practice self-care?",
      "How to support siblings?",
      "What are IEP advocacy tips?",
      "How to build a support network?",
      "What financial resources exist?",
    ],
  };

  // Chat sessions for history (for the drawer).
  final List<String> _chatSessions = ["Current Session"];

  // Chat categories for top navigation.
  final List<String> _categories = [
    "General",
    "Assessment",
    "Therapy",
    "Crisis",
    "Caregiver"
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// Loads chat history from SharedPreferences.
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('chatHistory');
    if (historyString != null) {
      final List<dynamic> historyJson = jsonDecode(historyString);
      setState(() {
        _messages.clear();
        _messages.addAll(
            historyJson.map((msg) => ChatMessage.fromJson(msg)).toList());
      });
    }
  }

  /// Saves chat history.
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _messages.map((msg) => msg.toJson()).toList();
    await prefs.setString('chatHistory', jsonEncode(historyJson));
  }

  /// Clears the current chat.
  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _saveHistory();
  }

  /// A helper function to detect if a query is complex.
  bool _isQueryComplex(String query) {
    // Simple heuristic: if it contains any math operators.
    return query.contains(RegExp(r'[+\-*/=]')) || query.length > 100;
  }

  /// Converts LaTeX expressions to plain text for user-friendly display.
  String convertLatexToPlainText(String text) {
    // Replace simple fractions: \frac{a}{b} -> "a ÷ b"
    text = text.replaceAllMapped(RegExp(r'\\frac\{([^}]+)\}\{([^}]+)\}'),
        (match) => "${match.group(1)} ÷ ${match.group(2)}");
    // Remove dollar signs used for inline math mode.
    text = text.replaceAll("\$", "");
    // Remove inline math delimiters: \( ... \) and \[ ... \]
    text = text.replaceAll("\\(", "").replaceAll("\\)", "");
    text = text.replaceAll("\\[", "").replaceAll("\\]", "");
    // Optionally, remove any remaining backslashes.
    text = text.replaceAll("\\", "");
    return text;
  }

  /// Get mode-specific system prompt
  String _getModeSystemPrompt() {
    switch (_currentMode) {
      case ChatMode.general:
        return """You are a knowledgeable and supportive AI assistant specializing in autism information. 
                 Provide clear, accurate information using respectful language. 
                 Focus on evidence-based information and practical advice.""";

      case ChatMode.assessment:
        return """You are an assessment-focused AI assistant. 
                 Provide detailed information about autism screening and diagnosis.
                 Always emphasize the importance of professional evaluation.
                 Use clinical terminology appropriately but explain concepts clearly.""";

      case ChatMode.therapy:
        return """You are a therapy-focused AI assistant.
                 Provide information about various therapy options and techniques.
                 Emphasize evidence-based interventions.
                 Include practical examples and home-based strategies.""";

      case ChatMode.crisis:
        return """You are a crisis support AI assistant.
                 Provide clear, step-by-step guidance for managing difficult situations.
                 Emphasize safety and emergency resources.
                 Use calm, direct language and prioritize immediate needs.""";

      case ChatMode.caregiver:
        return """You are a caregiver support AI assistant.
                 Provide emotional support and practical advice for caregivers.
                 Focus on self-care, family dynamics, and resource navigation.
                 Use empathetic language and acknowledge challenges.""";
    }
  }

  /// Enhanced message sending with mode-specific handling
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(message: message, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    await _saveHistory();

    // Combine user message with mode-specific system prompt
    String systemPrompt = _getModeSystemPrompt();
    String enhancedPrompt = """$systemPrompt

User Query: $message

Please provide a response that is:
1. Specific to the ${_currentMode.toString().split('.').last} context
2. Evidence-based and accurate
3. Practical and actionable
4. Sensitive to the needs of autism community
5. Clear and well-structured""";

    if (_isSearchMode) {
      if (_isDeepReasoningMode && _isQueryComplex(message)) {
        await _sendSearchAndGroqMessage(enhancedPrompt);
      } else {
        await _sendSearchAndGeminiMessage(enhancedPrompt);
      }
    } else {
      if (_isDeepReasoningMode && _isQueryComplex(message)) {
        await _sendGroqMessageStream(enhancedPrompt);
      } else {
        await _sendGeminiMessage(enhancedPrompt);
      }
    }
  }

  /// Sends a message to the Gemini API.
  Future<void> _sendGeminiMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$geminiEndpoint?key=$geminiApiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String reply = data["candidates"]?[0]?["content"]?["parts"]?[0]
                ?["text"] ??
            "I'm sorry, I couldn't process that.";
        // Convert LaTeX to plain text.
        reply = convertLatexToPlainText(reply);
        setState(() {
          _messages.insert(0, ChatMessage(message: reply, isUser: false));
        });
      } else {
        setState(() {
          _messages.insert(
              0,
              ChatMessage(
                  message: "Error: ${response.statusCode}", isUser: false));
        });
        print('Gemini API failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(message: "Error: $e", isUser: false));
      });
      print('Error during Gemini API call: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      await _saveHistory();
    }
  }

  /// Sends a message to the Groq API using streaming to display chain-of-thought.
  Future<void> _sendGroqMessageStream(String message) async {
    final request = http.Request("POST", Uri.parse(groqEndpoint));
    request.headers["Content-Type"] = "application/json";
    request.headers["Authorization"] = "Bearer $groqApiKey";
    request.body = jsonEncode({
      "model": groqModel,
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.6,
      "max_completion_tokens": 4096,
      "top_p": 0.95,
      "stream": true,
      "stop": null
    });
    final client = http.Client();
    String accumulatedCoT = "";
    try {
      final streamedResponse = await client.send(request);
      await streamedResponse.stream.transform(utf8.decoder).listen((chunk) {
        try {
          // Process each chunk (assume each line is an SSE event)
          final events =
              chunk.split('\n').where((line) => line.trim().isNotEmpty);
          for (var event in events) {
            if (event.startsWith('data: ')) {
              event = event.substring(6);
            }
            if (event.trim() == '[DONE]') continue;
            final jsonChunk = jsonDecode(event);
            String? deltaContent =
                jsonChunk["choices"]?[0]?["delta"]?["content"];
            if (deltaContent != null) {
              accumulatedCoT += deltaContent;
              // Update (or insert) a chain-of-thought message.
              setState(() {
                if (_messages.isNotEmpty &&
                    !_messages.first.isUser &&
                    _messages.first.message.startsWith("Chain of Thought:")) {
                  _messages[0] = ChatMessage(
                      message: "Chain of Thought:\n$accumulatedCoT",
                      isUser: false);
                } else {
                  _messages.insert(
                      0,
                      ChatMessage(
                          message: "Chain of Thought:\n$accumulatedCoT",
                          isUser: false));
                }
              });
            }
          }
        } catch (e) {
          print("Error processing JSON event: $e");
        }
      }).asFuture();
      // After stream ends, treat accumulatedCoT as the final chain (if needed)
      // For this example, we assume the final answer is the last update of chain-of-thought.
      setState(() {
        _messages.insert(
            0,
            ChatMessage(
                message: convertLatexToPlainText(accumulatedCoT),
                isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatMessage(message: "Error: $e", isUser: false));
      });
      print("Error during Groq streaming call: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
      await _saveHistory();
    }
  }

  /// Sends a message using search APIs then processes with Gemini.
  Future<void> _sendSearchAndGeminiMessage(String message) async {
    String searchSnippet = "";
    try {
      final serpUri = Uri.parse(
          "$serpEndpoint?api_key=$serpApiKey&q=${Uri.encodeComponent(message)}");
      final serpResponse = await http.get(serpUri);
      if (serpResponse.statusCode == 200) {
        final data = jsonDecode(serpResponse.body);
        if (data["organic_results"] != null &&
            data["organic_results"].isNotEmpty) {
          searchSnippet = data["organic_results"][0]["snippet"] ?? "";
        } else {
          searchSnippet = "No results found.";
        }
      } else {
        print('SerpAPI failed with status: ${serpResponse.statusCode}');
      }
    } catch (e) {
      print('Error during SerpAPI call: $e');
    }
    if (searchSnippet.isEmpty) {
      try {
        final tavilyUri = Uri.parse(tavilyEndpoint);
        final tavilyResponse = await http.post(
          tavilyUri,
          headers: {
            "Authorization": "Bearer tvly-dev-$tavilyApiKey",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "query": message,
            "topic": "general",
            "search_depth": "basic",
            "max_results": 1,
            "days": 3,
            "include_answer": true,
            "include_raw_content": false,
            "include_images": false,
            "include_image_descriptions": false,
            "include_domains": [],
            "exclude_domains": []
          }),
        );
        if (tavilyResponse.statusCode == 200) {
          final data = jsonDecode(tavilyResponse.body);
          searchSnippet = data["answer"] ?? "";
        } else {
          print('Tavily API failed with status: ${tavilyResponse.statusCode}');
        }
      } catch (e) {
        print('Error during Tavily API call: $e');
      }
    }
    String combinedQuery = "$message\n\nSearch Info: $searchSnippet";
    await _sendGeminiMessage(combinedQuery);
  }

  /// Sends a message using search APIs then processes with Groq.
  Future<void> _sendSearchAndGroqMessage(String message) async {
    String searchSnippet = "";
    try {
      final serpUri = Uri.parse(
          "$serpEndpoint?api_key=$serpApiKey&q=${Uri.encodeComponent(message)}");
      final serpResponse = await http.get(serpUri);
      if (serpResponse.statusCode == 200) {
        final data = jsonDecode(serpResponse.body);
        if (data["organic_results"] != null &&
            data["organic_results"].isNotEmpty) {
          searchSnippet = data["organic_results"][0]["snippet"] ?? "";
        } else {
          searchSnippet = "No results found.";
        }
      } else {
        print('SerpAPI failed with status: ${serpResponse.statusCode}');
      }
    } catch (e) {
      print('Error during SerpAPI call: $e');
    }
    if (searchSnippet.isEmpty) {
      try {
        final tavilyUri = Uri.parse(tavilyEndpoint);
        final tavilyResponse = await http.post(
          tavilyUri,
          headers: {
            "Authorization": "Bearer tvly-dev-$tavilyApiKey",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "query": message,
            "topic": "general",
            "search_depth": "basic",
            "max_results": 1,
            "days": 3,
            "include_answer": true,
            "include_raw_content": false,
            "include_images": false,
            "include_image_descriptions": false,
            "include_domains": [],
            "exclude_domains": []
          }),
        );
        if (tavilyResponse.statusCode == 200) {
          final data = jsonDecode(tavilyResponse.body);
          searchSnippet = data["answer"] ?? "";
        } else {
          print('Tavily API failed with status: ${tavilyResponse.statusCode}');
        }
      } catch (e) {
        print('Error during Tavily API call: $e');
      }
    }
    String combinedQuery = "$message\n\nSearch Info: $searchSnippet";
    await _sendGroqMessageStream(combinedQuery);
  }

  /// Build predefined prompts based on current mode
  Widget _buildPredefinedPrompts() {
    if (_messages.any((msg) => msg.isUser)) return const SizedBox.shrink();

    List<String> currentPrompts = _categoryPrompts[_currentMode] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              "Suggested Questions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true, // Important to prevent overflow
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(4),
            children: currentPrompts.map((prompt) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCB6CE6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFCB6CE6).withOpacity(0.2),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _sendMessage(prompt),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          prompt,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFCB6CE6),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Builds the drawer for chat history with an enhanced design
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE5A0FF), // Lighter purple
              Color(0xFFFFD27A), // Lighter yellow
            ],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Chat History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _chatSessions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: Text(_chatSessions[index]),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.of(context).pop();
                          // Future: navigate to the selected chat session
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an enhanced bottom input row with mode toggles
  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildModeToggle(
                  icon: Icons.public,
                  isActive: _isSearchMode,
                  onTap: () => setState(() => _isSearchMode = !_isSearchMode),
                ),
                _buildModeToggle(
                  icon: Icons.lightbulb_outline,
                  isActive: _isDeepReasoningMode,
                  onTap: () => setState(
                      () => _isDeepReasoningMode = !_isDeepReasoningMode),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE5A0FF), // Lighter purple
                  Color(0xFFFFD27A), // Lighter yellow
                ],
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.blue[400] : Colors.grey,
            size: 22,
          ),
        ),
      ),
    );
  }

  /// Builds a "New Chat" button with a simple design.
  Widget _buildNewChatButton() {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFCB6CE6),
      ),
      onPressed: _clearChat,
      icon: const Icon(Icons.chat_bubble_outline),
      label: const Text("New Chat"),
    );
  }

  /// Builds the mode dropdown
  Widget _buildModeDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<ChatMode>(
            value: _currentMode,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Row(
              children: [
                Icon(Icons.touch_app, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  "Select mode to customize responses",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            items: ChatMode.values.map((ChatMode mode) {
              String label = mode.toString().split('.').last;
              // Capitalize first letter and add spaces before capital letters
              label = label[0].toUpperCase() +
                  label.substring(1).replaceAllMapped(
                      RegExp(r'[A-Z]'), (Match m) => ' ${m[0]}');

              IconData icon;
              switch (mode) {
                case ChatMode.general:
                  icon = Icons.chat_bubble_outline;
                  break;
                case ChatMode.assessment:
                  icon = Icons.assessment_outlined;
                  break;
                case ChatMode.therapy:
                  icon = Icons.healing_outlined;
                  break;
                case ChatMode.crisis:
                  icon = Icons.emergency_outlined;
                  break;
                case ChatMode.caregiver:
                  icon = Icons.favorite_outline;
                  break;
              }

              return DropdownMenuItem<ChatMode>(
                value: mode,
                child: Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (ChatMode? newMode) {
              if (newMode != null) {
                setState(() {
                  _currentMode = newMode;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _buildDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text("Leeza AI"),
        centerTitle: true,
        actions: [
          _buildNewChatButton(),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildModeDropdown(),
            Expanded(
              child: Column(
                children: [
                  _buildPredefinedPrompts(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) =>
                          ChatBubble(message: _messages[index]),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GrowingTreeLoader(
                    size: 120, // Adjust size as needed
                    duration: const Duration(
                        seconds: 2), // Adjust animation duration as needed
                  ),
                ),
              ),
            _buildInputRow(),
          ],
        ),
      ),
    );
  }
}
