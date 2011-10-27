#!perl

use Test::More;
use strict;
use FindBin qw($Bin);
use English qw( -no_match_vars );

require "$Bin/helper.pl";

my $file_slurp_available = load_mod('File::Slurp qw(read_file)');

my $profile_filename = ( lc($OSNAME) eq 'darwin' ) ? '.profile' : '.bashrc';

subtest 'simplest' => sub {
    my ( $home, $repo, $origin ) = minimum_home('simple');
    my ( $home, $repo ) = minimum_home( 'simple2', $origin );
    my $output = `HOME=$home perl $repo/bin/dfm --verbose`;

    ok( -d "$home/.backup",      'main backup dir exists' );
    ok( -l "$home/bin",          'bin is a symlink' );
    ok( !-e "$home/.git",        ".git does not exist in \$home" );
    ok( !-e "$home/.gitignore",  '.gitignore does not exist' );
    ok( !-e "$home/.dfminstall", '.dfminstall does not exist' );
    is( readlink("$home/bin"), '.dotfiles/bin', 'bin points into repo' );

SKIP: {
        skip 'File::Slurp not found', 1 unless $file_slurp_available;

        ok( read_file("$home/$profile_filename") =~ /bashrc.load/,
            "loader present in $profile_filename" );
    }

    ok( !-e "$home/README.md", 'no README.md in homedir' );
    ok( !-e "$home/t",         'no t dir in homedir' );
};

subtest 'dangling symlinks' => sub {
    my ( $home, $repo ) = minimum_home_with_ssh('dangling');

    symlink( ".dotfiles/.other",         "$home/.other" );
    symlink( "../.dotfiles/.ssh/.other", "$home/.ssh/.other" );

    my $output = `HOME=$home perl $repo/bin/dfm --verbose`;

    ok( !-l "$home/.other",      'dangling symlink is gone' );
    ok( !-l "$home/.ssh/.other", 'dangling symlink is gone' );
};

subtest 'with . ssh recurse( no . ssh dir )' => sub {

    my ( $home, $repo ) = minimum_home_with_ssh( 'ssh_no', 1 );
    my $output = `HOME=$home perl $repo/bin/dfm --verbose`;

    check_ssh_recurse($home);
};

subtest 'with .ssh recurse (with .ssh dir)' => sub {

    my ( $home, $repo ) = minimum_home_with_ssh('ssh_with');
    my $output = `HOME=$home perl $repo/bin/dfm --verbose`;

    check_ssh_recurse($home);
};

done_testing;

sub check_ssh_recurse {
    my ($home) = @_;
    ok( -d "$home/.backup",          'main backup dir exists' );
    ok( -l "$home/bin",              'bin is a symlink' );
    ok( !-e "$home/.git",            '.git does not exist in $home' );
    ok( !-e "$home/.gitignore",      '.gitignore does not exist' );
    ok( !-e "$home/.dfminstall",     '.dfminstall does not exist' );
    ok( !-l "$home/.ssh",            '.ssh is not a symlink' );
    ok( !-e "$home/.ssh/.gitignore", '.ssh/.gitignore does not exist' );
    is( readlink("$home/bin"), '.dotfiles/bin', 'bin points into repo' );
    ok( -d "$home/.ssh/.backup", 'ssh backup dir exists' );

SKIP: {
        skip 'File::Slurp not found', 1 unless $file_slurp_available;

        ok( read_file("$home/$profile_filename") =~ /bashrc.load/,
            "loader present in $profile_filename" );
    }

    ok( !-e "$home/README.md", 'no README.md in homedir' );
    ok( !-e "$home/t",         'no t dir in homedir' );
}
