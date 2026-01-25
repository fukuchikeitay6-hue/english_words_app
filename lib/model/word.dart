// クラス実装


class Word {
  final String word;
  String translation;
  int learnedCount;
  int? id;
  final DateTime createdAt;

  Word(
    this.word, {
    this.translation = "", 
    this.learnedCount=1, 
    this.id, DateTime? createdAt
  }) : createdAt = createdAt ?? DateTime.now(); 

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      map['word'] as String,
      translation: map['translation'] as String,
      learnedCount: map['learnedCount'] as int,
      id: map['id'] as int?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'learnedCount': learnedCount,
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Word copyWith({
    String? word, 
    String? translation, 
    int? learnedCount, 
    int? id, 
    DateTime? createdAt
  }) {
    return Word(
      word ?? this.word,
      translation: translation ?? this.translation,
      learnedCount: learnedCount ?? this.learnedCount,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt
    );
  }
}