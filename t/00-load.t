#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 19;

my $ID = '931145';
my $PASTE_DUMP = {
            "language" => "Perl Source",
            "desc" => "perl stuff",
            "content" => "{\r\n\ttrue => sub { 1 },\r\n\tfalse => sub { 0 },\r\n\ttime  => scalar localtime(),\r\n}",
            "post_date" => "Thursday, March 6th, 2008 at 4:57:44pm MST",
            "name" => "Zoffix"
          };

BEGIN {
    use_ok('WWW::Pastebin::Base::Retrieve');
    use_ok('HTML::TokeParser::Simple');
    use_ok('HTML::Entities');
	use_ok('WWW::Pastebin::PastebinCa::Retrieve');
}

diag( "Testing WWW::Pastebin::PastebinCa::Retrieve $WWW::Pastebin::PastebinCa::Retrieve::VERSION, Perl $], $^X" );

use WWW::Pastebin::PastebinCa::Retrieve;
my $paster = WWW::Pastebin::PastebinCa::Retrieve->new( timeout => 10 );
isa_ok($paster, 'WWW::Pastebin::PastebinCa::Retrieve');
can_ok($paster, qw(
    new
    retrieve
    error
    results
    id
    uri
    ua
    _parse
    _set_error
    )
);

SKIP: {
    my $ret = $paster->retrieve($ID)
        or skip "Got error on ->retrieve($ID): " . $paster->error, 16;

    SKIP: {
        my $ret2 = $paster->retrieve("http://pastebin.ca/$ID")
            or skip "Got error on ->retrieve('http://pastebin.ca/$ID'): "
                        . $paster->error, 3;
        is_deeply(
            $ret,
            $ret2,
            'calls with ID and URI must return the same'
        );
    }

    is ( $paster->content, $ret->{content}, 'content() method');
    is ( "$paster", $ret->{content}, 'content() overloads');

    is_deeply(
        $ret,
        $PASTE_DUMP,
        q|dump from Dumper must match ->retrieve()'s response|,
    );

    for ( qw(language content post_date name) ) {
        ok( exists $ret->{$_}, "$_ key must exist in the return" );
    }

    is_deeply(
        $ret,
        $paster->results,
        '->results() must now return whatever ->retrieve() returned',
    );

    is(
        $paster->id,
        $ID,
        'paste ID must match the return from ->id()',
    );

    isa_ok( $paster->uri, 'URI::http', '->uri() method' );

    is(
        $paster->uri,
        "http://pastebin.ca/$ID",
        'uri() must contain a URI to the paste',
    );

    isa_ok( $paster->ua, 'LWP::UserAgent', '->ua() method' );
} # SKIP{}





