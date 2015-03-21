use strict;
use warnings;

use Test::More;
use Test::Differences;
use PPI;
use Pod::Elemental;
use Pod::Weaver;
#use Dist::Zilla::Tester;
#use Test::DZil;
use Path::Tiny;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

BEGIN {
    use_ok 'Pod::Weaver::Section::Badges';
}

ok 1, 'After begin';
#use lib path('t/corpus/01/lib')->absolute->stringify;
#
#ok 2, 'After use lib';
#
##my $zilla = Dist::Zilla::Tester->from_config({ dist_root => 't/corpus/01' });
#my $zilla = Builder->from_config(
#    { dist_root => 't/non-existing' },
#    {
#        add_files => {
#            path(qw/source )
#        }
#    }
#);
#
#ok 2, 'After making Dzil tester';
#
##$zilla->build;
#
#ok 3, 'Zilla is built';
#
#my $slurped = path($zilla->tempdir->subdir('build'))->child(qw/lib TesterFor Badges.pm/)->slurp_utf8;
#
#ok 4, 'Output is slurped';
#
#unified_diff;
#eq_or_diff $slurped, expected(), 'Section added to pod';
#
#diag $slurped;
#
done_testing;

sub expected {
    return qq{use 5.14.0;
use strict;
use warnings;
use Moops;

# ABSTRACT: A tester

class TesterFor::Badges using Moose with Pod::Weaver::Section::Badges::Utils {
    has badge_args => (
        is => 'ro',
        isa => HashRef[Str],
        default => sub { {} },
        traits => ['Hash'],
        handles => {
            badge_args_kv => 'kv',
        },
    );
}

1;

__END__

=pod

=head1 BUILD & STUFF



=begin HTML

<p><a href="https://example.org/Csson/p5-pod-weaver-section-badges"><img src="https://example.org/Csson/p5-pod-weaver-section-badges.svg" /></a> <a href="https://example.com/Csson/p5-test-mojo-trim"><img src="https://example.com/Csson/p5-test-mojo-trim.svg" /></a></p>

=end HTML

=cut
};
}