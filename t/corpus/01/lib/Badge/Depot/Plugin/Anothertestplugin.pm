use 5.14.0;
use strict;
use warnings;
use Moops;

# PODNAME: Badge::Depot::Plugin::Anothertestplugin

class Badge::Depot::Plugin::Anothertestplugin using Moose with Badge::Depot {

    # VERSION

    has user => (
        is => 'ro',
        isa => Str,
    );
    has repo => (
        is => 'ro',
        isa => Str,
    );
    
    method BUILD {
        $self->link_url(sprintf 'https://example.org/%s/%s' => $self->user, $self->repo);
        $self->image_url(sprintf 'https://example.org/%s/%s.svg' => $self->user, $self->repo);
    }
}

1;
