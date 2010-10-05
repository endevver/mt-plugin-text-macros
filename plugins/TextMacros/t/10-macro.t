
use lib qw( t/lib lib extlib );

use strict;
use warnings;

use MT::Test qw( :db :data );
use Test::More tests => 3;

require MT::Entry;
my $e = MT::Entry->new;
$e->set_values(
    {   blog_id   => 1,
        status    => MT::Entry::RELEASE(),
        author_id => 1,
        title     => 'Test Entry 1',
        text      => '[% PageURL id="1" %]',
    }
);
$e->save or die $e->errstr;

my $tmpl_text = '<mt:entries lastn="1"><mt:entrybody></mt:entries>';
require MT::Template;
my $tmpl = MT::Template->new;
$tmpl->set_values(
    {   blog_id => 1,
        text    => $tmpl_text,
        name    => 'Test Template',
        type    => 'custom',
    }
);
$tmpl->save or die $tmpl->errstr;

my $out = $tmpl->output;
is( $tmpl->output,
    q(<p>[% PageURL id="1" %]</p>),
    "Basic template text doesn't function"
);

$tmpl->text(
    '<mt:entries lastn="1"><mt:entrybody text_macros="1"></mt:entries>');
$tmpl->reset_tokens();
is( $tmpl->output,
    q(<p>http://narnia.na/nana/archives/1978/01/a-rainy-day.html</p>),
    "Basic template text functions with text_macros turned on"
);

$e->text('[% PageURL id="-17" %]');
$e->save;

# should just blank this out or something
is( $tmpl->output,
    q(<p></p>),
    "Basic template text functions with text_macros turned on"
);


1;
