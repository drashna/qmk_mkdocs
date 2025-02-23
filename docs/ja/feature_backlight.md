# バックライト {: id=backlighting }

<!---
  original document: 0.14.14:docs/feature_backlight.md
  git diff 0.14.14 HEAD -- docs/feature_backlight.md | cat
-->

多くのキーボードは、キースイッチを貫通して配置されたり、キースイッチの下に配置された個々の LED によって、バックライトキーをサポートします。この機能は通常スイッチごとに単一の色しか使用できないため、[RGB アンダーグロー](feature_rgblight.md)および [RGB マトリックス](feature_rgb_matrix.md)機能のどちらとも異なりますが、キーボードに複数の異なる単一色の LED を取り付けることは当然可能です。

QMK は *パルス幅変調* (*Pulse Width Modulation*) すなわち PWM として知られている技術で、一定の比率で素早くオンおよびオフを切り替えることで、これらの LED の輝度を制御できます。PWM 信号のデューティサイクルを変えることで、調光の錯覚を起こすことができます。

MCU は、GPIO ピンにはそんなに電流を供給できません。MCU から直接バックライトに給電せずに、バックライトピンは LED への電力を切り替えるトランジスタあるいは MOSFET に接続されます。

ほとんどのキーボードではバックライトをサポートしている場合にデフォルトで有効になっていますが、もし機能しない場合は `rules.mk` が以下を含んでいることを確認してください:

```makefile
BACKLIGHT_ENABLE = yes
```

## キーコード {: id=keycodes }

有効にすると、以下のキーコードを使ってバックライトレベルを変更することができます。

| キー      | 説明                                 |
| --------- | ------------------------------------ |
| `BL_TOGG` | バックライトをオンあるいはオフにする |
| `BL_STEP` | バックライトレベルを循環する         |
| `BL_ON`   | バックライトを最大輝度に設定する     |
| `BL_OFF`  | バックライトをオフにする             |
| `BL_INC`  | バックライトレベルを上げる           |
| `BL_DEC`  | バックライトレベルを下げる           |
| `BL_BRTG` | バックライトの明滅動作を切り替える   |

## 関数群 {: id=functions }

次の関数を使って、カスタムコードでバックライトを変更することができます:

| 関数                     | 説明                                         |
| ------------------------ | -------------------------------------------- |
| `backlight_toggle()`     | バックライトをオンあるいはオフにする         |
| `backlight_enable()`     | バックライトをオンにする                     |
| `backlight_disable()`    | バックライトをオフにする                     |
| `backlight_step()`       | バックライトレベルを循環する                 |
| `backlight_increase()`   | バックライトレベルを上げる                   |
| `backlight_decrease()`   | バックライトレベルを下げる                   |
| `backlight_level(x)`     | バックライトのレベルを特定のレベルに設定する |
| `get_backlight_level()`  | 現在のバックライトレベルを返す               |
| `is_backlight_enabled()` | バックライトが現在オンかどうかを返す         |

バックライトの明滅が有効の場合(以下を参照)、以下の関数も利用できます:

| 関数                  | 説明                                         |
|-----------------------|----------------------------------------------|
| `breathing_toggle()`  | バックライトの明滅動作をオンまたはオフにする |
| `breathing_enable()`  | バックライトの明滅動作をオンにする           |
| `breathing_disable()` | バックライトの明滅動作をオフにする           |

## 設定 {: id=configuration }

どのドライバを使うかを選択するには、以下を使って `rules.mk` を設定します:

```makefile
BACKLIGHT_DRIVER = software
```

有効なドライバの値は `pwm`, `software`, `custom`, `no` です。各ドライバについてのヘルプは以下を見てください。

バックライトを設定するには、`config.h` の中で以下の `#define` をします:

| 定義                          | デフォルト         | 説明                                                                                          |
| ----------------------------- | ------------------ | --------------------------------------------------------------------------------------------- |
| `BACKLIGHT_PIN`               | *定義なし*         | LED を制御するピン                                                                            |
| `BACKLIGHT_LEVELS`            | `3`                | 輝度のレベルの数 (オフを除いて最大 31)                                                        |
| `BACKLIGHT_CAPS_LOCK`         | *定義なし*         | バックライトを使って Caps Lock のインジケータを有効にする (専用 LED の無いキーボードのため)   |
| `BACKLIGHT_BREATHING`         | *定義なし*         | サポートされる場合は、バックライトの明滅動作を有効にする                                      |
| `BREATHING_PERIOD`            | `6`                | 各バックライトの "明滅" の長さ（秒）                                                          |
| `BACKLIGHT_ON_STATE`          | `1`                | バックライトが "オン" の時のバックライトピンの状態 - high の場合は `1`、low の場合は `0`      |
| `BACKLIGHT_LIMIT_VAL`         | `255`              | バックライトの最大デューティサイクル -- `255` で最大輝度になり、それ未満では最大値が減少する  |
| `BACKLIGHT_DEFAULT_LEVEL`     | `BACKLIGHT_LEVELS` | EEPROM をクリアする時に使うデフォルトのバックライトレベル                                     |
| `BACKLIGHT_DEFAULT_BREATHING` | *定義なし*         | EEPROM をクリアする時に、バックライトのブリージングを有効にするかどうか                       |

独自のキーボードを設計しているわけではない限り、通常は `BACKLIGHT_PIN` または `BACKLIGHT_ON_STATE` を変更する必要はありません。

### バックライトオン状態 {: id=backlight-on-state }

ほとんどのバックライトの回路は N チャンネルの MOSFET あるいは NPN トランジスタによって駆動されます。これは、トランジスタを *オン* にして LED を点灯させるには、ゲートまたはベースに接続されているバックライトピンを *high* に駆動する必要があることを意味します。
ただし、P チャンネルの MOSFET あるいは PNP トランジスタが使われる場合があります。この場合、トランジスタがオンの時、ピンは代わりに *low* で駆動されます。

この機能は `BACKLIGHT_ON_STATE` を定義することでキーボードレベルで設定されます。

### AVR ドライバ {: id=avr-driver }

`pwm` ドライバはデフォルトで設定されますが、`rules.mk` 内での同等の設定は以下の通りです:

```makefile
BACKLIGHT_DRIVER = pwm
```

#### 注意事項 {: id=avr-caveats }

AVR ボードでは、QMK はどのドライバを使うかを以下の表に従って自動的に決定します:

| バックライトピン | AT90USB64/128 | AT90USB162 | ATmega16/32U4 | ATmega16/32U2 | ATmega32A | ATmega328/P |
| ---------------- | ------------- | ---------- | ------------- | ------------- | --------- | ----------- |
| `B1`             |               |            |               |               |           | Timer 1     |
| `B2`             |               |            |               |               |           | Timer 1     |
| `B5`             | Timer 1       |            | Timer 1       |               |           |             |
| `B6`             | Timer 1       |            | Timer 1       |               |           |             |
| `B7`             | Timer 1       | Timer 1    | Timer 1       | Timer 1       |           |             |
| `C4`             | Timer 3       |            |               |               |           |             |
| `C5`             | Timer 3       | Timer 1    |               | Timer 1       |           |             |
| `C6`             | Timer 3       | Timer 1    | Timer 3       | Timer 1       |           |             |
| `D4`             |               |            |               |               | Timer 1   |             |
| `D5`             |               |            |               |               | Timer 1   |             |

他の全てのピンはタイマー支援ソフトウェア PWM を使います。

| オーディオピン | オーディオタイマ | ソフトウェア PWM タイマ |
| -------------- | ---------------- | ----------------------- |
| `C4`           | Timer 3          | Timer 1                 |
| `C5`           | Timer 3          | Timer 1                 |
| `C6`           | Timer 3          | Timer 1                 |
| `B5`           | Timer 1          | Timer 3                 |
| `B6`           | Timer 1          | Timer 3                 |
| `B7`           | Timer 1          | Timer 3                 |

両方のタイマーがオーディオのために使われている場合、バックライト PWM はハードウェアタイマを使うことができず、代わりにマトリックススキャンの間に引き起こされます。この場合、PWM の計算は十分なタイミングの精度で呼ばれない可能性があるため、バックライトの明滅はサポートされず、バックライトもちらつくかもしれません。

#### ハードウェア PWM 実装 {: id=hardware-pwm-implementation }

バックライト用にサポートされているピンを使う場合、QMK は PWM 信号を出力するように設定されたハードウェアタイマを使います。タイマーは 0 にリセットする前に `ICRx` (デフォルトでは `0xFFFF`) までカウントします。
希望の輝度が計算され、`OCRxx` レジスタに格納されます。カウンタがこの値まで達すると、バックライトピンは low になり、カウンタがリセットされると再び high になります。
このように `OCRxx` は基本的に LED のデューティサイクル、従って輝度を制御します。`0x0000` は完全にオフで、 `0xFFFF` は完全にオンです。

明滅動作の効果はカウンタがリセットされる(秒間あたりおよそ244回)たびに呼び出される `TIMER1_OVF_vect` の割り込みハンドラを登録することで可能になります。
このハンドラで、増分カウンタの値が事前に計算された輝度曲線にマップされます。明滅動作をオフにするには、割り込みを単純に禁止し、輝度を EEPROM に格納されているレベルに再設定します。

#### タイマー支援 PWM 実装 {: id=timer-assisted-implementation }

`BACKLIGHT_PIN` がハードウェアバックライトピンに設定されていない場合、QMK はソフトウェア割り込みを引き起こすように設定されているハードウェアタイマを使います。タイマーは 0 にリセットする前に `ICRx` (デフォルトでは `0xFFFF`) までカウントします。
0 に再設定すると、CPU は LED をオンにする OVF (オーバーフロー)割り込みを発火し、デューティサイクルを開始します。
希望の輝度が計算され、`OCRxx` レジスタに格納されます。カウンタがこの値に達すると、CPU は比較出力一致割り込みを発火し、LED をオフにします。
このように `OCRxx` は基本的に LED のデューティサイクル、従って輝度を制御します。 `0x0000` は完全にオフで、 `0xFFFF` は完全にオンです。

明滅の効果はハードウェア PWM 実装と同じです。

### ARM ドライバ {: id=arm-configuration }

まだ初期段階ですが、ARM バックライトサポートは最終的に AVR と同等の機能を持つことを目指しています。`pwm` ドライバはデフォルトで設定されますが、`rules.mk` 内での同等の設定は以下の通りです:

```makefile
BACKLIGHT_DRIVER = pwm
```

#### ChibiOS の設定 {: id=arm-configuration }

以下の `#define` は ARM ベースのキーボードにのみ適用されます:

| 定義                    | デフォルト | 説明                    |
| ----------------------- | ---------- | ----------------------- |
| `BACKLIGHT_PWM_DRIVER`  | `PWMD4`    | 使用する PWM ドライバ   |
| `BACKLIGHT_PWM_CHANNEL` | `3`        | 使用する PWM チャンネル |
| `BACKLIGHT_PAL_MODE`    | `2`        | 使用するピン代替関数    |

これらの値を決定するには、特定の MCU の ST データシートを参照してください。独自のキーボードを設計しているわけではない場合、通常はこれらを変更する必要はありません。

#### 注意事項 {: id=arm-caveats }

現在のところ、ハードウェア PWM のみがサポートされ、タイマー支援はなく、自動設定は提供されません。

### ソフトウェア PWM ドライバ {: id=software-pwm-driver }

このモードでは、他のキーボードのタスクを実行中に PWM は「エミュレート」されます。追加のプラットフォーム設定なしで最大のハードウェア互換性を提供します。トレードオフは、キーボードが忙しい時にバックライトが揺れる可能性があることです。有効にするには、`rules.mk` に以下を追加します:

```makefile
BACKLIGHT_DRIVER = software
```

#### 複数のバックライトピン {: id=multiple-backlight-pins }

ほとんどのキーボードは、全てのバックライト LED を制御するたった1つのバックライトピンを持ちます (特にバックライトがハードウェア PWM ピンに接続されている場合)。
ソフトウェア PWM では、複数のバックライトピンを定義することができます。これらのピンは PWM デューティサイクル時に同時にオンおよびオフになります。

この機能により、例えば Caps Lock LED (またはその他の制御可能な LED) の輝度を、バックライトの他の LED と同じレベルに設定することができます。Caps Lock LED は通常バックライトとは別のピンに配線されるため、Caps Lock の代わりに Control をマップしていて、Caps Lock がオンの時に Caps Lock LED ではなくバックライトの一部をアクティブにする必要がある場合に便利です。

複数のバックライトピンをアクティブにするには、`config.h` に `BACKLIGHT_PIN` の代わりに次のようなものを追加します:

```c
#define BACKLIGHT_PINS { F5, B2 }
```

### カスタムドライバ {: id=custom-driver }

上記ドライバのいずれもキーボードに適用されていない場合(例えば、バックライトを制御するのに別の IC を使用している場合)、QMK が提供しているこの簡単な API を使ってカスタムバックライトドライバを実装することができます。有効にするには、`rules.mk` に以下を追加します:

```makefile
BACKLIGHT_DRIVER = custom
```

それから次のフックのいずれかを実装します:

```c
void backlight_init_ports(void) {
    // オプション - 起動時に実行されます
    //   通常、ここでピンを設定します
}
void backlight_set(uint8_t level) {
    // オプション - レベルの変更時に実行されます
    //   通常、ここで新しい値に応答します
}

void backlight_task(void) {
    // オプション - 定期的に実行されます
    //   これはメインキーボードループで呼び出されることに注意してください
    //   そのため、ここで長時間実行されるアクションはパフォーマンスの問題を引き起こします
}
```

## 回路図の例

この一般的な例では、バックライト LED は全て N チャンネル MOSFET に向かって並列に接続されています。そのゲートピンは、リンギングを回避するため 470Ωの抵抗を介してマイクロコントローラの GPIO ピンの1つに接続されています。
プルダウン抵抗もゲートピンとグランドの間に配置されており、MCU によって駆動されていない場合にプルダウン抵抗を定義された状態に保ちます。
これらの抵抗値は重要ではありません。詳細については、[this Electronics StackExchange question](https://electronics.stackexchange.com/q/68748) を参照してください。

![バックライトの回路例](https://i.imgur.com/BmAvoUC.png)
