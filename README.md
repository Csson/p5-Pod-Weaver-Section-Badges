# NAME

Pod::Weaver::Section::Badges - Add (or append) a section with badges

# VERSION

Version 0.0203, released 2015-04-11.

# SYNOPSIS

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

# DESCRIPTION

This inserts a section with status badges. The configuration in the synopsis would produce something similar to this:

    =head1 BUILD STATUS

    =begin HTML

    <p>
        <a href="https://travis-ci.org/MyGithubUser/the_repository"><img src="https://travis-ci.org/MyGithubUser/the_repository.svg?branch=master" /></a>
        <img src="https://img.shields.io/gratipay/ExampleName.svg" />
    </p>

    =end HTML

This module uses badges in the `Badge::Depot::Plugin` namespace. See [Task::Badge::Depot](https://metacpan.org/pod/Task::Badge::Depot) for a list of available badges.
The synopsis uses the [Badge::Depot::Plugin::Travis](https://metacpan.org/pod/Badge::Depot::Plugin::Travis) and [Badge::Depot::Plugin::Gratipay](https://metacpan.org/pod/Badge::Depot::Plugin::Gratipay) badges.

Attributes starting with a dash (such as, in the synopsis, `-travis_user` or `-gratipay_user`) are given to each badge's constructor.

## Badge rendering

As a comparison with using badges and [Badge::Depot](https://metacpan.org/pod/Badge::Depot) directly, this is what `Pod::Weaver::Section::Badges` does.

First, with this part of the synopsis:

    [Badges]
    badge = Gratipay
    -gratipay_user = ExampleName

`badge = Gratipay` means that [Badge::Depot::Plugin::Gratipay](https://metacpan.org/pod/Badge::Depot::Plugin::Gratipay) is automatically `used`.

Secondly, `-gratipay_user = Example` means that this attribute is for the `Gratipay` badge, so the prefix (`-gratipay_`) is stripped and the attribute is given in the constructor:

    my $gratipay_badge = Badge::Depot::Plugin::Gratipay->new(user => 'ExampleName');

And then the given `formats` is used to render the pod:

    my $rendered_badge = $gratipay_badge->to_html;

Which is then injected into the chosen `section`.

# ATTRIBUTES

## formats

## badge

## main\_module\_only

## section

# SEE ALSO

- [Task::Badge::Depot](https://metacpan.org/pod/Task::Badge::Depot)
- [Badge::Depot](https://metacpan.org/pod/Badge::Depot)

# BADGES

![](https://img.shields.io/badge/perl-5.14+-brightgreen.svg)
    [![](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master)](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges)

# SOURCE

[https://github.com/Csson/p5-Pod-Weaver-Section-Badges](https://github.com/Csson/p5-Pod-Weaver-Section-Badges)

# HOMEPAGE

[https://metacpan.org/release/Pod-Weaver-Section-Badges](https://metacpan.org/release/Pod-Weaver-Section-Badges)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
