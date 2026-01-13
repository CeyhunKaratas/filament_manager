import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _helpContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHelpContent();
  }

  Future<void> _loadHelpContent() async {
    try {
      // Load HELP.md from assets
      final content = await rootBundle.loadString('HELP.md');
      if (mounted) {
        setState(() {
          _helpContent = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading help content: $e');
      if (mounted) {
        setState(() {
          _helpContent = '# Help\n\nHelp content could not be loaded.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'help'),
      appBar: AppBar(
        title: Text(strings.help),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadHelpContent();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _helpContent,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                p: const TextStyle(fontSize: 14, height: 1.5),
                code: TextStyle(
                  backgroundColor: Colors.grey.shade200,
                  fontFamily: 'monospace',
                ),
                blockquote: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
    );
  }
}
