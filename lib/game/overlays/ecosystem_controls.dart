import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ecosystem_game.dart';
import '../../services/gemini_service.dart';

class EcosystemControls extends StatefulWidget {
  static const String id = 'EcosystemControls';
  
  const EcosystemControls({super.key, required this.game});
  final EcosystemGame game;

  @override
  State<EcosystemControls> createState() => _EcosystemControlsState();
}

class _EcosystemControlsState extends State<EcosystemControls> {
  final GeminiService _geminiService = GeminiService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Left: Back Button
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        // Bottom Panel: Controls
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSlider(context, 
                  label: 'عدد الأسماك', 
                  icon: Icons.set_meal, 
                  color: Colors.orange,
                  value: widget.game.targetFishCount.toDouble(), 
                  min: 0, max: 20, 
                  onChanged: (v) => widget.game.setFishCount(v)
                ),
                _buildSlider(context, 
                  label: 'النباتات البحرية', 
                  icon: Icons.grass, 
                  color: Colors.green,
                  value: widget.game.targetSeaweedCount.toDouble(), 
                  min: 0, max: 10, 
                  onChanged: (v) => widget.game.setSeaweedCount(v)
                ),
                _buildSlider(context, 
                  label: 'مستوى التلوث', 
                  icon: Icons.delete_outline, 
                  color: Colors.grey,
                  value: widget.game.pollutionLevel, 
                  min: 0, max: 1, 
                  onChanged: (v) => widget.game.setPollutionLevel(v),
                  divisions: 10
                ),
              ],
            ),
          ),
        ),
        
        // Right Side: Assistant Bot
        Positioned(
          top: 80,
          right: 20,
          child: FloatingActionButton(
             backgroundColor: Colors.white,
             child: const Icon(Icons.smart_toy, color: Colors.blueAccent),
             onPressed: () => _showAssistantChat(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, {
    required String label, 
    required IconData icon, 
    required Color color,
    required double value, 
    required double min, 
    required double max, 
    required Function(double) onChanged,
    int? divisions,
  }) {
    // No need for StatefulBuilder here since the parent is now stateful 
    // and we want to trigger parent rebuilds or we can keep it local for performance if needed. 
    // actually slider updates game state, but UI needs to reflect it. 
    // Since parent is Stateful, we can use setState there or here.
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            label: value.toStringAsFixed(1),
            onChanged: (v) {
              setState(() {}); // Rebuild to move slider
              onChanged(v);
            },
          ),
        ),
      ],
    );
  }

  void _showAssistantChat(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    String? lastAnswer;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              scrollable: true, // Fix overflow
              backgroundColor: const Color(0xFF003566),
              title: Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.white),
                  const SizedBox(width: 10),
                  Text('المساعد الذكي', style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... content children ...
                  Text(
                    'مرحباً! أنا هنا لمساعدتك في فهم بيئة المحيط.',
                    style: GoogleFonts.tajawal(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  if (lastAnswer != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        lastAnswer!,
                        style: GoogleFonts.tajawal(color: Colors.white),
                      ),
                    ),
                  if (isLoading)
                     const Padding(
                       padding: EdgeInsets.all(10.0),
                       child: Center(child: CircularProgressIndicator()),
                     ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    style: GoogleFonts.tajawal(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اسألني أي سؤال...',
                      hintStyle: GoogleFonts.tajawal(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildPresetChip('لماذا الأسماك بطيئة؟', controller, setDialogState),
                      _buildPresetChip('ما فائدة الأعشاب؟', controller, setDialogState),
                      _buildPresetChip('كيف أنظف المحيط؟', controller, setDialogState),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text('إغلاق', style: GoogleFonts.tajawal(color: Colors.white70)),
                  onPressed: () => Navigator.pop(ctx),
                ),
                ElevatedButton(
                  child: Text('إرسال', style: GoogleFonts.tajawal()),
                  onPressed: () async {
                    final question = controller.text;
                    if (question.isEmpty) return;
                    
                    setDialogState(() { isLoading = true; lastAnswer = null; });
                    
                    final state = {
                      'pollution': widget.game.pollutionLevel,
                      'fishCount': widget.game.targetFishCount,
                      'seaweedCount': widget.game.targetSeaweedCount,
                    };
                    
                    final answer = await _geminiService.getResponse(question, state);
                    
                    if (context.mounted) {
                      setDialogState(() { 
                        isLoading = false; 
                        lastAnswer = answer; 
                        controller.clear(); 
                      });
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  Widget _buildPresetChip(String text, TextEditingController controller, StateSetter setDialogState) {
    return ActionChip(
      label: Text(text, style: GoogleFonts.tajawal(fontSize: 12, color: Colors.black)),
      backgroundColor: Colors.lightBlueAccent,
      onPressed: () {
        setDialogState(() {
          controller.text = text;
        });
      },
    );
  }
}

