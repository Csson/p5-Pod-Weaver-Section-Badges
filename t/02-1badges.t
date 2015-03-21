use strict;
use warnings;

use Test::More;
use Test::Differences;
use Dist::Zilla::Tester;
use FindBin;
use File::pushd;
use Path::Tiny;
use Pod::Elemental;
use Pod::Weaver;
use syntax 'qi';
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/corpus/01/lib";

my $zilla = Dist::Zilla::Tester->from_config({
    dist_root => path($FindBin::Bin, qw/corpus 01/)->stringify,
});

ok 1, 'Zilla configured';

$zilla->build;

ok 1, 'Zilla built';

my $pushed = pushd($zilla->tempdir->subdir('build'));
my $content = path(qw/lib TesterFor Badges.pm/)->slurp;

eq_or_diff $content, expected_content(), 'Rendered expectedly';

done_testing;

sub expected_content {
    return qi{        use 5.14.0;
        use strict;
        use warnings;
        use Moops;
        
        # PODNAME: TesterFor::Badges
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
        
        =head1 NAME
        
        TesterFor::Badges - A tester
        
        
        
        =begin HTML
        
        <p><a href="https://example.com/Csson/p5-test-mojo-trim"><img src="https://example.com/Csson/p5-test-mojo-trim.svg" /></a></p>
        
        =end HTML
        
        =head1 COPYRIGHT AND LICENSE
        
        This software is copyright (c) 2015 by Any One.
        
        This is free software; you can redistribute it and/or modify it under
        the same terms as the Perl 5 programming language system itself.
        
        =cut
};
}
__END__

