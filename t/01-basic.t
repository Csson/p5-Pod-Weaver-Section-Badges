use strict;
use warnings;

use Test::More;
use Test::Differences;
use PPI;
use Pod::Elemental;
use Pod::Weaver;
use Dist::Zilla::Tester;
use Path::Tiny;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

BEGIN {
    use_ok 'Pod::Weaver::Section::Badges';
}


my $zilla = Dist::Zilla::Tester->from_config({ dist_root => 't/corpus/01' });
$zilla->build;

unified_diff;
eq_or_diff path($zilla->tempdir->subdir('build'))->child(qw/lib TesterFor Badges.pm/)->slurp_utf8, expected(), 'Section added to pod';

done_testing;

sub expected {
    return qq{package TesterFor::Badges;

# ABSTRACT: A tester

1;

__END__

=pod

=head1 BUILD & GRATITUDE

=begin HTML

<p><a href="https://travis-ci.org/Csson/p5-test-mojo-trim"><img src="https://travis-ci.org/Csson/p5-test-mojo-trim.svg?branch=master" /></a> <a href="https://gratipay.com/TestName"><img src="https://img.shields.io/gratipay/p5-test-mojo-trim/TestName.svg" /></a> <img src="https://img.shields.io/gratipay/p5-test-mojo-trim/TestName.svg" /></p>

=end HTML

=cut
};
}