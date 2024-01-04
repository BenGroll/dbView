package DBView::TableBuilder;

use strict;
use warnings;

use Data::Dumper;

my $templateprefix = '../../templates/';

sub new {
    my $class = shift;
    my $tablename = shift;
    my $tablecolumns = shift;

    my $self = {
        tablename => $tablename,
        tablecolumns => $tablecolumns,
        tabletemplate => HTML::Template->new(filename => getFolder() . $templateprefix . 'table.tmpl'),
        db => DBView::DB->new()
    };
    # die Dumper($self);
    bless ($self, $class);
}

sub subtitle {
    my $self = shift;

    my $subtitle = HTML::Template->new(filename => getFolder() . $templateprefix . "tablesubtitle.tmpl");
    $subtitle->param(
        TABLENAME => $self->{tablename},
    );
    return $subtitle;
}

sub headers {
    my $self = shift;

    my $tablecolumns = $self->{tablecolumns};

    my @tableheaders = ();
    foreach my $header (@$tablecolumns) {
        push(@tableheaders, {HName => $header->{Field}});
    }
    return \@tableheaders;
}

sub rows {
    my $self = shift;

    my $db = $self->{db};

    my @tablerows = ();
    my $tablerowsdata = $db->rows($self->{tablename});
    foreach my $row (@$tablerowsdata) {
        my $rowtemplate = $self->buildSingleRowTemplate($row);
        push(@tablerows, $rowtemplate->output());
    }
    return \@tablerows;
}

sub buildSingleRowTemplate {
    my $self = shift;
    my $row = shift;

    my @data = ();
    foreach my $cellvalue (@$row) {
        push (@data, {Value => $cellvalue} ); 
    }
    my $template = HTML::Template->new(filename => getFolder() . $templateprefix . 'tablerow.tmpl');
    $template->param(
        Cells => \@data
    );
    return $template;
}

sub dataFromRows {
    my $self = shift;
    my $rows = shift or die "Missing Argument rows";

    my @tabledata = ();
    foreach my $outputrow (@$rows) {
        push(@tabledata, {row => $outputrow});
    }
    return \@tabledata;
}

sub fillTemplate {
    my $self = shift;
    my $headers = shift;
    my $tabledata = shift;

    $self->{tabletemplate}->param(
        HEADERS => $headers,
        rows => $tabledata
    );
    return $self->{tabletemplate};
}

sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}

1;