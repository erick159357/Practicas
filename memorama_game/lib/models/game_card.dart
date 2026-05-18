class GameCard {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;
  
  GameCard({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });
  
  GameCard copyWith({
    int? id,
    String? emoji,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return GameCard(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GameCard &&
        other.id == id &&
        other.emoji == emoji;
  }
  
  @override
  int get hashCode => id.hashCode ^ emoji.hashCode;
}