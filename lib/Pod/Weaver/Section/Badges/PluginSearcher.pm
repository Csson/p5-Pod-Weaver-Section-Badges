use 5.10.0;
use strict;
use warnings;

package Pod::Weaver::Section::Badges::PluginSearcher;

# AUTHORITY
our $VERSION = '0.0403';

use Moose;
use Module::Pluggable search_path => ['Badge::Depot::Plugin'], require => 1;

1;
