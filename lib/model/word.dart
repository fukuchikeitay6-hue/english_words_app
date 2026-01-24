// クラス実装


class Word {
  final String word;
  String translation;
  int? id;

  Word(this.word, {this.translation = "", this.id}); 

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      map['word'] as String,
      translation: map['translation'] as String,
      id: map['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation
    };
  }
}