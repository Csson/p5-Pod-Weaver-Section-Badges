use 5.14.0;
use strict;
use warnings;
use Moops;

class Pod::Weaver::Section::Badges::For::Atestpluginwedontwant using Moose with Pod::Weaver::Section::Badges::Badge {

    has user => (
        is => 'ro',
        isa => Str,
    );
    has repo => (
        is => 'ro',
        isa => Str,
    );
    
    method create_badge {
        my $a_href = 'https://example.com/%s/%s';
        my $img_href = 'https://example.com/%s/%s.svg';

        my $link = sprintf $a_href => $self->user, $self->repo;
        my $img = sprintf $img_href => $self->user, $self->repo;

        return sprintf qq{<a href="%s"><img src="%s" /></a>} => $link, $img;
    }
    
}

1;
