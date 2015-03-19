use 5.14.0;
use strict;
use warnings;
use Moops;

# VERSION
# PODCLASSNAME

role Pod::Weaver::Section::Badges::Utils using Moose {

    use List::AllUtils 'first';

    method get_params_for(Str $badgename) {
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

    method badge_to_class(Str $badge_name --> Str but assumed) {
        return sprintf 'Badge::Depot::Plugin::%s', ucfirst $badge_name;
    }

    method create_badges(--> ArrayRef[ ConsumerOf['Badge::Depot'] ] but assumed) {

        my @all_plugins = $self->plugin_searcher->plugins;
        my @badge_objects = ();

        BADGE:
        foreach my $badge ($self->all_badges) {
            my $wanted_plugin_class = $self->badge_to_class($badge);
            my $plugin_class = first { $_ eq $wanted_plugin_class } @all_plugins;

            next BADGE if !defined $plugin_class;
            my $plugin = $plugin_class->new($self->get_params_for(lc $badge));

            if(!$plugin->DOES('Badge::Depot')) {
                warn sprintf '! %s does not consume the Badge::Depot role', $plugin_class;
                next BADGE;
            }
            push @badge_objects => $plugin;
        }
        return \@badge_objects;
    }

    method render_badges(Dict[ name => Str, before => Maybe[Str], after => Maybe[Str] ] $format,
                         ArrayRef[ ConsumerOf['Badge::Depot'] ] $badges
                     --> Str but assumed
    ) {

        my $part_format_name = $format->{'name'} eq 'markdown' ? 'markdown' : uc $format->{'name'};

        my $pod_command_begin = sprintf '=begin %s', $part_format_name;
        my $pod_command_end   = sprintf '=end %s', $part_format_name;
        my $format_method = sprintf 'to_%s', $format->{'name'};

        my @badges_output = ();
        my @complete_output = ();

        if($self->find_format(sub { $_ eq $format->{'name'} })) {
            push @badges_output => $_->$format_method foreach (@$badges);

        }
        if(@badges_output) {
            push @complete_output => '', $pod_command_begin, '', ;
            push @complete_output => ($format->{'before'} || '') . join (' ' => @badges_output) . ($format->{'after'} || '');
            push @complete_output => '', $pod_command_end, ''; 
        }
        return \@complete_output;
    }
}

1;
