use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::Pastebin::PastebinCa::Retrieve',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/WWW/Pastebin/PastebinCa/Retrieve.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'WWW::Pastebin::Base::Retrieve' => 0.001,
        'HTML::TokeParser::Simple'      => 3.15,
        'HTML::Entities'                => 1.35,
    },
    add_to_cleanup      => [ 'WWW-Pastebin-PastebinCa-Retrieve-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
