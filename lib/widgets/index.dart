// 📄 lib/widgets/index.dart
//
// Widgets barrel — top-level exports for the widgets layer.
// ------------------------------------------------------------
// • Re-exports feature barrels (app, home, play, grownups, etc.)
// • Exposes shared, cross-feature widgets that live at root.
//

// Feature barrels
export 'app/index.dart';
export 'common/index.dart';
export 'game_over/index.dart';
export 'grownups/index.dart';
export 'home/index.dart';
export 'play/index.dart';
export 'progress/index.dart';
export 'settings/index.dart';
export 'splash/index.dart';

// Root-level shared widgets
export 'animated_sentence_text.dart';
export 'audio_trigger.dart';
export 'card_cell.dart';
export 'grid_layout_helper.dart';
export 'play_audio_manager.dart';
export 'sentence/sentence_content.dart';
export 'sentence_audio_widget.dart';
export 'sentence_carousel.dart';
export 'sentence_header.dart';
export 'sparkle_layer.dart';
export 'trophy_chip.dart';
export 'word_audio_trigger.dart';
export 'words/word_bank_content.dart';