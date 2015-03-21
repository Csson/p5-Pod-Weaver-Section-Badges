use strict;
use warnings;

use Test::More;
use Test::Differences;
use PPI;
use Pod::Elemental;
use Pod::Weaver;
#use Dist::Zilla::Tester;
use Test::DZil;
use Path::Tiny;
use syntax 'qs';
use Carp::Always;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

BEGIN {
    use_ok 'Pod::Weaver::Section::Badges';
}

ok 1, 'After begin...';
use lib path('t/corpus/01/lib')->absolute->stringify;

ok 2, 'After use lib';

my $zilla = get_builder();

ok 1, 'Before build';
$zilla->chrome->logger->set_debug(1);
use Data::Dump::Streamer;
diag Dump($zilla);

$zilla->build;

ok 1, 'After build';

my $slurped = path($zilla->tempdir->subdir('build'))->child(qw/lib Tester.pm/)->slurp_utf8;

diag $slurped;

done_testing;


sub get_builder {
    return Builder->from_config(
        { dist_root => 't/non-existing' },
        {
            add_files => {
                path(qw/source dist.ini/) => simple_ini(
                    [ GatherDir => ],
                    [ PodWeaver => ],
                ),
                path(qw/source weaver.ini/) => qs{
                    [@CorePrep]

                    [Badges]
                    section = NAME
                    badge = thisisatestplugin
                    badge = anothertestplugin
                    formats = html
                    main_module_only = 0
                    -thisisatestplugin_user = Csson
                    -thisisatestplugin_repo = p5-test-mojo-trim
                    -anothertestplugin_user = Csson
                    -anothertestplugin_repo = p5-pod-weaver-section-badges
                },
                path(qw/source lib Tester.pm/) => qs{
                    =pod

                    =head1 NAME

                    Tester

                    =cut
                },
            },
        },
    );
}