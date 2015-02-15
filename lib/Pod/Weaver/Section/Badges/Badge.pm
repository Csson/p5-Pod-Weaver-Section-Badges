use 5.14.0;
use strict;
use warnings;
use Moops;

# PODCLASSNAME

role Pod::Weaver::Section::Badges::Badge using Moose {

    # VERSION

    requires 'create_badge';
}

1;
