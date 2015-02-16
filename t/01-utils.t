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
use lib path('t/corpus/01/lib')->absolute->stringify;

BEGIN {
    use_ok 'Pod::Weaver::Section::Badges::Utils';
}

use TesterFor::Badges;

my $tester_for = TesterFor::Badges->new(extras => { -gratipay_option => 'thevalue' });

is_deeply $tester_for->extras, { -gratipay_option => 'thevalue' }, 'Got correct extras hash' or diag('extras is: ', explain($tester_for->extras));

is $tester_for->badge_to_class('gratipay'), 'Pod::Weaver::Section::Badges::For::Gratipay', 'Got correct class name';

is_deeply { $tester_for->get_params_for('gratipay') }, { option => 'thevalue' },  'Got correct settings';

done_testing();
