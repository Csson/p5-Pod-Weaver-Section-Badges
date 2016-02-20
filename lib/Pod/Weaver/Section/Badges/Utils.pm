use 5.10.0;
use strict;
use warnings;

package Pod::Weaver::Section::Badges::Utils;

# ABSTRACT: Some helpers
# AUTHORITY
our $VERSION = '0.0403';

use Moose::Role;
use List::Util 'first';

sub get_params_for {
    my $self = shift;
    my $badgename = shift; # Str
    my $params = {};

    foreach my $pair ($self->badge_args_kv) {
        my($key, $value) = @$pair;

        # -pluginname_* -> *
        my $key_for_plugin = $key;
        $key_for_plugin =~ s{^-${badgename}_}{};

        $params->{ $key_for_plugin } = $value if substr($key, 0, 2 + length $badgename) eq sprintf '-%s_' => $badgename;
    }
    return %{ $params };
}

sub badge_to_class {
    my $self = shift;
    my $badge_name = shift; # Str
    return sprintf 'Badge::Depot::Plugin::%s', ucfirst $badge_name;
}

sub create_badges {
    my $self = shift;
    my $badges_args = shift || {};

    my @all_plugins = $self->plugin_searcher->plugins;
    my @badge_objects = ();

    BADGE:
    foreach my $badge ($self->all_badges) {
        my $wanted_plugin_class = $self->badge_to_class($badge);
        my $plugin_class = first { $_ eq $wanted_plugin_class } @all_plugins;

        next BADGE if !defined $plugin_class;
        my $plugin = $plugin_class->new($self->get_params_for(lc $badge), %{ $badges_args });

        if(!$plugin->DOES('Badge::Depot')) {
            warn sprintf '! %s does not consume the Badge::Depot role', $plugin_class;
            next BADGE;
        }
        push @badge_objects => $plugin;
    }
    return \@badge_objects; # ArrayRef[ ConsumerOf['Badge::Depot'] ]
}

sub render_badges {
    my $self = shift;
    my $format = shift;  # Dict[ name => Str, before => Maybe[Str], after => Maybe[Str] ]
    my $badges = shift;  # ArrayRef[ ConsumerOf['Badge::Depot'] ]

    my $pod_command_begin = sprintf '=begin %s', $format->{'name'};
    my $pod_command_end   = sprintf '=end %s', $format->{'name'};
    my $format_method = sprintf 'to_%s', $format->{'name'};

    my @badges_output = ();
    my @complete_output = ();

    if($self->find_format(sub { $_ eq $format->{'name'} })) {
        push @badges_output => grep { defined $_ && length $_ } $_->$format_method foreach (@$badges);

    }
    if(@badges_output) {
        push @complete_output => '', $pod_command_begin, '', ;
        push @complete_output => (($format->{'before'} || ''), join ("\n" => @badges_output), ($format->{'after'} || ''));
        push @complete_output => '', $pod_command_end, '';
    }
    return \@complete_output;
}


1;
