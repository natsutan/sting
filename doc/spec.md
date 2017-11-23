2次元コンボリューションアクセラレータ Sting仕様書
=====

# 概要
本仕様書はFPGA向け、Deep Learningで使用する2次元コンボリューションアクセラレータ Sting について記載した物である。
StingはZynq上で動作し、Deep Learningのコンボリューションと、それに続くLeakyRELU、Batch Normalizationの処理を行う。
Stingを使うことで、ARM CPU単体で実行するよりも高速にコンボリューションの計算を実行できる。

# 機能

Stingはレイヤーの計算を実行できる。

- 2次元コンボリューション
- LeakyRELU
- Batch Normalization

Zynqで使用するIPコアとしては以下の機能を持つ。
- AXI_HP 1port 入力データリード用
- AXI_GP 2port レジスタR/W用、重みデータリード用
- AXI_ACP 1port 出力データR/W用
- 割り込み信号 1本
- リセット 1本
- CLK 1本

# ブロック図
Sitngのブロック図を以下に示す。

<img src="blk.png">

各ブロックは以下の機能を持つ。  
ブロック名|サブブロック名|機能|
*----|----|----|
STING\_TOP| - | TOP階層 |
CC2\_REG\_IF| - | レジスタI/F|
CC2\_CONTROL|- | 全体制御|
|CC2\_INTC| 割り込み|
CC2\_AXI\_RD\_INPUT |-|入力データのリード|
CC2\_AXI\_RD\_WEIGHT |-|重みデータのリード|
CC2\_AXI\_RW\_OUTPUT |-|出力データのR/W |
CC2\_DSP3x3 |-|　3x3のフィルター計算|
CC2\_CONV | - | コンボリューションの実行|
| CC2\_BIAS | BIAS項の加算|
| CC2\_BN |　バッチノーマライゼーションの計算 |
| CC2\_LRERU | LeakyRELUの計算 |

各ブロックの詳細はブロック仕様にて記載する。

# 動作説明

# ブロック仕様

# レジスタ一覧
