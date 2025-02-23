# レイヤー {: id=layers }

<!---
  original document: 0.12.41:docs/feature_layers.md
  git diff 0.12.41 HEAD -- docs/feature_layers.md | cat
-->

QMK ファームウェアの最も強力で良く使われている機能の一つは、レイヤーを使う機能です。ほとんどの人にとって、これはラップトップやタブレットキーボードにあるのと同じように、様々なキーを可能にするファンクションキーに相当します。

レイヤースタックがどのように動作するかの詳細な説明については、[キーマップの概要](keymap.md#keymap-and-layers)を調べてください。

## レイヤーの切り替えとトグル {: id=switching-and-toggling-layers }

以下の関数により、様々な方法でレイヤーをアクティブにすることができます。レイヤーは通常、独立したレイアウトでは無いことに注意してください -- 複数のレイヤーを一度にアクティブにすることができ、レイヤーが `KC_TRNS` を使ってキーの押下を下のレイヤーへと透過させることが一般的です。MO()、LM()、TT() あるいは LT() を使って一時的なレイヤーの切り替えを使う場合、上のレイヤーのキーを透過にするようにしてください。さもないと意図したように動作しないかもしれません。

* `DF(layer)` - デフォルトレイヤーを切り替えます。デフォルトレイヤーは、他のレイヤーがその上に積み重なっている、常にアクティブな基本レイヤーです。デフォルトレイヤーの詳細については以下を見てください。これは QWERTY から Dvorak レイアウトに切り替えるために使うことができます。(これは一時的な切り替えであり、キーボードの電源が切れるまでしか持続しないことに注意してください。デフォルトレイヤーを永続的に変更するには、[process_record_user](custom_quantum_functions.md#programming-the-behavior-of-any-keycode) 内で `set_single_persistent_default_layer` 関数を呼び出すなど、より深いカスタマイズが必要です。)
* `MO(layer)` - 一時的に*レイヤー*をアクティブにします。キーを放すとすぐに、レイヤーは非アクティブになります。
* `LM(layer, mod)` - (`MO` のように)一時的に*レイヤー*をアクティブにしますが、モディファイア *mod* がアクティブな状態です。layer 0-15 と、左モディファイアのみをサポートします: `MOD_LCTL`、`MOD_LSFT`、`MOD_LALT`、`MOD_LGUI` (`KC_` 定数の代わりに `MOD_` 定数を使うことに注意してください)。これらのモディファイアは、例えば `LM(_RAISE, MOD_LCTL | MOD_LALT)` のように、ビット単位の OR を使って組み合わせることができます。
* `LT(layer, kc)` - ホールドされた時に*レイヤー*を一時的にアクティブにし、タップされた時に *kc* を送信します。layer 0-15 のみをサポートします。
* `OSL(layer)` - 次のキーが押されるまで、一時的に*レイヤー*をアクティブにします。詳細と追加機能については、[ワンショットキー](one_shot_keys.md)を見てください。
* `TG(layer)` - *レイヤー*を切り替えます。非アクティブな場合はアクティブにし、逆も同様です。
* `TO(layer)` - *レイヤー*をアクティブにし、他の全てのレイヤー(デフォルトレイヤーを除く)を非アクティブにします。この関数は特別です。1つのレイヤーをアクティブなレイヤースタックに追加/削除する代わりに、現在のアクティブなレイヤーを完全に置き換え、唯一上位のレイヤーを下位のレイヤーで置き換えることができるからです。これはキーダウンで(キーが押されるとすぐに)アクティブになります。
* `TT(layer)` - レイヤーのタップ切り替え。キーを押したままにすると*レイヤー*がアクティブにされ、放すと非アクティブになります (`MO` 風)。繰り返しタップすると、レイヤーはオンあるいはオフを切り替えます (`TG` 風)。デフォルトでは5回のタップが必要ですが、`TAPPING_TOGGLE` を定義することで変更することができます -- 例えば、2回のタップだけで切り替えるには、`#define TAPPING_TOGGLE 2` を定義します。

### 注意事項 {: id=caveats }

現在のところ、`LT()` の `layer` 引数はレイヤー 0-15 に制限され、`kc` 引数は[基本的なキーコードセット](keycodes_basic.md)に制限されています。つまり、`LCTL()`、`KC_TILD` あるいは `0xFF` より大きなキーコードを使うことができません。これは、QMK が16ビットのキーコードを使うためです。4ビットは機能の識別のために使われ、4ビットはレイヤーのために使われ、キーコードには8ビットしか残されていません。

これを拡張してもせいぜい複雑になるだけでしょう。32ビットキーコードに移行すると、これの多くが解決されますが、キーマップマトリックスが使用する領域が2倍になります。また、問題が起きる可能性もあります。タップしたキーコードにモディファイアを適用する必要がある場合は、[タップダンス](feature_tap_dance.md#example-5-using-tap-dance-for-advanced-mod-tap-and-layer-tap-keys)を使うことができます。

## レイヤーとの連携 {: id=working-with-layers }

レイヤーを切り替える時は注意してください。(キーボードを取り外さずに)そのレイヤーを非アクティブにすることができずレイヤーから移動できなくなる可能性があります。最も一般的な問題を避けるためのガイドラインを作成しました。

### 初心者 {: id=beginners }

QMK を使い始めたばかりの場合は、全てを単純にしたいでしょう。レイヤーをセットアップする時は、これらのガイドラインに従ってください:

* デフォルトの "base" レイヤーとして、layer 0 をセットアップします。これは通常の入力レイヤーであり、任意のレイアウト (qwerty、dvorak、colemak など)にすることができます。通常はキーボードのキーのほとんどまたは全てが定義されているため、これを最下位のレイヤーとして設定することが重要です。そうすることで、もしそれが他のレイヤーの上 (つまりレイヤー番号が大きい)にある場合の影響を防ぎます。
* layer 0 をルートとして、レイヤーを "ツリー" レイアウトに配置します。他の複数のレイヤーから同じレイヤーに行こうとしないでください。
* 各レイヤーのキーマップでは、より高い番号のレイヤーのみを参照します。レイヤーは最大の番号(最上位)のアクティブレイヤーから処理されるため、下位レイヤーの状態を変更するのは難しくエラーが発生しやすくなります。

### 中級ユーザ {: id=intermediate-users }

複数の基本レイヤーが必要な場合があります。例えば、QWERTY と Dvorak を切り替える場合、国ごとに異なるレイアウトを切り替える場合、あるいは異なるビデオゲームごとにレイアウトを切り替える場合などです。基本レイヤーは常に最小の番号のレイヤーである必要があります。複数の基本レイヤーがある場合、常にそれらを相互排他的に扱う必要があります。1つの基本レイヤーがオンの場合、他をオフにします。

### 上級ユーザ {: id=advanced-users }

レイヤーがどのように動作し、何ができるかを理解したら、より創造的になります。初心者のセクションで列挙されている規則は、幾つかの巧妙な詳細を回避するのに役立ちますが、特に超コンパクトなキーボードのユーザにとって制約になる場合があります。レイヤーの仕組みを理解することで、レイヤーをより高度な方法で使うことができます。

レイヤーは番号順に上に積み重なっています。キーの押下の動作を決定する時に、QMK は上から順にレイヤーを走査し、`KC_TRNS` に設定されていない最初のアクティブなレイヤーに到達すると停止します。結果として、現在のレイヤーよりも数値的に低いレイヤーをアクティブにし、現在のレイヤー(あるいはアクティブでターゲットレイヤーよりも高い別のレイヤー)に `KC_TRNS` 以外のものがある場合、それが送信されるキーであり、アクティブ化したばかりのレイヤー上のキーではありません。これが、ほとんどの人の "なぜレイヤーが切り替わらないのか" 問題の原因です。

場合によっては、マクロ内あるいはタップダンスルーチンの一部としてレイヤーを切り替えほうが良いかもしれません。`layer_on` はレイヤーをアクティブにし、`layer_off` はそれを非アクティブにします。もっと多くのレイヤーに関する関数は、[action_layer.h](https://github.com/qmk/qmk_firmware/blob/master/quantum/action_layer.h) で見つけることができます。

## 関数 {: id=functions }

レイヤーの使用あるいは操作に関係する多くの関数(と変数)があります。

| 関数                                         | 説明                                                                                                       |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `layer_state_set(layer_mask)`                | 直接レイヤーの状態を設定する (推奨。何をしているのか分かっていない場合は使わないでください)。              |
| `layer_clear()`                              | 全てのレイヤーを消去する (全てをオフにします)。                                                            |
| `layer_move(layer)`                          | 指定されたレイヤーをオンにし、それ以外をオフにする。                                                       |
| `layer_on(layer)`                            | 指定されたレイヤーをオンにし、それ以外を既存の状態のままにする。                                           |
| `layer_off(layer)`                           | 指定されたレイヤーをオフにし、それ以外を既存の状態のままにする。                                           |
| `layer_invert(layer)`                        | 指定されたレイヤーの状態を反転/トグルする。                                                                |
| `layer_or(layer_mask)`                       | 指定されたレイヤーと既存のレイヤー状態の間で一致するビットに基づいてレイヤーをオンにする。                 |
| `layer_and(layer_mask)`                      | 指定されたレイヤーと既存のレイヤー状態の間で有効なビットに基づいてレイヤーをオンにする。                   |
| `layer_xor(layer_mask)`                      | 指定されたレイヤーと既存のレイヤー状態の間で一致しないビットに基づいてレイヤーをオンにする。               |
| `layer_debug(layer_mask)`                    | デバッガのコンソールに現在のビットマスクと最も高いレイヤーを出力する。                                     |
| `default_layer_set(layer_mask)`              | 直接デフォルトレイヤーの状態を設定する (推奨。何をしているのか分かっていない場合は使わないでください)。    |
| `default_layer_or(layer_mask)`               | 指定されたレイヤーと既存のデフォルトレイヤー状態の間で一致するビットに基づいてレイヤーをオンにする。       |
| `default_layer_and(layer_mask)`              | 指定されたレイヤーと既存のデフォルトレイヤー状態の間で一致する有効なビットに基づいてレイヤーをオンにする。 |
| `default_layer_xor(layer_mask)`              | 指定されたレイヤーと既存のデフォルトレイヤー状態の間で一致しないビットに基づいてレイヤーをオンにする。     |
| `default_layer_debug(layer_mask)`            | デバッガのコンソールに現在のビットマスクと最も高いアクティブなレイヤーを出力する。                         |
| [`set_single_persistent_default_layer(layer)`](ref_functions.md#setting-the-persistent-default-layer) | デフォルトレイヤーを設定し、それを永続化メモリ (EEPROM) に書き込む。                                                      |
| [`update_tri_layer(x, y, z)`](ref_functions.md#update_tri_layerx-y-z)                                 | レイヤー `x` と `y` の両方がオンであるかを調べ、それに基づいて `z` を設定する(両方がオンの場合オン、そうでなければオフ)。 |
| [`update_tri_layer_state(state, x, y, z)`](ref_functions.md#update_tri_layer_statestate-x-y-z)        | `update_tri_layer(x, y, z)` と同じことをするが、`layer_state_set_*` 関数から呼ばれる。                                    |


呼び出すことができる関数に加えて、レイヤーが変更されるたびに呼び出されるコールバック関数が幾つかあります。これはレイヤー状態を関数に渡し、読み取りや変更することができます。

| コールバック                                        | 説明                                                                                             |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `layer_state_set_kb(layer_state_t state)`           | キーボードレベルのレイヤー関数のためのコールバック。                                             |
| `layer_state_set_user(layer_state_t state)`         | ユーザレベルのレイヤー関数のためのコールバック。                                                 |
| `default_layer_state_set_kb(layer_state_t state)`   | キーボードレベルのデフォルトレイヤー関数のためのコールバック。キーボードの初期化時に呼ばれます。 |
| `default_layer_state_set_user(layer_state_t state)` | ユーザレベルのデフォルトレイヤー関数のためのコールバック。キーボードの初期化時に呼ばれます。     |

!!! tip
    これらのコールバックを使うための追加の情報については、[レイヤー変換コード](custom_quantum_functions.md#layer-change-code)のドキュメントを調べてください。

次の関数やマクロを使って、特定のレイヤーの状態を確認することもできます。

| 関数                            | 説明                                                                                                          | 別名                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `layer_state_is(layer)`         | 指定された `layer` がグローバルに有効かどうかを確認する。                                                     | `IS_LAYER_ON(layer)`, `IS_LAYER_OFF(layer)`                           |
| `layer_state_cmp(state, layer)` | `state` を確認して指定された `layer` が有効かどうかを確認する。レイヤーのコールバックで使うことを目的とする。 | `IS_LAYER_ON_STATE(state, layer)`, `IS_LAYER_OFF_STATE(state, layer)` |
