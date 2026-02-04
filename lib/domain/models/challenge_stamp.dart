
enum ChallengeType {
  tutorial(
    id: 1,
    title: '冷蔵庫でレシピ提案',
    goal: '冷蔵庫の写真を撮って、おすすめのレシピを表示する',
    guideSteps: [
      'ホーム画面の「冷蔵庫の中身から提案」をタップ',
      '冷蔵庫の中身を撮影する',
      'AIが食材を解析する',
      '提案されたレシピから1つ選ぶ',
      '決定して献立に追加する',
    ],
  ),
  scheduleRecipe(
    id: 2,
    title: '献立の登録',
    goal: 'レシピページから、いつ作るかを決めて、マイレシピ帳に登録する',
    guideSteps: [
      'レシピ詳細ページを開く',
      '画面下の「このレシピを作る！」をタップ',
      '作る日付と時間帯（朝・昼・夕など）を決める',
      '「マイレシピ帳に登録する」をタップ',
    ],
  ),
  searchRecipe(
    id: 3,
    title: 'レシピ検索',
    goal: 'マイレシピ帳で、レシピを検索する',
    guideSteps: [
      '下部メニューの「レシピ帳」をタップ',
      '上部の検索バーをタップ',
      'キーワードを入力するか、レシピサイトのURLを貼り付ける',
      '検索を実行する',
    ],
  ),
  extractIngredients(
    id: 4,
    title: '材料の自動抽出',
    goal: 'レシピページから、材料を抽出する',
    guideSteps: [
      'レシピ詳細ページを開く',
      '右上のメニューまたは画面内の「材料を抽出する」をタップ',
      'AIがレシピの材料リストを自動で作成します',
      '抽出された材料を確認して保存する',
    ],
  ),
  shoppingComplete(
    id: 5,
    title: 'お買い物完了',
    goal: 'お買い物画面の「お買い物モード」でお買い物をする',
    guideSteps: [
      '下部メニューの「お買い物」をタップ',
      '「お買い物を始める」をタップしてモード切替',
      '実際に買ったものをチェックする',
      '「買い物を完了」ボタンをタップ',
    ],
  ),
  scanReceipt(
    id: 6,
    title: 'レシート解析',
    goal: 'お買い物画面の「お買い物モード」で、レシートを撮影して、買ったものを在庫に追加する',
    guideSteps: [
      '下部メニューの「お買い物」をタップ',
      '「お買い物を始める」をタップ',
      '右下の「レシートを撮影して完了」をタップ',
      'レシートを撮影すると、AIが自動で在庫に追加します',
    ],
  ),
  cookAndPhoto(
    id: 7,
    title: '料理の記録',
    goal: '献立計画表の「作った」ボタンを押して、料理を撮影する',
    guideSteps: [
      '下部メニューの「献立」をタップ',
      '作った料理のカードにある「作った」をタップ',
      'カメラが起動するので、料理を撮影する',
      '写真が登録され、スタンプゲット！',
    ],
  );

  final int id;
  final String title;
  final String goal;
  final List<String> guideSteps;

  const ChallengeType({
    required this.id,
    required this.title,
    required this.goal,
    required this.guideSteps,
  });

  // Backward compatibility alias if needed, or just use goal
  String get description => goal;

  static ChallengeType? fromId(int id) {
    try {
      return ChallengeType.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

class ChallengeStamp {
  final ChallengeType type;
  final bool isCompleted;
  final DateTime? completedAt;

  ChallengeStamp({
    required this.type,
    this.isCompleted = false,
    this.completedAt,
  });

  ChallengeStamp copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return ChallengeStamp(
      type: type,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
  
  // For easy JSON serialization if needed, though simple shared_prefs might just store IDs
  Map<String, dynamic> toJson() {
    return {
      'id': type.id,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory ChallengeStamp.fromJson(Map<String, dynamic> json) {
    final type = ChallengeType.fromId(json['id'] as int);
    return ChallengeStamp(
      type: type!,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }
}
