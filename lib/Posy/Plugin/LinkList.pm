package Posy::Plugin::LinkList;
use strict;

=head1 NAME

Posy::Plugin::LinkList - Posy plugin to give a dynamic list of links.

=head1 VERSION

This describes version B<0.42> of Posy::Plugin::LinkList.

=cut

our $VERSION = '0.42';

=head1 SYNOPSIS

    @plugins = qw(Posy::Core
	...
	Posy::Plugin::TextTemplate
	...
	Posy::Plugin::LinkList
	...
	));

=head1 DESCRIPTION

This provides a method which can be called from the "head" flavour template
(if one is using the TextTemplate plugin).  When given an array of
labels and a hash of labels-to-relative-links, will produce a list of
links which take account of (a) what the current path is and (b)
what the current flavour is.  If the link matches the current path,
then only the label is used for that link.  If the extension part
of the link matches the default flavour, then the current flavour
replaces it.

With extra arguments, will change the style of the list; one can define
pre_list, post_list, pre_item, post_item, and item separators -- this
enables one to create an unordered list or a pipe-separated paragraph
just by changing these values.  Or one can give one's own CSS classes
to the parts.  The default is a plain <ul> list.

=cut

=head1 Helper Methods

Methods which can be called from elsewhere.

=head2 link_list

    $links = $self->link_list(labels => \@labels,
	links=>\%links,
	pre_list=>'<ul>',
	post_list=>'</ul>',
	pre_item=>'<li>',
	post_item=>'</li>'
	pre_active_item=>'<li><em>',
	post_active_item=>'</em></li>',
	item_sep=>"\n");

Generates a list of links.

Options:

=over

=item labels

The labels for the links, in the order you want them displayed.

=item links

A hash of labels (as above) and the links they should point to.

=item pre_list

String to begin the list with.

=item post_list

String to end the list with.

=item pre_item

String to prepend to a non-active item.

=item post_item

String to append to a non-active item.

=item pre_active_item

String to prepend to an active item.

=item post_active_item

String to prepend to an active item.

=item item_sep

String to put between items.

=back

=cut
sub link_list {
    my $self = shift;
    my %args = (
		pre_list=>'<ul>',
		post_list=>'</ul>',
		pre_item=>'<li>',
		post_item=>'</li>',
		pre_active_item=>'<li><em>',
		post_active_item=>'</em></li>',
		item_sep=>"\n",
		@_
	       );

    my @items = ();
    foreach my $label (@{$args{labels}})
    {
	my $link = $args{links}->{$label};
	$self->debug(2, "link_list: link=$link");
	if ($link =~ m/(.*)\.(\w+)$/)
	{
	    my $link_base = $1;
	    my $link_flavour = $2;
	    $link_flavour = $self->{path}->{flavour}
		if $link_flavour eq $self->{config}->{flavour};
	    $link = "$link_base.$link_flavour";
	}
	if ($link eq $self->{path}->{info}) # active
	{
	    push @items, join('', $args{pre_active_item},
			      $label,
			      $args{post_active_item});
	}
	else
	{
	    push @items, join('', $args{pre_item},
			      '<a href="', $self->{url}, $link, '">',
			      $label, '</a>',
			      $args{post_item});
	}
    }
    my $list = join($args{item_sep}, @items);
    return ($list
	? join('', $args{pre_list}, $list, $args{post_list})
	: '');
} # link_list

=head1 INSTALLATION

Installation needs will vary depending on the particular setup a person
has.

=head2 Administrator, Automatic

If you are the administrator of the system, then the dead simple method of
installing the modules is to use the CPAN or CPANPLUS system.

    cpanp -i Posy::Plugin::LinkList

This will install this plugin in the usual places where modules get
installed when one is using CPAN(PLUS).

=head2 Administrator, By Hand

If you are the administrator of the system, but don't wish to use the
CPAN(PLUS) method, then this is for you.  Take the *.tar.gz file
and untar it in a suitable directory.

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Or, if you're on a platform (like DOS or Windows) that doesn't like the
"./" notation, you can do this:

   perl Build.PL
   perl Build
   perl Build test
   perl Build install

=head2 User With Shell Access

If you are a user on a system, and don't have root/administrator access,
you need to install Posy somewhere other than the default place (since you
don't have access to it).  However, if you have shell access to the system,
then you can install it in your home directory.

Say your home directory is "/home/fred", and you want to install the
modules into a subdirectory called "perl".

Download the *.tar.gz file and untar it in a suitable directory.

    perl Build.PL --install_base /home/fred/perl
    ./Build
    ./Build test
    ./Build install

This will install the files underneath /home/fred/perl.

You will then need to make sure that you alter the PERL5LIB variable to
find the modules, and the PATH variable to find the scripts (posy_one,
posy_static).

Therefore you will need to change:
your path, to include /home/fred/perl/script (where the script will be)

	PATH=/home/fred/perl/script:${PATH}

the PERL5LIB variable to add /home/fred/perl/lib

	PERL5LIB=/home/fred/perl/lib:${PERL5LIB}

=head1 REQUIRES

    Posy
    Posy::Core
    Posy::Plugin::TextTemplate

    Test::More

=head1 SEE ALSO

perl(1).
Posy
Posy::Plugin::TextTemplate
Text::Template

=head1 BUGS

Please report any bugs or feature requests to the author.

=head1 AUTHOR

    Kathryn Andersen (RUBYKAT)
    perlkat AT katspace dot com
    http://www.katspace.com

=head1 COPYRIGHT AND LICENCE

Copyright (c) 2004-2005 by Kathryn Andersen

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Posy::Plugin::LinkList
__END__
