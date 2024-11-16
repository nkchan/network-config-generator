#!/usr/bin/perl
use strict;
use warnings;

# コマンドライン引数からファイル名を取得
my $input_file = shift or die "Usage: $0 <input_file>\n";

# 192.168.10.X のアドレスを生成するための初期値
my $base_ip = 1;

# ファイルを開く
open my $fh, '<', $input_file or die "Cannot open file '$input_file': $!\n";

# 各行を処理
my $unit = 0; # ユニット番号のカウンタ
while (my $line = <$fh>) {
    chomp $line;

    # 行を解析
    if ($line =~ /^link=(\S+),(\S+)$/) {
        my ($sys1, $sys2) = ($1, $2);

        # IPアドレスを生成
        my $ip1 = "192.168.10." . $base_ip;
        my $ip2 = "192.168.10." . ($base_ip + 1);

        # 出力を生成
        print "set logical-systems $sys1 interfaces lt-0/0/10 unit $unit description \"$sys1 to $sys2\"\n";
        print "set logical-systems $sys1 interfaces lt-0/0/10 unit $unit encapsulation ethernet\n";
        print "set logical-systems $sys1 interfaces lt-0/0/10 unit $unit peer-unit " . ($unit + 1) . "\n";
        print "set logical-systems $sys1 interfaces lt-0/0/10 unit $unit family inet address $ip1/30\n";
        print "set logical-systems $sys2 interfaces lt-0/0/10 unit " . ($unit + 1) . " description \"$sys2 to $sys1\"\n";
        print "set logical-systems $sys2 interfaces lt-0/0/10 unit " . ($unit + 1) . " encapsulation ethernet\n";
        print "set logical-systems $sys2 interfaces lt-0/0/10 unit " . ($unit + 1) . " peer-unit $unit\n";
        print "set logical-systems $sys2 interfaces lt-0/0/10 unit " . ($unit + 1) . " family inet address $ip2/30\n";
        print "\n";
        # 次のリンクに備えてカウンタとIPアドレスを進める
        $unit += 2;  # ユニット番号はペアで増加
        $base_ip += 4; # IPアドレスを次の範囲に進める
    } else {
        # 不正な行を警告し、その行を表示
        warn "Skipped invalid line: $line\n";
    }
}

# ファイルを閉じる
close $fh;
