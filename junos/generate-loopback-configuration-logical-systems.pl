#!/usr/bin/perl

use strict;
use warnings;

# コマンドライン引数を配列に格納
my @logical_systems = split(',', $ARGV[0]);

# 初期IPアドレス
my @base_ip = ('192', '168', '0');
my $ip = 1;
my $unit = 0;
# 各論理システムに対して設定を生成

foreach my $system (@logical_systems) {
    # IPアドレスを組み立て
    my $full_ip = join('.', @base_ip, $ip);
    
    print "set logical-systems $system interfaces lo0 unit $unit family inet address $full_ip/32\n";
    
    # 4オクテット目をインクリメント
    $ip++;
    $unit++;
}
