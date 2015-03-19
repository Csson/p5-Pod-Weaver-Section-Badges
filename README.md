# NAME

Pod::Weaver::Section::Badges - Add a NAME section with abstract, and badges

# VERSION

Version 0.0102, released 2015-03-19.

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

# ATTRIBUTES

## formats

## badge

## badge\_args

## main\_module\_only

## section

# SEE ALSO

- [Task::Badge::Depot](https://metacpan.org/pod/Task::Badge::Depot)
- [Badge::Depot](https://metacpan.org/pod/Badge::Depot)

# BADGES

[![](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master)](https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges)
    ![](https://img.shields.io/badge/perl-5.14+-brightgreen.svg)

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
