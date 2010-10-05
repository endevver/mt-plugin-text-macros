package TextMacros::Plugin;

use strict;
use MT::Util qw( trim );

sub filter {
    my ($str, $val, $ctx) = @_;
    return $str unless $val;
    $str =~ s!(\[\%\s*((?:\[[^\[]+?>|"(?:\[[^\]]+?>|.)*?"|'(?:\[[^\]]+?>|.)*?'|.)+?)\%\])!_transform($1,$2,$3,$4)!gmie;
    return $str;
}

sub _transform {
    my ($whole_tag, $tag, $space_eater) = @_;
    ($tag, my($argstr)) = split /\s+/, $tag, 2;
    my %args;
    while ($argstr =~ /
            (?:
                (?:
                    ((?:\w|:)+)                     #1
                    \s*=\s*
                    (?:(?:
                        (["'])                      #2
                        ((?:<[^>]+?>|.)*?)          #3
                        \2
                        (                           #4
                            (?:
                                [,:]
                                (["'])              #5
                                (?:(?:<[^>]+?>|.)*?)
                                \5
                            )+
                        )?
                    ) |
                    (\S+))                          #6
                )
            ) |
            (\w+)                                   #7
            /gsx) {
        if (defined $7) {
            # An unnamed attribute gets stored in the 'name' argument.
            $args{'name'} = $7;
        } else {
            my $attr = lc $1;
            my $value = defined $6 ? $6 : $3;
            my $extra = $4;
            if (defined $extra) {
                my @extra;
                push @extra, $2 while $extra =~ m/[,:](["'])((?:<[^>]+?>|.)*?)\1/gs;
                $value = [ $value, @extra ];
            }
            $args{$attr} = $value;
        }
    }
    my $macros = MT->registry('text_macros');
    if (my $handler = $macros->{$tag}) {
        my $coderef = MT->handler_to_coderef($handler);
        $coderef->( \%args );
    }
}

sub macro_page_url {
    my ($args) = @_;
    my $page;
    if ($args->{'id'}) {
        $page = MT->model('page')->load( $args->{'id'} );
    } elsif ($args->{'basename'}) {
        $page = MT->model('page')->load({ basename => $args->{'basename'} });
    }
    return $page ? $page->permalink : '';
}

1;
__END__
