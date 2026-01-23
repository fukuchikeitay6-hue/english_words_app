// クラス実装

class Person {
  int? id;
  final String name;
  int age;

  Person({required this.name, required this.age});

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String, 
      age: map['age'] as int
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }
}

class Word {
  final String word;
  String translation;
  int? id;

  Word(this.word, {this.translation = "", this.id}); 

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      map['word'] as String,
      translation: map['translation'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation
    };
  }
}