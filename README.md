# NAME

Pod::Weaver::Section::Badges::PluginSearcher - Add (or append) a section with badges

<div>
    <p>
    <img src="https://img.shields.io/badge/perl-5.10.1+-blue.svg" alt="Requires Perl 5.10.1+" />
    <a href="https://travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges"><img src="https://api.travis-ci.org/Csson/p5-Pod-Weaver-Section-Badges.svg?branch=master" alt="Travis status" /></a>
    <a href="http://cpants.cpanauthors.org/dist/Pod-Weaver-Section-Badges-0.0401"><img src="https://badgedepot.code301.com/badge/kwalitee/Pod-Weaver-Section-Badges/0.0401" alt="Distribution kwalitee" /></a>
    <a href="http://matrix.cpantesters.org/?dist=Pod-Weaver-Section-Badges%200.0401"><img src="https://badgedepot.code301.com/badge/cpantesters/Pod-Weaver-Section-Badges/0.0401" alt="CPAN Testers result" /></a>
    <img src="https://img.shields.io/badge/coverage-80.0%-orange.svg" alt="coverage 80.0%" />
    </p>
</div>

# VERSION

Version 0.0401, released 2016-02-17.

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

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#ArrayRef">ArrayRef</a> [ <a href="https://metacpan.org/pod/Types::Standard#Enum">Enum</a> [ "<a href="https://metacpan.org/pod/Types::Standard#html">html</a>","<a href="https://metacpan.org/pod/Types::Standard#markdown">markdown</a>" ] ]</td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">required</td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>The formats to render the badges for. Comma separated list, not multiple rows.</p>

## badge

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#ArrayRef">ArrayRef</a> [ <a href="https://metacpan.org/pod/Types::Standard#Str">Str</a> ]</td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>[]</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>The name of the wanted badge, lowercased. Repeat for multiple badges. The name is everything after 'Badge::Depot::Plugin::'.</p>

## main\_module\_only

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Bool">Bool</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>1</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>If true, the badges will only be inserted in the main module (as defined by Dist::Zilla). If false, they will be included in all modules.</p>

## section

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Str">Str</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>NAME</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>The section of pod to add the badges to, identified by its heading. The section will be created if it doesn't already exist.</p>

## skip\_markdown\_if\_html

<table cellpadding="0" cellspacing="0">
<tr>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;"><a href="https://metacpan.org/pod/Types::Standard#Bool">Bool</a></td>
    <td style="padding-right: 6px; padding-left: 6px; border-right: 1px solid #b8b8b8; white-space: nowrap;">optional, default: <code>1</code></td>
    <td style="padding-left: 6px; padding-right: 6px; white-space: nowrap;">read-only</td>
</tr>
</table>

<p>Some markdown renderers also renders '=begin html' blocks, which makes it unnecessary to set both html and markdown as output formats. Set this to a false value to produce both blocks.</p>

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

This software is copyright (c) 2016 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
