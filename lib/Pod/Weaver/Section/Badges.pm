use 5.14.0;
use strict;
use warnings;
use Moops;

# PODCLASSNAME

package Pod::Weaver::Section::Badges::PluginSearcher {
    use Moose;
    use Module::Pluggable search_path => ['Pod::Weaver::Section::Badges::For'], require => 1;
}

class Pod::Weaver::Section::Badges using Moose with Pod::Weaver::Role::Section with Pod::Weaver::Section::Badges::Utils {

    # VERSION
    # ABSTRACT: Insert badges in your pod
    use MooseX::AttributeDocumented;
    use Pod::Weaver::Section::Badges::PluginSearcher;
    use List::AllUtils 'first';

    sub mvp_multivalue_args { qw/badge/ }

    has +weaver => (
        is => 'ro',
        documentation_order => 0,
    );
    has +logger => (
        is => 'ro',
        documentation_order => 0,
    );
    has +plugin_name => (
        is => 'ro',
        documentation_order => 0,
    );
    has heading => (
        is => 'ro',
        isa => Str,
        default => 'BADGES',
        documentation => 'The heading under which the badges are added.',
    );
    has command => (
        is => 'ro',
        isa => Str,
        default => 'head1',
        documentation => 'Heading level.',
    );
    has badge => (
        is => 'ro',
        isa => ArrayRef[Str],
        traits => ['Array'],
        default => sub { [] },
        handles => {
            all_badges => 'elements',
            find_badge => 'first',
        },
        documentation => q{The name of the wanted badge, lowercased. Repeat for multiple badges.},
        documentation_default => '[]',
    );
    has extras => (
        is => 'ro',
        isa => HashRef[Str],
        default => sub { {} },
        traits => ['Hash'],
        handles => {
            extras_kv => 'kv',
        },
        documentation_default => '{}',
        documentation => q{All settings for badge plugins start with a dash, followed by the badge name and an underscore. If the badge plugin is Pod::Weaver::Section::Badges::For::Travis, then all settings for that badge start with '-travis_'.},
    );

    around BUILDARGS($next: $class, $args) {
        $args->{'extras'} = { map { $_ => delete $args->{ $_  } } grep { /^-/ } keys %$args };
        $class->$next($args);
    }

    method weave_section($document, @unused) {
        my @badge_html = ();

        my @all_plugins = Pod::Weaver::Section::Badges::PluginSearcher->new->plugins;

        BADGE:
        foreach my $badge ($self->all_badges) {
            my $wanted_plugin_class = $self->badge_to_class($badge);

            my $plugin_class = first { $_ eq $wanted_plugin_class } @all_plugins;
            next BADGE if !defined $plugin_class;

            my $plugin = $plugin_class->new($self->get_params_for($badge));

            if(!$plugin->DOES('Pod::Weaver::Section::Badges::Badge')) {
                warn sprintf '! %s does not consume the Pod::Weaver::Section::Badges::Badge role', $plugin_class;
                next BADGE;
            }

            push @badge_html => $plugin->create_badge;
        }

        if(scalar @badge_html) {
            my $output = join "\n" => '=begin HTML', '',  '<p>' . join (' ' => @badge_html) . '</p>', '', '=end HTML', '';

            push @{ $document->children } =>
                Pod::Elemental::Element::Nested->new(
                    command => $self->command,
                    content => $self->heading,
                    children => [ Pod::Elemental::Element::Pod5::Ordinary->new({ content => $output }) ],
                );
        }
    }


}

1;


__END__

=pod

:splint classname Pod::Weaver::Section::Badges

=head1 SYNOPSIS

    ; in weaver.ini
    [Badges]
    heading = BUILD STATUS
    command = head1
    user = MyGithubUser
    repo = the_repository
    branch = master
    badges = travis
    badges = http://www.example.com/img/<repo>.jpg | http://www.example.com/repos/<repo>
    badges = https://img.shields.io/gratipay/<gratipay_user>.svg
    -gratipay_user = ExampleName

=head1 DESCRIPTION

This inserts a section with status badges. The configuration in the synopsis would produce something similar to this:

    =head1 BUILD STATUS

    =begin HTML

    <p>
        <a href="https://travis-ci.org/MyGithubUser/the_repository"><img src="https://travis-ci.org/MyGithubUser/the_repository.svg?branch=master" /></a>
        <a href="http://www.example.com/repos/the_repository"><img src="http://www.example.com/img/the_repository.jpg" /></a>
        <img src="https://img.shields.io/gratipay/the_repository/ExampleName.svg" />
    </p>

    =end HTML

=head1 ATTRIBUTES

:splint attributes

=head1 NOTE

Planned api changes: Badges will in the near future be created as plugins to this class.

=head1 SEE ALSO

=for :list
* L<Dist::Zilla::Plugin::TravisCI::StatusBadge>

=head1 BUILD STATUS

=for HTML <p><a href="https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges"><img src="https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master" /></a></p>

=cut
