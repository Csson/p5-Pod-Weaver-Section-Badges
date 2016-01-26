use 5.10.1;
use strict;
use warnings;

package Badge::Depot::Plugin::Anothertestplugin;

# VERSION

use Moose;
use Types::Standard qw/Str/;
with 'Badge::Depot';

has user => (
    is => 'ro',
    isa => Str,
);
has repo => (
    is => 'ro',
    isa => Str,
);
    
sub BUILD {
    my $self = shift;
    $self->link_url(sprintf 'https://example.org/%s/%s' => $self->user, $self->repo);
    $self->image_url(sprintf 'https://example.org/%s/%s.svg' => $self->user, $self->repo);
}

1;
