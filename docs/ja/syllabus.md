# QMK シラバス

<!---
  original document: 0.14.22:docs/syllabus.md
  git diff 0.14.22 HEAD -- docs/syllabus.md | cat
-->

このページは最初に基本を紹介し、そして、QMK に習熟するために必要な全ての概念を理解するように導くことで、QMK の知識を構築するのに役立ちます。

# 初級トピック

他に何も読んでいない場合は、このセクションのドキュメントを読んでください。[QMK 初心者ガイド](newbs.md)を読み終わると、基本的なキーマップを作成し、それをコンパイルし、キーボードに書き込みできるようになっているはずです。残りのドキュメントはこれらの基本的な知識を具体的に肉付けします。

* **QMK Tools の使い方を学ぶ**
   * [QMK 初心者ガイド](newbs.md)
   * [CLI](cli.md)
   * [Git](newbs_git_best_practices.md)
* **キーマップについて学ぶ**
   * [レイヤー](feature_layers.md)
   * [キーコード](keycodes.md)
      * 使用できるキーコードの完全なリスト。中級または上級トピックにある知識が必要な場合もあることに注意してください。
* **IDE の設定** - オプション
   * [Eclipse](other_eclipse.md)
   * [VS Code](other_vscode.md)

# 中級トピック

これらのトピックでは、QMK がサポートする幾つかの機能について掘り下げます。これらのドキュメントを全て読む必要はありませんが、これらの一部をスキップすると、上級トピックのセクションの一部のドキュメントが意味をなさなくなるかもしれません。

* **機能の設定方法を学ぶ**
   <!-- * Configuration Overview  FIXME(skullydazed/anyone): write this document -->
   * [オーディオ](feature_audio.md)
   * 電飾
      * [バックライト](feature_backlight.md)
      * [LED マトリックス](feature_led_matrix.md)
      * [RGB ライト](feature_rgblight.md)
      * [RGB マトリックス](feature_rgb_matrix.md)
   * [タップホールド設定](tap_hold.md)
* **キーマップについてさらに学ぶ**
   * [キーマップ](keymap.md)
   * [カスタム関数とキーコード](custom_quantum_functions.md)
   * マクロ
      * [動的マクロ](feature_dynamic_macros.md)
      * [コンパイル済みのマクロ](feature_macros.md)
   * [タップダンス](feature_tap_dance.md)
   * [コンボ](feature_combo.md)
   * [ユーザスペース](feature_userspace.md)
   * [キーオーバーライド](feature_key_overrides.md)

# 上級トピック

以下の全ては多くの基礎知識を必要とします。高度な機能を使ってキーマップを作成できることに加えて、`config.h` と `rules.mk` の両方を使ってキーボードのオプションを設定することに慣れている必要があります。

* **QMK 内のキーボードの保守**
   * [キーボードの手配線](hand_wire.md)
   * [キーボードガイドライン](hardware_keyboard_guidelines.md)
   * [info.json リファレンス](reference_info_json.md)
   * [デバウンス API](feature_debounce_type.md)
* **高度な機能**
   * [ユニコード](feature_unicode.md)
   * [API](api_overview.md)
   * [ブートマジックライト](feature_bootmagic.md)
* **ハードウェア**
   * [キーボードがどのように動作するか](how_keyboards_work.md)
   * [キーボードマトリックスの仕組み](how_a_matrix_works.md)
   * [分割キーボード](feature_split_keyboard.md)
   * [速記](feature_stenography.md)
   * [ポインティングデバイス](feature_pointing_device.md)
* **コア開発**
   * [コーディング規約](coding_conventions_c.md)
   * [互換性のあるマイクロコントローラ](compatible_microcontrollers.md)
   * [カスタムマトリックス](custom_matrix.md)
   * [QMK を理解する](understanding_qmk.md)
* **CLI 開発**
   * [コーディング規約](coding_conventions_python.md)
   * [CLI 開発の概要](cli_development.md)
