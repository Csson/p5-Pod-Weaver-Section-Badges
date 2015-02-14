# NAME

Pod::Weaver::Section::Badges - Insert badges in your pod

# VERSION

Version 0.0001, released 2015-02-14.

# SYNOPSIS

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

# DESCRIPTION

This inserts a section with status badges. The configuration in the synopsis would produce something similar to this:

    =head1 BUILD STATUS

    =begin HTML

    <p>
        <a href="https://travis-ci.org/MyGithubUser/the_repository"><img src="https://travis-ci.org/MyGithubUser/the_repository.svg?branch=master" /></a>
        <a href="http://www.example.com/repos/the_repository"><img src="http://www.example.com/img/the_repository.jpg" /></a>
        <img src="https://img.shields.io/gratipay/the_repository/ExampleName.svg" />
    </p>

    =end HTML

# ATTRIBUTES

## badges

## branch

## command

## extras

## heading

## repo

## user

# SEE ALSO

\* Dist::Zilla::Plugin::TravisCI::StatusBadge

# BUILD STATUS

# HOMEPAGE

[https://metacpan.org/release/Pod-Weaver-Section-Badges](https://metacpan.org/release/Pod-Weaver-Section-Badges)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
