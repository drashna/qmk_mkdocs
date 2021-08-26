# QMK ドキュメントを翻訳する

<!---
  original document: 0.9.51:docs/translating.md
  git diff 0.9.51 HEAD -- docs/translating.md | cat
-->

ルートフォルダ (`docs/`) にある全てのファイルは英語でなければなりません - 他の全ての言語は、ISO 639-1 言語コードと、それに続く`-`と関連する国コードのサブフォルダにある必要があります。[一般的なもののリストはここで見つかります](https://www.andiamo.co.uk/resources/iso-language-codes/)。このフォルダが存在しない場合、作成することができます。翻訳された各ファイルは英語バージョンと同じ名前でなければなりません。そうすることで、正常にフォールバックできます。

`_summary.md` ファイルはこのフォルダの中に存在し、各ファイルへのリンクのリスト、翻訳された名前、言語フォルダに続くリンクが含まれている必要があります。

```markdown
 * [QMK简介](zh-cn/getting_started_introduction.md)
```

他の docs ページへの全てのリンクにも、言語のフォルダが前に付いている必要があります。もしリンクがページの特定の部分(例えば、特定の見出し)への場合、以下のように見出しに英語の ID を使う必要があります:

```markdown
[建立你的环境](zh-cn/tutorial-getting-started.md#set-up-your-environment)

## 建立你的环境 {: id=set-up-your-environment }
```

新しい言語の翻訳が完了したら、以下のファイルも修正する必要があります:

<!-- FIXME(skullydazed/anyone): redo this for mkdocs -->

## 翻訳のプレビュー

ドキュメントのローカルインスタンスをセットアップする方法については、[ドキュメントのプレビュー](contributing.md#previewing-the-documentation)を見てください - 右上の "Translations" メニューから新しい言語を選択することができるはずです。

作業に満足したら、遠慮なくプルリクエストを開いてください！
