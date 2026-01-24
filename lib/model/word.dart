// クラス実装


class Word {
  final String word;
  String translation;
  int learnedCount;
  int? id;

  Word(this.word, {this.translation = "", this.learnedCount=1, this.id}); 

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      map['word'] as String,
      translation: map['translation'] as String,
      learnedCount: map['learnedCount'] as int,
      id: map['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'learnedCount': learnedCount,
      'id': id
    };
  }

  Word copyWith({String? word, String? translation, int? learnedCount, int? id}) {
    return Word(
      word ?? this.word,
      translation: translation ?? this.translation,
      learnedCount: learnedCount ?? this.learnedCount,
      id: id ?? this.id
    );
  }
}