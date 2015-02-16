use 5.14.0;
use strict;
use warnings;
use Moops;

# VERSION
# PODCLASSNAME

role Pod::Weaver::Section::Badges::Utils using Moose {

    method get_params_for(Str $badgename) {
        my $params = {};

        foreach my $pair ($self->extras_kv) {
            my($key, $value) = @$pair;

            # -pluginname_* -> *
            my $key_for_plugin = $key;
            $key_for_plugin =~ s{^-${badgename}_}{};

            $params->{ $key_for_plugin } = $value if substr($key, 0, 2 + length $badgename) eq sprintf '-%s_' => lc $badgename;
        }
        return %{ $params };
    }
    method badge_to_class(Str $badge_name --> Str but assumed) {
    	return sprintf 'Pod::Weaver::Section::Badges::For::%s', ucfirst $badge_name;
    }
}

1;
