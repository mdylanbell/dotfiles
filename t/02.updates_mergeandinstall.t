#!perl

use Test::More;
use strict;
use FindBin qw($Bin);
use English qw( -no_match_vars );

require "$Bin/helper.pl";

my $file_slurp_available = load_mod('File::Slurp qw(read_file)');

my $profile_filename = ( lc($OSNAME) eq 'darwin' ) ? '.profile' : '.bashrc';

subtest 'updates and mergeandinstall' => sub {
    my ( $home, $repo, $origin ) = minimum_home('host1');
    my ( $home2, $repo2 ) = minimum_home( 'host2', $origin );

    add_file_and_push( $home, $repo );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    # remove the origin repo, to make sure that --no-fetch
    # still works (because the updates are already local,
    # --no-fetch doesn't refetch)
    `rm -rf $origin`;
    $output
        = `HOME=$home2 perl $repo2/bin/dfm updates --no-fetch 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/\.testfile/, 'message in output' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );
};

subtest 'modifications in two repos, rebase' => sub {
    my ( $home, $repo, $origin ) = minimum_home('host1_rebase');
    my ( $home2, $repo2 ) = minimum_home( 'host2_rebase', $origin );

    add_file_and_push( $home, $repo );
    add_file( $home2, $repo2, '.otherfile' );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;

    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/local changes detected/, 'conflict message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is still not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi --rebase 2> /dev/null`;
    like(
        $output,
        qr/rewinding head to replay/,
        'git rebase info message seen'
    );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );

    $output = `HOME=$home2 perl $repo2/bin/dfm log 2> /dev/null`;
    unlike(
        $output,
        qr/Merge remote-tracking branch 'origin\/master'/,
        'no git merge log message seen'
    );
};

subtest 'modifications in two repos, merge' => sub {
    my ( $home, $repo, $origin ) = minimum_home('host1_merge');
    my ( $home2, $repo2 ) = minimum_home( 'host2_merge', $origin );

    add_file_and_push( $home, $repo );
    add_file( $home2, $repo2, '.otherfile' );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;

    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/local changes detected/, 'conflict message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is still not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi --merge 2> /dev/null`;
    like(
        $output,
        qr/Merge made by recursive/,
        'git merge info message seen'
    );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );

    $output = `HOME=$home2 perl $repo2/bin/dfm log 2> /dev/null`;
    like(
        $output,
        qr/Merge remote-tracking branch 'origin\/master'/,
        'git merge log message seen'
    );
};

subtest 'umi' => sub {
    my ( $home, $repo, $origin ) = minimum_home('host1');
    my ( $home2, $repo2 ) = minimum_home( 'host2', $origin );

    add_file_and_push( $home, $repo );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm umi 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    like( $output, qr/\.testfile/,        'message in output' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );
};

done_testing;

sub add_file_and_push {
    my $home = shift || die;
    my $repo = shift || die;
    my $filename = shift;
    my $contents = shift;

    add_file( $home, $repo, $filename, $contents );

    chdir($home);
    `HOME=$home perl $repo/bin/dfm push origin master 2> /dev/null`;
    chdir($Bin);
}

sub add_file {
    my $home     = shift || die;
    my $repo     = shift || die;
    my $filename = shift || '.testfile';
    my $contents = shift || 'contents';

    chdir($home);
    `echo '$contents' > $filename`;
    `mv $filename $repo/$filename`;
    `HOME=$home perl $repo/bin/dfm add $filename`;
    `HOME=$home perl $repo/bin/dfm commit -m 'adding $filename'`;
    chdir($Bin);
}
