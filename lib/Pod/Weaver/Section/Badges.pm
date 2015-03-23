use 5.14.0;
use Moops;
use strict;
use warnings;

# PODCLASSNAME

package #
        Pod::Weaver::Section::Badges::PluginSearcher {

    use Moose;
    use Module::Pluggable search_path => ['Badge::Depot::Plugin'], require => 1;
}

class Pod::Weaver::Section::Badges 
 with Pod::Weaver::Role::Section
 with Pod::Weaver::Role::AddTextToSection
 with Pod::Weaver::Section::Badges::Utils
using Moose {

    # VERSION
    # ABSTRACT: Add (or append) a section with badges
    use MooseX::AttributeDocumented;
    #use Pod::Weaver::Section::Name::WithBadges::PluginSearcher;
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

    has badge => (
        is => 'ro',
        isa => ArrayRef[Str],
        traits => ['Array'],
        default => sub { [] },
        handles => {
            all_badges => 'elements',
            find_badge => 'first',
            count_badges => 'count',
        },
        documentation => q{The name of the wanted badge, lowercased. Repeat for multiple badges. The name is everything after 'Badge::Depot::Plugin::'.},
        documentation_default => '[]',
    );
    has section => (
        is => 'ro',
        isa => Str,
        default => 'NAME',
        documentation => q{The section of pod to add the badges to, identified by its heading. The section will be created if it doesn't already exist.},
    );
    has formats => (
        is => 'ro',
        isa => ArrayRef[Enum[qw/html markdown/]],
        traits => ['Array'],
        required => 1,
        handles => {
            all_formats => 'elements',
            find_format => 'first',
            has_formats => 'count',
        },
        documentation => q{The formats to render the badges for. Comma separated list, not multiple rows.},
        documentation_default => '[]',
    );
    has badge_args => (
        is => 'ro',
        isa => HashRef[Str],
        default => sub { {} },
        traits => ['Hash'],
        handles => {
            badge_args_kv => 'kv',
        },
        documentation_default => '{}',
        documentation => q{badge_args is not a usable attribute in itself: All settings for badge plugins start with a dash, followed by the badge name (lowercased) and an underscore. If the badge plugin is Badge::Depot::Plugin::Travis, then all settings start with '-travis_'.},
    );
    has plugin_searcher => (
        is => 'ro',
        isa => Any,
        init_arg => undef,
        default => sub { Pod::Weaver::Section::Badges::PluginSearcher->new },
        documentation_order => 0,
    );
    has main_module_only => (
        is => 'ro',
        isa => Bool,
        default => 1,
        documentation => 'If true, the badges will only be inserted in the main module (as defined by Dist::Zilla). If false, they will be included in all modules.',
    );
    

    around BUILDARGS($next: $class, $args) {
        $args->{'formats'} = exists $args->{'formats'} ? [ split /, ?/ => $args->{'formats'} ] : [];
        $args->{'badge_args'} = { map { $_ => delete $args->{ $_  } } grep { /^-/ } keys %$args };

        $class->$next($args);
    }

    method weave_section($document, $input) {
        return if $self->main_module_only && $input->{'filename'} ne $input->{'zilla'}->main_module->name;

        my $badge_objects = $self->create_badges;
        return if !scalar @$badge_objects;

        if(!$self->has_formats) {
            $self->log(['!!! No formats defined in weaver.ini, no badges to create.']);
        }

        my $formats = [
            {
                name => 'html',
                before => '<p>',
                after => '</p>',
            },
            {
                name => 'markdown',
                before => undef,
                after => undef,
            }
        ];

        my @output = ();
        foreach my $format (@$formats) {
            push @output => @{ $self->render_badges($format, $badge_objects) };
        }

        if(scalar @output) {
            my $output = join "\n" => '', @output, '';

            $self->add_text_to_section($document, $output, $self->section);
        }
    }
    method log_debug($text) {
        # silence Pod::Weaver::Role::AddTextToSection
    }
}

1;

__END__
=pod

:splint classname Pod::Weaver::Section::Badges

=head1 SYNOPSIS

    ; in weaver.ini
    [Badges]
    section = BUILD STATUS
    formats = html
    badge = Travis
    badge = Gratipay
    -travis_user = MyGithubUser
    -travis_repo = the_repository
    -travis_branch = master
    -gratipay_user = ExampleName
    
=head1 DESCRIPTION

This inserts a section with status badges. The configuration in the synopsis would produce something similar to this:

    =head1 BUILD STATUS

    =begin HTML

    <p>
        <a href="https://travis-ci.org/MyGithubUser/the_repository"><img src="https://travis-ci.org/MyGithubUser/the_repository.svg?branch=master" /></a>
        <img src="https://img.shields.io/gratipay/ExampleName.svg" />
    </p>

    =end HTML

This module uses badges in the C<Badge::Depot::Plugin> namespace. See L<Task::Badge::Depot> for a list of available badges.
The synopsis uses the L<Badge::Depot::Plugin::Travis> and L<Badge::Depot::Plugin::Gratipay> badges.

=head1 ATTRIBUTES

:splint attributes

=head1 SEE ALSO

=for :list
* L<Task::Badge::Depot>
* L<Badge::Depot>

=head1 BADGES

=begin HTML

<p>
    <img src="https://img.shields.io/badge/perl-5.14+-brightgreen.svg" />
    <a href="https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges"><img src="https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master" /></a>
</p>

=end HTML

=begin markdown

    ![](https://img.shields.io/badge/perl-5.14+-brightgreen.svg)
    [![](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master)](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges)

=end markdown

=cut
