use 5.14.0;
use strict;
use warnings;
use Moops;

# PODCLASSNAME

class Pod::Weaver::Section::Badges using Moose with Pod::Weaver::Role::Section {

    # VERSION
    # ABSTRACT: Insert badges in your pod
    use MooseX::AttributeDocumented;

    sub mvp_multivalue_args { qw/badges/ }


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
    has badges => (
        is => 'ro',
        isa => ArrayRef[Str],
        default => sub { [] },
        traits => ['Array'],
        handles => {
            all_badges => 'elements',
        },
        documentation_default => '[]',
        documentation_alts => {
            travis => 'Support for travis is built-in.',
            "'img_url' | 'link_url'" => q{Custom badges are created with a pipe-delimited string.},
        },
        documentation => q{The list of badges to create. This can either the name of a built-in badge (so far only travis) or a pipe-delimited string.
                            The first value is the url for the badge, the second an optional url to make the badge clickable. Both urls take placeholders
                            in the form of '&lt;placeholder&gt;' (without the quotes). See 'extras' for how to set them in weaver.ini.},
    );
    has user => (
        is => 'ro',
        isa => Str,
        predicate => 1,
        documentation => q{For use with the travis badge. Your github username. To use with custom badges, use '&lt;user&gt;' in badge urls.},
    );
    has repo => (
        is => 'ro',
        isa => Str,
        predicate => 1,
        documentation => q{For use with the travis badge. The github repository. To use with custom badges, use '&lt;repo&gt;' in badge urls.},
    );
    has branch => (
        is => 'ro',
        isa => Str,
        predicate => 1,
        documentation => q{For use with the travis badge. The github branch.  To use with custom badges, use '&lt;branch&gt;' in badge urls.},
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
        documentation => q{Custom settings for custom badges: Use any setting starting with a dash, in the badge urls those are replaced with the value given here. See 'badges' for how to define custom badges.},
    );

    around BUILDARGS($next: $class, $args) {
        $args->{'extras'} = { map { $_ => delete $args->{ $_  } } grep { /^-/ } keys %$args };

        $class->$next($args);
    }

    method weave_section($document, @unused) {
        my $has_git_settings = $self->has_user && $self->has_repo && $self->has_branch;

        my @tags = ();

        BADGE:
        foreach my $badge ($self->all_badges) {

            if($badge eq 'travis') {
                push @tags => $self->add_travis;
                next BADGE;
            }
            push @tags => $self->add_custom_badge($badge);

        }

        if(scalar @tags) {
            my $output = join "\n" => '=begin HTML', '',  '<p>' . join (' ' => @tags) . '</p>', '', '=end HTML', '';

            push @{ $document->children } =>
                Pod::Elemental::Element::Nested->new(
                    command => $self->command,
                    content => $self->heading,
                    children => [ Pod::Elemental::Element::Pod5::Ordinary->new({ content => $output }) ],
                );
        }
    }

    method add_travis {
        my $travis_a_href = 'https://travis-ci.org/%s/%s';
        my $travis_img_href = 'https://travis-ci.org/%s/%s.svg?branch=%s';

        my $travis_link = sprintf $travis_a_href => $self->user, $self->repo;
        my $travis_img = sprintf $travis_img_href => $self->user, $self->repo, $self->branch;

        return sprintf qq{<a href="%s"><img src="%s" /></a>} => $travis_link, $travis_img;
    }

    method add_custom_badge(Str $badge) {
        my($badge_url, $link_url) = split '\|' => $badge;
        $badge_url =~ s{[ \s\t]+$}{};
        $link_url =~ s{^[ \s\t]+}{} if defined $link_url;

        foreach my $pair ($self->extras_kv) {
            $badge_url = $self->replace_in_text($badge_url, @$pair);
            $link_url = $self->replace_in_text($link_url, @$pair);
        }
        foreach my $text ($badge_url, $link_url) {
            $text = $self->replace_in_text($text, 'user', $self->user);
            $text = $self->replace_in_text($text, 'repo', $self->repo);
            $text = $self->replace_in_text($text, 'branch', $self->branch);
        }

        my $html = sprintf q{<img src="%s" />} => $badge_url;
        if(defined $link_url) {
            $html = sprintf qq{<a href="%s">$html</a>} => $link_url;
        }
        return $html;
    }
    method replace_in_text(Maybe[Str] $text, Str $key, Str $value --> Str but assumed) {
        return if !defined $text;
        $key =~ s{^-}{};

        $text =~ s{\<$key\>}{$value}g;
        return $text;
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

=head1 SEE ALSO

=for :list

* Dist::Zilla::Plugin::TravisCI::StatusBadge

=cut
