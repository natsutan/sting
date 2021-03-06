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

<img src="img/blk.png">

各ブロックは以下の機能を持つ。

| ブロック名|サブブロック名|機能|
|:----|:----|:----|
| STING\_TOP| - | TOP階層 |
| sting\_wrap\_v1\_0\_S00_AXI | - | レジスタI/F|
| CC2\_CONTROL|- | 全体制御|
| |CC2\_INTC| 割り込み|
| CC2\_AXI\_RD\_INPUT |-|入力データのリード|
| CC2\_AXI\_RD\_WEIGHT |-|重みデータのリード|
| CC2\_AXI\_RW\_OUTPUT |-|出力データのR/W |
| CC2\_DSP3x3 |-|　3x3のフィルター計算|
| CC2\_CONV | - | コンボリューションの実行|
|| CC2\_BIAS | BIAS項の加算|
|| CC2\_BN |バッチノーマライゼーションの計算 |
|| CC2\_LRELU |LeakyRELUの計算 |

各ブロックの詳細はブロック仕様にて記載する。

# 動作説明
StingはCPUからのレジスタライトで起動する。高速化のために、出力データの作業メモリとしてZynq APUのL2キャッシュを想定しており、出力データのサイズにより動作を変える必要がある。L2キャッシュが512Kバイトなので、主力データがそれ以上の場合は分割実行が必要になる。Stingが分割実行をするかどうかは、実行モードによって指定する。

実行モード
- 通常モード　出力データが512Kバイト以下で使用。一回の起動で全ての計算が終了する。
- 分割モード　出力データが512Kバイト以下になるように分割して起動する。分割数と同じだけの起動が必要である。

まずは変数の定義をした後、通常モードと、分割モードでの計算順序について記述する。

## 変数定義
Stingでは計算の変数について以下の定義を使用する。変数名はコキュートスの出力Cソースと対応している。

<img src="img/val.png">

| 変数名 | 意味 |
|:----|:----|
|n | 入力データのチャネル数。入力データがインプットレイヤーの出力の時、n=3(RGB)となる。それ以外の時は、前のレイヤーのフィルター数と同じである。 |
|f | フィルターの数、出力データのチャネル数を示す。 |
|x | 入力データのwidth方向の変数。左端を0に取る。 |
|y | 入力データのheight方向の変数。上端を0に取る。 |

## 通常モード動作
通常モードでは一回の起動で全ての処理を完了する。

はじめにf=0について全ての計算を行う。
<img src="img/seq_n1.png">  

次にf=1について全ての計算を行う。
<img src="img/seq_n2.png">

以下全ての計算が終了するまでfの値を増やしていく。

## 分割モード動作時

はじめにf=0について、分割した部分の計算を行う。分割の単位はレジスタで指定する。
<img src="img/seq_d1.png">

分割した箇所についてf=1の計算を行う。
<img src="img/seq_d2.png">

fの最後まで計算すると割り込みが入り、stingは動作を完了する。
<img src="img/seq_d3.png">

新しくレジスタを設定し、次の分割の単位の計算を開始させる。（f=0)
<img src="img/seq_d4.png">

今まで同様にf=1から 最後まで順に処理を行い、最後に割り込みを発生させ動作を終了する。
<img src="img/seq_d5.png">

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

## sting\_wrap\_v1\_0\_S00_AXI
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
|output | REG_AXI_CC_CONTROL_SOFTRESET | CC_CONTROLのソフトリセット(正論理) |
|output | REG_AXI_RD_INPUT_SOFTRESET | AXI_RD_INPUTのソフトリセット（正論理）|
|output | REG_AXI_RD_WEIGHT_SOFTRESET | AXI_RD_WEIGHTのソフトリセット（正論理）|
|output | REG_AXI_RW_OUTPUT_SOFTRESET | AXI_RW_OUTPUTのソフトリセット（正論理）|
ット | 
| output | REG_AXI_CC2_CONV_SOFTRESET | AXI_CC2_CONVのソフトリセット（正論理）|
| input  | REG_STS_RUNNING | 動作中時に1、リセット、動作終了後に0 |
| input  | REG_STS_INT | 割り込み発生時に1、リセット、割り込みクリアーで0 |
| input  | [7:0] REG_STS_YNUM | 処理中のLINE(Y)の値 |
| input  | [15:0] REG_STS_FNUM | 処理中のFrame(F)の値 |
| output | REG_MODE | 0:通常モード, 1：分割モード |
| output | REG_RUN | 1で動作開始、HWで自動的に0クリアーされる。 |
| output | [8:0] REG_AXI_RD_INPUT_XSIZE | 入力データのXsizeを示す。 |
| output | [8:0] REG_AXI_RD_INPUT_YSIZE | 入力データのYsizeを示す。 |
| output | [31:0] REG_AXI_RD_INPUT_START_ADR | 入力データの開始アドレス |
| output | [31:0] REG_AXI_RD_INPUT_FSIZE | 入力データのフレームサイズ |
|output | [31:0] REG_AXI_RD_WEIGHT_START_ADR | 重みの先頭アドレス | 
|output | [31:0] REG_AXI_RD_WEIGHT_START_ADR2 | 重みの先頭アドレス(BN) | 
| ouptut | [31:0] REG_AXI_RW_OUTPUT_START_ADR | 出力データの先頭アドレス | 
| output | [8:0] REG_AXI_RW_OUTPUT_XSIZE | 出力データのXSIZE |
| output | [31:0] REG_AXI_RW_OUTPUT_FSIZE | 出力データのフレームサイズ | 
| output | REG_CONV_LRELU_EN | 1でLRELUが有効 |
| output | REG_CONV_BN_EN | 1の時BNが有効 |
| output | [15:0] REG_NSIZE | 入力データのチャネル数(n) |
| output | [15:0] REG_FSIZE | フィルター数(f) |
| output | [31:0] REG_LEAKY_RELU | LeakyRELUの係数, float32 |
| input  | [31:0] DEBCNT0 | 処理のカウント 下位32bit |
| input  | [31:0] DEBCNT1 | 処理のカウント 上位32bit |


AXI信号の説明は省略。

### 動作説明

## CC2\_CONTROL

### 機能
全体のシーケンス制御を行う。
- AXI_RD_INPUT_NEXT_FRAMEを使用し、1ラインの処理を開始する。  
- レジスタ値と内部カウンターを使い、パディング処理など特別な処理の制御を行う。  
- 処理終了後に割り込みを発生させる。

### 入出力一覧

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
| input | REG_AXI_CC_CONTROL_SOFTRESET | 正論理のソフトリセット | 
| output | irq | 割り込み信号 |
| output | AXI_RD_INPUT_START | 1でAXI_RD_INPUTが動作開始 |
| output | AXI_RD_INPUT_READ | 1でAXI_RD_INPUTのリード開始 |
| output | AXI_RD_INPUT_NEXT_FRAME | 1で次のフレームへ |
| output | AXI_RD_INPUT_TOP_PADDING_ENABLE | 1の時、一番上に0のパディングを入れる | 
| output | AXI_RD_INPUT_BOTTOM_PADDING_ENABLE | 1の時、一番下に0のパディングを入れる | 
| output | AXI_RD_INPUT_FIRSTLINE | 1の時、次のライン読み込みが最初のラインであることを示す |
| output | AXI_RD_INPUT_LASTLINE | 1の時、次のライン読み込みが最後を示す |
| output | AXI_RD_WEIGHT_START | 1でAXI_RD_INPUTが動作開始 |
| input | AXI_RD_WEIGHT_READY | 重みの読み出しが終わったことを示す | 
| input | AXI_RD_INPUT_READY | ラインバッファにデータが書き込まれたことを示す |
| output | CONV_LAST | 1の時LeakyRELUとBNの処理を行う。 |
| input | AXI_RW_OUTPUT_START | 出力データの読み出し開始 | 
| input | AXI_RW_OUTPUT_READY | 出力データの読み出し、書き込みが終わったことを示す | 
| input | AXI_RW_OUTPUT_FIFO_EMPTY |出力データ用のラインバッファが空の時1 |   
| input | [8:0] REG_INPUT_YSIZE | 入力データのYsize |
| input | [15:0] REG_NSIZE | 入力データのチャネル数(n) |
| input | [15:0] REG_FSIZE | フィルター数(f) |
| input | REG_MODE | 0:通常モード, 1：分割モード |
| ouyput | REG_RUN | 1で動作開始 |
| output  | REG_STS_RUNNING | 動作中時に1、リセット、動作終了後に0 |
| output  | REG_STS_INT | 割り込み発生時に1、リセット、割り込みクリアーで0 |
| output  | [7:0] REG_STS_YNUM | 処理中のLINE(Y)の値 |
| output  | [15:0] REG_STS_FNUM | 処理中のFrame(F)の値 |
| output  | [31:0] DEBCNT0 | 処理のカウント 下位32bit |
| output  | [31:0] DEBCNT1 | 処理のカウント 上位32bit |



### 動作説明

#### 起動時

<img src=wave/cntr1.jpg>  

- ①RUNレジスタのライトで動作を開始する。  
- ②AXI_RD_INPUT_START、AXI_RD_WEIGHT_START、AXI_RW_OUTPUT_STARTをHにして、それぞの読出しを開始する。  
- ③AXI_RD_INPUT_READY, AXI_RD_WEIGHT_READY,AXI_RW_OUTPUT_READYすべてがHになると、AXI_RD_INPUT_READをHにしてAXI_RD_INPUTからデータを読み出す。AXI_RD_INPUT_READYは自動的にLになり、次のラインのデータを読み込みを開始する。  
- ④AXI_RD_INPUT_READYのH、AXI_RD_WEIGHT_READYのH、AXI_RW_OUTPUT_READYのL→Hの遷移で、AXI_RD_INPUT_READをHにして次のラインの動作を開始する。
以後、③、④の繰り返し

#### 割り込み動作

<img src=wave/cntr2.jpg>  

- ①最終フレームの最終ラインの処理後、AXI_RW_OUTPUT_FIFO_EMPTYが1になったとき、irqを1にしてCPUに割り込みを通知する。

[CC2_AXI_RW_OUTPUTの最終ライン動作時](#最終ライン動作時)も参照のこと。

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
| input | [8:0] REG_AXI_RD_INPUT_XSIZE | 入力データのXsize |
| input | [31:0] REG_AXI_RD_INPUT_FSIZE | 入力データのフレームサイズ。 |
| input | AXI_RD_INPUT_START | 1で動作開始 |
| input | AXI_RD_INPUT_NEXT_FRAME | 1で次のフレームへ |
| input | AXI_RD_INPUT_TOP_PADDING_ENABLE | 1の時、一番上に0のパディングを入れる | 
| input | AXI_RD_INPUT_BOTTOM_PADDING_ENABLE | 1の時、一番下に0のパディングを入れる | 
| input | AXI_RD_INPUT_FIRSTLINE | 1の時、次のライン読み込みが最初のラインであることを示す |
| input | AXI_RD_INPUT_LASTLINE | 1の時、次のライン読み込みが最後を示す |
| input | AXI_RD_INPUT_READ | 1 の時ラインバッファの読み出し |
| output | AXI_RD_DATA_VALID | 1 のデータの出力が有効 |
| output | [31:0] AXI_RD_INPUT_DATA0 | ラインバッファの出力, float32 |
| output | [31:0] AXI_RD_INPUT_DATA1 | ラインバッファの出力 float32|
| output | [31:0] AXI_RD_INPUT_DATA2 | ラインバッファの出力 float32|
| output | AXI_RD_INPUT_READY | ラインバッファにデータが書き込まれたことを示す |

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

<img src=wave/axi_rd2.jpg>  

- ①通常モード時は、AXI_RD_INPUT_TOP_PADDING_ENABLEをHにする。  
- ②CC2_CONTROLがAXI_RD_INPUT_STARTをHすると同時に、AXI_RD_INPUT_FIRSTLINEもHにする。AXI_RD_INPUT_FIRSTLINEは、AXI_RD_INPUT_READがHになるまでHを維持する。AXI_RD_INPUT_FIRSTLINEがHの時は、ラインバッファへは2ライン分を書き込む。
- ③最初の読み出し時のみ、AXI_RD_INPUT_DATA0は0を出力する。以後は、[1ライン目動作（パディング有り）](#1ライン目動作パディング有り)と同じ動作である。  

上記以外の動作は、[1ライン目動作（パディング有り）](#1ライン目動作パディング有り)と同じである。


#### 最終ライン動作（パディング無し）
分割モード時の、あるフレームの最終ラインから、次のフレームへ処理を移す時の動作を示す。

<img src=wave/axi_rd3.jpg>  

- ①最終ラインの処理は、AXI_RD_INPUT_READのHと同時に、AXI_RD_INPUT_LASTLINEをHにする。AXI_RD_INPUT_LASTLINEがHの時は、次のラインのリードを停止する。  
- ②後段の計算終了後、CC2_CONTROLがAXI_RD_INPUT_NEXT_FRAMEをHにする。このとき、AXIの読み出しアドレスを次のフレームの先頭へ設定する。  
- ③AXI_RD_INPUT_STARTをHにして次のフレームの動作を開始する。


#### 最終ライン動作（パディング有り）
通常モード時の最終ラインの処理を示す。最終ラインに0パディングが入る以外は、[最終ライン動作（パディング無し）](#最終ライン動作（パディング無し）)と同じである。

<img src=wave/axi_rd4.jpg>  

- ①通常モード時は、AXI_RD_INPUT_BOTTOM_PADDING_ENABLEをHにする。AXI_RD_INPUT_READのHと同時に、AXI_RD_INPUT_LASTLINEをHにする。  
- ②リードデータ読み出し時に、AXI_RD_INPUT_DATA2は0を出力する。

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
|input | [31:0] REG_AXI_RD_WEIGHT_START_ADR | 重みデータの先頭アドレス | 
|input | [31:0] REG_AXI_RD_WEIGHT_START_ADR2 | 重みデータの先頭アドレス(BN) | 
| input | REG_BN_EN | バッチノーマライゼーションのイネーブル |
| input | AXI\_RD\_WEIGHT_START | 1で動作開始 |
| input | AXI\_RD\_WEIGHT_NEXT | 1で動作開始 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA00 | 重みの出力 weight[0][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA01 | 重みの出力 weight[0][1], float32|
| output | [31:0] AXI\_RD\_WEIGHT_DATA02 | 重みの出力 weight[0][2], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA10 | 重みの出力 weight[1][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA11 | 重みの出力 weight[1][1], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA12 | 重みの出力 weight[1][2], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA20 | 重みの出力 weight[2][0], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA21 | 重みの出力 weight[2][1], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_DATA22 | 重みの出力 weight[2][2], float32 |
| output | [31:0] AXI\_RD\_WEIGHT_BN0 | BNの重みデータ0, float32 |
| output | [31:0] AXI\_RD\_WEIGHT_BN1 | BNの重みデータ1, float32 |
| output | AXI\_RD\_WEIGHT_READY | 重みの読み出しが終わったことを示す | 

### 動作説明
#### 重み読み出し
重み読み出しの動作を以下に示す。

<img src=wave/axi_w.jpg>

- ①AXI_RD_WEIGHT_STARTのHで動作開始。REG_BN_EN が1の時、AXIより3x3の重みデータ、バッチノーマライゼーションのパラメータ2つを2回読み出す。REG_BN_ENが0の時は、3x3の重みデータのみ読み出す。
- ②2回読み出すうちの1つ目のデータはすぐに出力し、2回分のデータの読み出しが完了後、AXI_RD_WEIGHT_READYをHにする。  
- ③AXI_RD_WEIGHT_NEXTがHになると、次の重みデータを出力し、AXI_RD_WEIGHT_READYをLにする。AXI経由で次の重みデータをリードする。  
- ④次の重みデータのリードが完了した時点でAXI_RD_WEIGHT_READYをHにする。

内部で2段構成になっているため、BN\_EN信号はバッチノーマライゼーションのデータが必要な直前ではなく、その一つ前でHにする必要がある。
3x3CONVのデータ48個、BNデータが16個の場合、30個目のCONVデータをリクエストするAXI\_READ\_WEIGHT\_NEXTと同時にBN_EN信号をHにする。

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
| input | [8:0] REG_AXI_RW_OUTPUT_XSIZE | 出力データのXsize |
| input | [31:0] REG_AXI_RW_OUTPUT_FSIZE | 出力データのフレームサイズ。 |
| input | AXI_RW_OUTPUT_START | 1で動作開始 |
| input | AXI_RW_OUTPUT_FIRST | 1の時、1回目の読み出し。 |
| input | AXI_RW_OUTPUT_NEXT_LINE | 1で次のフレームへ |
| input | AXI_RW_OUTPUT_NEXT_FRAME | 1で次のフレームへ |
| input |  AXI_RW_OUTPUT_RDEN | 読み出し信号|
| input |  AXI_RW_OUTPUT_RDVALID | 読み出しデータのVALID信号 |
| output | [31:0] AXI_RW_OUTPUT_RDDATA | AXIから読み出したデータ。float32 |
| input |  AXI_RW_OUTPUT_WREN | 書き込み信号|
| input | [31:0] AXI_RW_OUTPUT_WRDATA | AXIに書き込むデータ。float32 |
| output | AXI_RW_OUTPUT_READY | 出力データの読み出し、書き込みが終わったことを示す | 
| output | AXI_RW_OUTPUT_FIFO_EMPTY |出力データ用のラインバッファが空の時1 | 

vivadoが出力するAXIの信号は省略

### 動作説明

#### 起動時
CC2\_AXI\_RW\_OUTPUTの起動時の動きを以下に示す。  

<img src=wave/axi_rw1.jpg>

- ①AXI_RW_OUTPUT_START がHになると動作を開始する。AXI_RW_OUTPUT_FIRSTがHで、最初のリードであることを示す。  
- ②AXIから読み出したデータが利用可能になり、ライト用のラインバッファに空きがでると、AXI_RW_OUTPUT_READY信号がHになる。AXI_RW_OUTPUT_FIRSTがHの時はAXIへのリードは行わないので、ライトのラインバッファの状態のみで、AXI_RW_OUTPUT_READYがHになる。  
- ③AXI_RW_OUTPUT_RDENがHで、リード用ラインバッファの読み出しを開始し、AXI_RW_OUTPUT_READYをLにする。  
- ④AXI_RW_OUTPUT_RDDATAに0を出力し、有効なデータの期間AXI_RW_OUTPUT_RDVALIDをHにする。  
- ⑤足し合わせたデータが、AXI_RW_OUTPUT_WRDATAに出力される。AXI_RW_OUTPUT_WREがHの時、データが有効である。  
- ⑥リードデータの読み出しが完了した後、AXI_RW_OUTPUT_NEXT_LINEがHになる。AXI_RW_OUTPUT_FIRSTがHなのでAXIからのデータ読み出しは実行しない。  
- ⑦ライト用のラインバッファに空きがでると、AXI_RW_OUTPUT_READY信号がHになる。以後、③からの動作を繰り返す。  

#### 通常動作時
2回目以降の書き込み時は、AXIからデータを読み出して、CC_CONV2で加算後書き戻す動作を行う。[起動時](#起動時)との動作の違いのみを示す。

<img src=wave/axi_rw2.jpg>

- ①AXI_RW_OUTPUT_FIRSTがLでAXI_RW_OUTPUT_STARTがHになり、動作を開始する。AXI経由で最初のラインのデータを読み込む。  
- ②1ラインのリードが完了した後、AXI_RW_OUTPUT_READYがHになる。  
- ③リードデータ読み出し時には、0ではなく①で読み出しだデータを出力する。  
- ④AXI_RW_OUTPUT_NEXT_LINEがHで次のラインのデータを読み出す。  

#### 最終ライン動作時
最終ラインの動作を示す。

<img src=wave/axi_rw3.jpg>

- ①最後のラインのラインバッファへの書き込みが終了した後、ラインバッファのデータをAXIバスに書き込む。書き込み終了後にAXI_RW_OUTPUT_FIFO_EMPTYがHになる。その後、AXI_RW_OUTPUT_NEXT_FRAMEがHになり、次のフレームのアドレス計算を行う。  
- ②AXI_RW_OUTPUT_STARTのHで、動作を開始する。

## CC2\_DSP3x3
### 機能
CC2_AXI_RD_INPUTからの3ラインデータと、CC2_AXI_RD_WEIGHTからの3x3フィルターをかけて足し、その結果を出力する。

### パラメータ
無し

### 入出力

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
|input | REG_CC2_DSP3x3_SOFTRESET | 正論理のソフトリセット | 
| input | DSP_INPUT_DATA_VALID | 1の時、入力データが有効 |
| input | [31:0] DSP_INPUT_DATA0 | 入力データ0, float32 |
| input | [31:0] DSP_INPUT_DATA1 | 入力データ1,  float32|
| input | [31:0] DSP_INPUT_DATA1 | 入力データ2,  float32|
| input | [31:0] DSP_WEIGHT_DATA00 | 重みの入力 weight[0][0], float32 |
| input | [31:0] DSP_WEIGHT_DATA01 | 重みの入力 weight[0][1], float32|
| input | [31:0] DSP_WEIGHT_DATA02 | 重みの入力 weight[0][2], float32 |
| input | [31:0] DSP_WEIGHT_DATA10 | 重みの入力 weight[1][0], float32 |
| input | [31:0] DSP_WEIGHT_DATA11 | 重みの入力 weight[1][1], float32 |
| input | [31:0] DSP_WEIGHT_DATA12 | 重みの入力 weight[1][2], float32 |
| input | [31:0] DSP_WEIGHT_DATA20 | 重みの入力 weight[2][0], float32 |
| input | [31:0] DSP_WEIGHT_DATA21 | 重みの入力 weight[2][1], float32 |
| input | [31:0] DSP_WEIGHT_DATA22 | 重みの入力 weight[2][2], float32 |
| output | DSP_OUTPUIT_DATA_VALID | 1の時、出力データが有効 |
| output | [31:0] DSP_OUTPUT_DATA | 出力データ, float32 |


## CC2\_CONV
### 機能
CC2_DSP3x3の計算結果を、出力データとしてメモリ上の値に加算する。最終チャネル(nが最大）の処理時は、LeakyRELUとバッチノーマライゼーションの処理を行い、AXI経由でメモリに書き込む。

### パラメータ
無し

### 入出力

|入出力|信号名|説明 |
|----|----|----|
|input |  M_AXI_ACLK| Global Clock Signal |
|input |  M_AXI_ARESETN| Global Reset Singal. This Signal is Active Low |
| input | REG_AXI_CC2_CONV_SOFTRESET | 正論理のソフトリセット | 
|input | [8:0] REG_AXI_RW_OUTPUT_XSIZE | 出力データのXsize |
|input | CONV_LAST | 1の時LeakyRELUとBNの処理を行う。 |
|input | REG_CONV_LRELU_EN | 1の時LeakyRELUの処理が有効 |
|input | REG_CONV_BN_EN | 1の時BNの処理が有効 |
|input | [31:0] REG_LEAKY_RELU | LeakyReluの係数, float32 |
| input | DSP_OUTPUIT_DATA_VALID | 1の時、CC2_DSP3x3からの出力データが有効 |
| input | [31:0] DSP_OUTPUT_DATA | CC2_DSP3x3の出力データ, float32 |
| output |  AXI_RW_OUTPUT_RDEN | AXI_RW_OUTPUTへの読み出し信号|
| output |  AXI_RW_OUTPUT_RDVALID | AXI_RW_OUTPUT読み出しデータのVALID信号 |
| input | [31:0] AXI_RW_OUTPUT_RDDATA | AXI_RW_OUTPUTから読み出したデータ。float32 |
| output |  AXI_RW_OUTPUT_WREN | AXI_RW_OUTPUTへの書き込み信号|
| output | [31:0] AXI_RW_OUTPUT_WRDATA | AXI_RW_OUTPUTに書き込むデータ。float32 |
| input | [31:0] AXI_RD_WEIGHT_BN0 | BNの重みデータ0, float32 |
| input | [31:0] AXI_RD_WEIGHT_BN1 | BNの重みデータ1, float32 |

### 動作説明

#### 通常動作
<img src=wave/conv.jpg>

- ①DSP_OUTPUIT_DATA_VALIDが1になり、CC2_DSP3x3から計算結果がDSP_OUTPUT_DATAに出力される。  
- ②AXI_RW_OUTPUT_RDENを1にし、データの読み出しを開始する。  
- ③AXI_RW_OUTPUTからの読み出しデータが、AXI_RW_OUTPUT_RDDATAに出力される。AXI_RW_OUTPUT_RDVALIDがHの時、データは有効である。  
- ④内部で加算した結果を、AXI_RW_OUTPUT_WRDATAに出力する。AXI_RW_OUTPUT_WRENが1の時、データは有効である。

CONV_LASTによって、演算の内容が変化するが③と④のタイミングが変わるだけで、シーケンスは全く同じである。

### 動作説明

#### データの入出力

<img src=wave/dsp.jpg>
DSP_INPUT_DATA_VALIDがHの時のデータに対して、一定の遅延の後計算結果がDSP_OUTPUIT_DATA_VALIDに合わせて出力される。

# レジスタ一覧

| offset |レジスタ名|説明 |
|----|----|----|
| 0x00 | CTRL | stingの制御を行う(ライトオンリー) |
| 0x04 | STATUS | stingのステータスを読み出す(リードオンリー) |
| 0x08 | MODE | 動作の設定を行う。 |
| 0x0C | IXSIZE | 入力データのXsize |
| 0x10 | IYSIZE | 入力データのYsize |
| 0x14 | ISADR  | 入力データの開始アドレス |
| 0x18 | IFSIZE | 入力データのフレームサイズ |
| 0x1C | WSADR1 | 重みの先頭アドレス1 |
| 0x20 | WSADR2 | 重みの先頭アドレス2 (BN) | 
| 0x24 | OXSIZE | 出力データのXSIZE | 
| 0x28 | OSADR  | 出力データの先頭アドレス | 
| 0x2C | OFSIZE | 出力データのフレームサイズ |
| 0x30 | LRELU | LeakyRELUの係数|
| 0x34 | FNSIZE | 入力チャネルとフィルター数 | 
| 0x38 | DEBCNT0 | 処理カウンター0 |
| 0x3C | DEBCNT1 | 処理カウンター1 |

## CTRL
stringの制御を行う

| bit| 31:2 | 1| 0|
|----|----|---|----|
|機能| - | RUN | RST|

- RST:1のライトでソフトウェアリセットを発行する。write only。
- RUN:1のライトで処理を開始する。write only。

## STATUS 

stingのステータスを読み出す(リードオンリー)

| bit| 31:16 | 15:8 | 7:2|   1|   0|
|----|-------|------|----|----|----|
|機能| FNUM  | YNUM |-   | INT| RUNNING|

- RUNNING:1の時stingは動作中。
- INT:割り込みのステータス
- YNUM:処理中のyを読み出す  
- FNUM:処理中のfの値を読み出す

## MODE 
動作の設定を行う。

| bit| 31:3 |      2|   1|   0|
|----|-------|------|----|----|
|機能| -   | LRELU | BN | MODE |

- MODE:0:通常モード, 1：分割モード  
- BN:1でバッチノーマライゼーションが有効  
- LRELU:1でLeakyRELUが有効

## IXSIZE 
入力データのXsize

| bit| 31:9 | 8:0|
|----|-------|----|
|機能| -   | IXSIZE |

- IXSIZE:入力データのXsize

## IYSIZE 
入力データのYsize

| bit| 31:9 | 8:0|
|----|-------|----|
|機能| -   | IYSIZE |

- IYSIZE:入力データのYsize

## ISADR
入力データの開始アドレス

| bit| 31:0  |
|----|-------|
|機能| ISADR |

- ISADR:入力データのYsize

## IFSIZE 
入力データのフレームサイズ

| bit| 31:0  |
|----|-------|
|機能| IFSIZE |

- IFSIZE:入力データのフレームサイズ

## WSADR1 
重みの先頭アドレス1  

| bit| 31:0  |
|----|-------|
|機能| WSADR1|

- WSADR1:コンボリューションの重みの先頭アドレス。

## WSADR2 
重みの先頭アドレス2 (BN) 

| bit| 31:0  |
|----|-------|
|機能| WSADR2|

- WSADR2:バッチノーマライゼーションの重みの先頭アドレス。

## OXSIZE 
出力データのXSIZE

| bit| 31:9 | 8:0|
|----|-------|----|
|機能| -   | OXSIZE |

- OXSIZE:出力データのXsize

## OSADR
出力データの先頭アドレス 

| bit| 31:0  |
|----|-------|
|機能| OSADR|

- OSADR:出力データの先頭アドレス

## OFSIZE 
出力データのフレームサイズ

| bit| 31:0  |
|----|-------|
|機能| OFSIZE |

- OFSIZE:出力データのフレームサイズ

## LRELU 
LeakyRELUの係数

| bit| 31:0  |
|----|-------|
|機能| LRELU |

- LRELU:LeakyRELUの係数, float32

## FNSIZE
fとnのサイズ指定  

| bit| 31:16 |15:0|
|----|-------|-----|
|機能| FSIZE | NSIZE |

- NSIZE:入力チャネル数(n)  
- FSIZE:フィルター数(f)

## DEBCNT0
デバッグ用カウンター  

| bit| 31:0|
|----|-----
|機能| DEBCNT0 |

- DEBCNT0: 処理サイクル数測定用カウンター(下位32bit)。ソフトリセットでクリアー。read only。

## DEBCNT1
デバッグ用カウンター  

| bit| 31:0|
|----|-----
|機能| DEBCNT1 |

- DEBCNT1: 処理サイクル数測定用カウンター(上位2bit)。ソフトリセットでクリアー。read only。

# ソフトウェア設定例



# リファレンス


