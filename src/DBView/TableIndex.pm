package DBView::TableIndex;

sub new {
    my $class = shift;

    my $self = {
        Field => shift(),
        Type => shift(),
        Null => shift(),
        Key => shift(),
        Default => shift(),
        Extra => shift()
    };
    bless($self, $class);
}

1;