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

入力データのx方向の最大サイズは512、y方向は分割機能を使うことで無制限。入力チャネル数、フィルター数（出力チャネル数）の最大は2048。

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

| ブロック名|サブブロック名|機能|
|:----|:----|:----|
| STING\_TOP| - | TOP階層 |
| CC2\_REG\_IF| - | レジスタI/F|
| CC2\_CONTROL|- | 全体制御|
| |CC2\_INTC| 割り込み|
| CC2\_AXI\_RD\_INPUT |-|入力データのリード|
| CC2\_AXI\_RD\_WEIGHT |-|重みデータのリード|
| CC2\_AXI\_RW\_OUTPUT |-|出力データのR/W |
| CC2\_DSP3x3 |-|　3x3のフィルター計算|
| CC2\_CONV | - | コンボリューションの実行|
|| CC2\_BIAS | BIAS項の加算|
|| CC2\_BN |バッチノーマライゼーションの計算 |
|| CC2\_LRERU |LeakyRELUの計算 |

各ブロックの詳細はブロック仕様にて記載する。

# 動作説明
StingはCPUからのレジスタライトで起動する。高速化のために、出力データの作業メモリとしてZynq APUのL2キャッシュを想定しており、出力データのサイズにより動作を変える必要がある。L2キャッシュが512Kバイトなので、主力データがそれ以上の場合は分割実行が必要になる。Stingが分割実行をするかどうかは、実行モードによって指定する。

実行モード
- 通常モード　出力データが512Kバイト以下で使用。一回の起動で全ての計算が終了する。
- 分割モード　出力データが512Kバイト以下になるように分割して起動する。分割数と同じだけの起動が必要である。

まずは変数の定義をした後、通常モードと、分割モードでの計算順序について記述する。

## 変数定義
Stingでは計算の変数について以下の定義を使用する。変数名はコキュートスの出力Cソースと対応している。

<img src="val.png">

| 変数名 | 意味 |
|:----|:----|
|n | 入力データのチャネル数。入力データがインプットレイヤーの出力の時、n=3(RGB)となる。それ以外の時は、前のレイヤーのフィルター数と同じである。 |
|f | フィルターの数、出力データのチャネル数を示す。 |
|x | 入力データのwidth方向の変数。左端を0に取る。 |
|y | 入力データのheight方向の変数。上端を0に取る。 |

## 通常モード動作
通常モードでは一回の起動で全ての処理を完了する。

はじめにf=0について全ての計算を行う。
<img src="seq_n1.png">  

次にf=1について全ての計算を行う。
<img src="seq_n2.png">

以下全ての計算が終了するまでfの値を増やしていく。

## 分割モード動作時

はじめにf=0について、分割した部分の計算を行う。分割の単位はレジスタで指定する。
<img src="seq_d1.png">

分割した箇所についてf=1の計算を行う。
<img src="seq_d2.png">

fの最後まで計算すると割り込みが入り、stingは動作を完了する。
<img src="seq_d3.png">

新しくレジスタを設定し、次の分割の単位の計算を開始させる。（f=0)
<img src="seq_d4.png">

今まで同様にf=1から 最後まで順に処理を行い、最後に割り込みを発生させ動作を終了する。
<img src="seq_d5.png">

# ブロック仕様

## STING\_TOP
### 機能一覧
STINGのTOP階層。

### パラメータ一覧

| group|パラメータ|デフォルト値|
|----|----|----|
|M00\_AXI|C\_M00\_AXI\_TARGET\_SLAVE\_BASE\_ADDR|32'h40000000|
||C_M00_AXI_BURST_LEN|16|
||C_M00_AXI_ID_WIDTH|1|
||C_M00_AXI_ADDR_WIDTH|32|
||C_M00_AXI_DATA_WIDTH|32|
||C_M00_AXI_AWUSER_WIDTH|0|
||C_M00_AXI_ARUSER_WIDTH|0|
||C_M00_AXI_WUSER_WIDTH|0|
||C_M00_AXI_RUSER_WIDTH|0|
||C_M00_AXI_BUSER_WIDTH|0|
|M01_AXI|C_M01_AXI_START_DATA_VALUE|32'hAA000000|
||C_M01_AXI_TARGET_SLAVE_BASE_ADDR|32'h40000000|
||C_M01_AXI_ADDR_WIDTH|32|
||C_M01_AXI_DATA_WIDTH|32|
||C_M01_AXI_TRANSACTIONS_NUM|4|
|M02_AXI|C_M02_AXI_TARGET_SLAVE_BASE_ADDR|32'h40000000|
||C_M02_AXI_BURST_LEN|16|
||C_M02_AXI_ID_WIDTH|1|
||C_M02_AXI_ADDR_WIDTH|32|
||C_M02_AXI_DATA_WIDTH|32|
||C_M02_AXI_AWUSER_WIDTH|0|
||C_M02_AXI_ARUSER_WIDTH|0|
||C_M02_AXI_WUSER_WIDTH|0|
||C_M02_AXI_BUSER_WIDTH|0|
|S00_AXI|C_S00_AXI_DATA_WIDTH|32|
||C_S00_AXI_ADDR_WIDTH|8|
|S_AXI_INTR|C_S_AXI_INTR_DATA_WIDTH|32|
||C_S_AXI_INTR_ADDR_WIDTH|5|
||C_NUM_OF_INTR|1|
||C_INTR_SENSITIVITY|32'hFFFFFFFF|
||C_INTR_ACTIVE_STATE|32'hFFFFFFFF|
||C_IRQ_SENSITIVITY|1|
||C_IRQ_ACTIVE_STATE|1|

### 入出力一覧

| group|入出力|信号名|
|----|----|----|
|M00_AXI|input |  m00_axi_init_axi_txn|
||output |  m00_axi_txn_done|
||output |  m00_axi_error|
||input |  m00_axi_aclk|
||input |  m00_axi_aresetn|
||output | [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid|
||output | [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr|
||output | [7 : 0] m00_axi_awlen|
||output | [2 : 0] m00_axi_awsize|
||output | [1 : 0] m00_axi_awburst|
||output |  m00_axi_awlock|
||output | [3 : 0] m00_axi_awcache|
||output | [2 : 0] m00_axi_awprot|
||output | [3 : 0] m00_axi_awqos|
||output | [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser|
||output |  m00_axi_awvalid|
||input |  m00_axi_awready|
||output | [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata|
||output | [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb|
||output |  m00_axi_wlast|
||output | [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser|
||output |  m00_axi_wvalid|
||input |  m00_axi_wready|
||input | [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid|
||input | [1 : 0] m00_axi_bresp|
||input | [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser|
||input |  m00_axi_bvalid|
||output |  m00_axi_bready|
||output | [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid|
||output | [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr|
||output | [7 : 0] m00_axi_arlen|
||output | [2 : 0] m00_axi_arsize|
||output | [1 : 0] m00_axi_arburst|
||output |  m00_axi_arlock|
||output | [3 : 0] m00_axi_arcache|
||output | [2 : 0] m00_axi_arprot|
||output | [3 : 0] m00_axi_arqos|
||output | [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser|
||output |  m00_axi_arvalid|
||input |  m00_axi_arready|
||input | [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid|
||input | [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata|
||input | [1 : 0] m00_axi_rresp|
||input |  m00_axi_rlast|
||input | [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser|
||input |  m00_axi_rvalid|
||output |  m00_axi_rready|
|M01_AXI|input |  m01_axi_init_axi_txn|
||output |  m01_axi_error|
||output |  m01_axi_txn_done|
||input |  m01_axi_aclk|
||input |  m01_axi_aresetn|
||output | [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_awaddr|
||output | [2 : 0] m01_axi_awprot|
||output |  m01_axi_awvalid|
||input |  m01_axi_awready|
||output | [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_wdata|
||output | [C_M01_AXI_DATA_WIDTH/8-1 : 0] m01_axi_wstrb|
||output |  m01_axi_wvalid|
||input |  m01_axi_wready|
||input | [1 : 0] m01_axi_bresp|
||input |  m01_axi_bvalid|
||output |  m01_axi_bready|
||output | [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_araddr|
||output | [2 : 0] m01_axi_arprot|
||output |  m01_axi_arvalid|
||input |  m01_axi_arready|
||input | [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_rdata|
||input | [1 : 0] m01_axi_rresp|
||input |  m01_axi_rvalid|
||output |  m01_axi_rready|
|M02_AXI|input |  m02_axi_init_axi_txn|
||output |  m02_axi_txn_done|
||output |  m02_axi_error|
||input |  m02_axi_aclk|
||input |  m02_axi_aresetn|
||output | [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_awid|
||output | [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_awaddr|
||output | [7 : 0] m02_axi_awlen|
||output | [2 : 0] m02_axi_awsize|
||output | [1 : 0] m02_axi_awburst|
||output |  m02_axi_awlock|
||output | [3 : 0] m02_axi_awcache|
||output | [2 : 0] m02_axi_awprot|
||output | [3 : 0] m02_axi_awqos|
||output | [C_M02_AXI_AWUSER_WIDTH-1 : 0] m02_axi_awuser|
||output |  m02_axi_awvalid|
||input |  m02_axi_awready|
||output | [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_wdata|
||output | [C_M02_AXI_DATA_WIDTH/8-1 : 0] m02_axi_wstrb|
||output |  m02_axi_wlast|
||output | [C_M02_AXI_WUSER_WIDTH-1 : 0] m02_axi_wuser|
||output |  m02_axi_wvalid|
||input |  m02_axi_wready|
||input | [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_bid|
||input | [1 : 0] m02_axi_bresp|
||input | [C_M02_AXI_BUSER_WIDTH-1 : 0] m02_axi_buser|
||input |  m02_axi_bvalid|
||output |  m02_axi_bready|
||output | [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_arid|
||output | [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_araddr|
||output | [7 : 0] m02_axi_arlen|
||output | [2 : 0] m02_axi_arsize|
||output | [1 : 0] m02_axi_arburst|
||output |  m02_axi_arlock|
||output | [3 : 0] m02_axi_arcache|
||output | [2 : 0] m02_axi_arprot|
||output | [3 : 0] m02_axi_arqos|
||output | [C_M02_AXI_ARUSER_WIDTH-1 : 0] m02_axi_aruser|
||output |  m02_axi_arvalid|
||input |  m02_axi_arready|
||input | [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_rid|
||input | [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_rdata|
||input | [1 : 0] m02_axi_rresp|
||input |  m02_axi_rlast|
||input | [C_M02_AXI_RUSER_WIDTH-1 : 0] m02_axi_ruser|
||input |  m02_axi_rvalid|
||output |  m02_axi_rready|
|S00_AXI|input |  s00_axi_aclk|
||input |  s00_axi_aresetn|
||input | [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr|
||input | [2 : 0] s00_axi_awprot|
||input |  s00_axi_awvalid|
||output |  s00_axi_awready|
||input | [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata|
||input | [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb|
||input |  s00_axi_wvalid|
||output |  s00_axi_wready|
||output | [1 : 0] s00_axi_bresp|
||output |  s00_axi_bvalid|
||input |  s00_axi_bready|
||input | [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr|
||input | [2 : 0] s00_axi_arprot|
||input |  s00_axi_arvalid|
||output |  s00_axi_arready|
||output | [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata|
||output | [1 : 0] s00_axi_rresp|
||output |  s00_axi_rvalid|
||input |  s00_axi_rready|
|S_AXI_INTR|input |  s_axi_intr_aclk|
||input |  s_axi_intr_aresetn|
||input | [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_awaddr|
||input | [2 : 0] s_axi_intr_awprot|
||input |  s_axi_intr_awvalid|
||output |  s_axi_intr_awready|
||input | [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_wdata|
||input | [(C_S_AXI_INTR_DATA_WIDTH/8)-1 : 0] s_axi_intr_wstrb|
||input |  s_axi_intr_wvalid|
||output |  s_axi_intr_wready|
||output | [1 : 0] s_axi_intr_bresp|
||output |  s_axi_intr_bvalid|
||input |  s_axi_intr_bready|
||input | [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_araddr|
||input | [2 : 0] s_axi_intr_arprot|
||input |  s_axi_intr_arvalid|
||output |  s_axi_intr_arready|
||output | [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_rdata|
||output | [1 : 0] s_axi_intr_rresp|
||output |  s_axi_intr_rvalid|
||input |  s_axi_intr_rready|
||output |  irq |

## CC2\_REG\_IF
### 機能
レジスタI/F。AXIバスを通して、Sting内部レジスタのR/Wを行う。

### 入出力一覧

|入出力|信号名|説明|
|----|----|----|
|input|S_AXI_ACLK|Global Clock Signal|
|input|Global Clock Signal|Global Reset Signal. This Signal is Active LOW|
|input| [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR||
|input|[2 : 0] S_AXI_AWPROT||
|input| S_AXI_AWVALID||
|output| S_AXI_AWREADY||
|input|[C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA||
|input |[(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB||
|input|S_AXI_WVALID||
|output|S_AXI_WREADY||
|output|S_AXI_BRESP||
|output|S_AXI_BVALID||
|input |S_AXI_BREADY||
|input| [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR||
|input|wire [2 : 0] S_AXI_ARPROT||
|input|S_AXI_ARVALID||
|output |S_AXI_ARREADY||
|output|[C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA||
|output|[1 : 0] S_AXI_RRESP||
|output|S_AXI_RVALID||
|input|S_AXI_RREADY||

<font color="red">[TODO] 後で入出力入れ替え</font>
```
| input | [8:0] REG_AXI\_RD\_INPUT_XSIZE | 入力データのXsizeを示す。 |
| input | REG_AXI_RD_WEIGHT_SOFTRESET | 正論理のソフトリセット | 
|input | [31:0] REG_AXI_RD_WEIGHT_START_ADR | 入力データの先頭アドレス | 

```

<font color="red">[TODO] レジスタの出力追加</font>

AXI信号の説明は省略。

### 動作説明

## CC2\_CONTROL
<font color="red">[TODO] 後で書く</font>

### 機能
### 入出力一覧

<font color="red">[TODO] 後で入出力入れ替え</font>

```
|input | [31:0] REG_AXI_RD_INPUT_START_ADR | 入力データの先頭アドレス | 
| input | [8:0] REG_AXI\_RD\_INPUT_XSIZE | 入力データのXsize |
| input | [8:0] REG_AXI\_RD\_INPUT_FSIZE | 入力データのフレームサイズ。 |
| input | AXI\_RD\_INPUT_START | 1で動作開始 |
| input | AXI\_RD\_INPUT_NEXT_FRAME | 1で次のフレームへ |
| input | AXI\_RD\_INPUT_TOP_PADDING_ENABLE | 1の時、一番上に0のパディングを入れる | 
| input | AXI\_RD\_INPUT_BOTTOM_PADDING_ENABLE | 1の時、一番下に0のパディングを入れる | 
| input | AXI\_RD\_INPUT_FIRSTLINE | 1の時、次のライン読み込みが最初のラインであることを示す |
| input | AXI\_RD\_INPUT_LASTLINE | 1の時、次のライン読み込みが最後を示す |

|input | [31:0] REG_AXI_RD_WEIGHT_START_ADR | 入力データの先頭アドレス | 
| input | AXI\_RD\_WEIGHT_START | 1で動作開始 |
```

### 動作説明

## CC2\_AXI\_RD\_INPUT
### 機能
AXIポートから入力データを読み出す。
- AXIバーストリード
- 左右の0パディング
- 上下の0パディング（動作モードによる）
- 4本のラインバッファの制御

### パラメータ
| group|パラメータ|デフォルト値|
|----|----|----|
|AXI |C_M_TARGET_SLAVE_BASE_ADDR|32'h40000000|
||C_M_AXI_BURST_LEN|16|
||C_M_AXI_ID_WIDTH|1|
||C_M_AXI_ADDR_WIDTH|32|
||C_M_AXI_DATA_WIDTH|32|
||C_M_AXI_AWUSER_WIDTH|0|
||C_M_AXI_ARUSER_WIDTH|0|
||C_M_AXI_WUSER_WIDTH|0|
||C_M_AXI_RUSER_WIDTH|0|
||C_M_AXI_BUSER_WIDTH|0|

### 入出力一覧

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
| input | REG_AXI_RD_INPUT_SOFTRESET | 正論理のソフトリセット | 
|input | [31:0] REG_AXI_RD_INPUT_START_ADR | 入力データの先頭アドレス | 
| input | [8:0] REG_AXI\_RD\_INPUT_XSIZE | 入力データのXsize |
| input | [8:0] REG_AXI\_RD\_INPUT_FSIZE | 入力データのフレームサイズ。 |
| input | AXI\_RD\_INPUT_START | 1で動作開始 |
| input | AXI\_RD\_INPUT_NEXT_FRAME | 1で次のフレームへ |
| input | AXI\_RD\_INPUT_TOP_PADDING_ENABLE | 1の時、一番上に0のパディングを入れる | 
| input | AXI\_RD\_INPUT_BOTTOM_PADDING_ENABLE | 1の時、一番下に0のパディングを入れる | 
| input | AXI\_RD\_INPUT_FIRSTLINE | 1の時、次のライン読み込みが最初のラインであることを示す |
| input | AXI\_RD\_INPUT_LASTLINE | 1の時、次のライン読み込みが最後を示す |
| input | AXI\_RD\_INPUT_READ | 1 の時ラインバッファの読み出し |
| output | AXI\_RD\_DATA_VALID | 1 のデータの出力が有効 |
| output | [31:0] AXI\_RD\_INPUT_DATA0 | ラインバッファの出力, float32 |
| output | [31:0] AXI\_RD\_INPUT_DATA1 | ラインバッファの出力 float32|
| output | [31:0] AXI\_RD\_INPUT_DATA2 | ラインバッファの出力 float32|
| output | AXI\_RD\_INPUT_READY | ラインバッファにデータが書き込まれたことを示す |

Vivadoが生成するAXI信号は省略

### 動作説明

#### 1ライン目動作（パディング無し）
分割モード時の開始時の動作を示す。

<img src=wave/axi_rd1.jpg>  

- ①CC2_CONTROLがAXI_RD_INPUT_STARTをHにして動作を開始する。AXI経由で3ライン分のデータをラインバッファに読み込む。  
- ②ラインバッファが3ライン分フルになると、AXI_RD_INPUT_READYをHにする。  
- ③CC2_CONTROLがAXI_RD_INPUT_READをHにしてラインバッファを読み出す。同時に、AXI経由で次のデータを1ライン分読み出す。読み出しが完了するまでAXI_RD_INPUT_READYをLにする。  
- ④読み出されたデータは、AXI_RD_DATA_VALIDに合わせて出力される。最初のデータと、最後のデータは左右の0パディングのために0が出力される。  
- ⑤次のデータの1ライン分の読み出しが終わると、AXI_RD_INPUT_READYをHにする。
- ⑥CC2_CONTROLがAXI_RD_INPUT_READをHにして、次のデータを読み出す。

#### 1ライン目動作（パディング有り）
通常モード時の動作を示す。分割モード時との違いは、1ライン目の読み出しに0パディングが入ることである。

<img src=wave/axi_rd1.jpg>  

- ①通常モード時は、AXI_RD_INPUT_TOP_PADDING_ENABLEをHにする。  
- ②CC2_CONTROLがAXI_RD_INPUT_STARTをHすると同時に、AXI_RD_INPUT_FIRSTLINEもHにする。AXI_RD_INPUT_FIRSTLINEは、AXI_RD_INPUT_READがHになるまでHを維持する。AXI_RD_INPUT_FIRSTLINEがHの時は、ラインバッファへは2ライン分を書き込む。
- ③最初の読み出し時のみ、AXI_RD_INPUT_DATA0は0を出力する。以後は、1ライン目動作（パディング有り）と同じ動作である。  

上記以外の動作は、[1ライン目動作（パディング有り）](#1ライン目動作パディング有り)と同じである。


#### 最終ライン動作（パディング無し）



#### 最終ライン動作（パディング有り）



## CC2\_AXI\_RD\_WEIGHT
### 機能
AXI経由で重みデータ(3x3)を読み出す。

### パラメータ
| group|パラメータ|デフォルト値|
|----|----|----|
|AXI |C_M_START_DATA_VALUE|32'hAA000000|
||C_M_TARGET_SLAVE_BASE_ADDR|32'h40000000|
||C_M_AXI_ADDR_WIDTH|32|
||C_M_AXI_DATA_WIDTH|32|
||C_M_TRANSACTIONS_NUM|4|

### 入出力

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
| input | REG_AXI_RD_WEIGHT_SOFTRESET | 正論理のソフトリセット | 
|input | [31:0] REG_AXI_RD_WEIGHT_START_ADR | 入力データの先頭アドレス | 
| input | AXI\_RD\_WEIGHT_START | 1で動作開始 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA00 | 重みの出力 weight[0][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA01 | 重みの出力 weight[0][1], float32|
| output | [31:0] AXI\_RD\_WEIGHT_DATA02 | 重みの出力 weight[0][2], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA10 | 重みの出力 weight[1][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA11 | 重みの出力 weight[1][1], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA12 | 重みの出力 weight[1][2], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA20 | 重みの出力 weight[2][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA21 | 重みの出力 weight[2][1], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA22 | 重みの出力 weight[2][2], float32 |
| output | AXI\_RD\_WEIGHT_READY | 重みの読み出しが終わったことを示す | 

### 動作説明
#### 重み読み出し


## CC2\_AXI\_RW\_OUTPUT

### 機能
AXIポートから出力データをR/Wする
- AXIバーストリード
- AXIバーストライト
- 2本のラインバッファの制御

最初の計算時にAXIから読み出さず0を返すことで、ワーク領域の0クリアーを不要にする。

### パラメータ

| group|パラメータ|デフォルト値|
|----|----|----|
|axi|C_M_TARGET_SLAVE_BASE_ADDR|32'h40000000|
||C_M_AXI_BURST_LEN|16|
||C_M_AXI_ID_WIDTH|1|
||C_M_AXI_ADDR_WIDTH|32|
||C_M_AXI_DATA_WIDTH|32|
||C_M_AXI_AWUSER_WIDTH|0|
||C_M_AXI_ARUSER_WIDTH|0|
||C_M_AXI_WUSER_WIDTH|0|
||C_M_AXI_RUSER_WIDTH|0|
||C_M_AXI_BUSER_WIDTH|0|

### 入出力一覧

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
| input | REG_AXI_RW_OUTPUT_SOFTRESET | 正論理のソフトリセット | 
|input | [31:0] REG_AXI_RW_OUTPUT_START_ADR | 出力データの先頭アドレス | 
| input | [8:0] REG_AXI\_RW\_OUTPUT_XSIZE | 出力データのXsize |
| input | [8:0] REG_AXI\_RW\_OUTPUT_FSIZE | 出力データのフレームサイズ。 |
| input | AXI\_RW\_OUTPUT_START | 1で動作開始 |
| input | AXI\_RW\_OUTPUT_NEXT_FRAME | 1で次のフレームへ |
| input | AXI\_RW\_OUTPUT_NEXT_FRAME | 1で次のフレームへ |
| input | AXI\_RW\_OUTPUT_FIRST | 1の時AXIからデータを読まずに、全て0のデータを出力する。 |
| output | AXI\_RW\_OUTPUT_READY | 出力データの読み出し、書き込みが終わったことを示す | 
| output | [31:0] AXI\_RW_OUTPUT_RDDATA | AXIから読み出したデータ。float32 |
| input |  AXI\_RW_OUTPUT_RDEN | 読み出し信号|
| input | [31:0] AXI\_RW_OUTPUT_WRDATA | AXIに書き込むデータ。float32 |
| input |  AXI\_RW_OUTPUT_WREN | 書き込み信号|

vivadoが出力するAXIの信号は省略

### 動作説明

#### 起動時

#### 通常時読み出し

#### 次のフレームへ

## CC2\_DSP3x3
### 機能

### パラメータ
無し

### 入出力

### 動作説明

## CC2\_CONV
### 機能

### パラメータ
無し

### 入出力

### 動作説明

# レジスタ一覧

# リファレンス


