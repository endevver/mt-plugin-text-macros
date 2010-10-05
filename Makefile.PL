use ExtUtils::MakeMaker;

my $file = "plugins/TextMacros/config.yaml";
my $version = LoadFile($file)->{version} ||
    die "No version found in $file";

WriteMakefile(
    NAME            => 'Text Macros',
    VERSION         => '0.1',
    DISTNAME        => 'TextMacros',
);
