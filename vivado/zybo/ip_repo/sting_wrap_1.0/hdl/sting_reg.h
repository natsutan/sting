// sting 用レジスタ設定ファイル
//
`define REG_CTRL     8'h00
`define REG_STATUS   8'h04
`define REG_MODE     8'h08
`define REG_IXSIZE   8'h0C
`define REG_IYSIZE   8'h10
`define REG_ISADR    8'h14
`define REG_IFSIZE   8'h18
`define REG_WSADR1   8'h1C
`define REG_WSADR2   8'h20
`define REG_OXSIZE   8'h24
`define REG_OSADR    8'h28
`define REG_OFSIZE   8'h2C
`define REG_LRELU    8'h30
`define REG_FNSIZE   8'h34
`define REG_DEBCNT0  8'h38
`define REG_DEBCNT1  8'h3C

`define REG_CTRL_RESET 32'h00000001
`define REG_CTRL_RUN 32'h00000002

`define REG_MODE_DIVMODE 32'h00000001
`define REG_MODE_BNEN    32'h00000002
`define REG_MODE_LRELUEN 32'h00000004

