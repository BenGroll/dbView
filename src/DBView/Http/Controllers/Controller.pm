package DBView::Http::Controllers::Controller;

use strict;
use warnings;

use Data::Dumper;
use DBView::DB;
use Foundation::Appify;
use HTML::Template;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub welcome {
    my $self = shift;
    my $request = shift;

    app()->pushToStack('scripts', servicePath('dbview') . '/script.js');

    my $DB = DBView::DB->new();
    my $tablenames = $DB->tablelist();
    my @tabledata = ();
    foreach my $name (@$tablenames) {
        push (@tabledata, {TABLENAME => $name});
    }
    my $tablebuttons = HTML::Template->new(filename => getFolder() .  'tablebuttons.tmpl');
 
    $tablebuttons->param(TABLE_BUTTON_MENU => \@tabledata);

    my $template = &_::template('dbview::welcome', {
        email => user()->get('email'),
        content => $tablebuttons->output()
    });

    return $template->output();
}

sub showTable {
    my $self = shift;
    my $request = shift;

    my $db = DBView::DB->new();

    my $params = \%{$request->Vars};
    my $tablename = $params->{tablename};

    my $table = HTML::Template->new(filename => getFolder() . 'table.tmpl');

    my $tablecolumns = $db->indexlist($tablename);
    
    my @tableheaders = ();
    foreach my $header (@$tablecolumns) {
        push(@tableheaders, {HName => $header->{Field}});
    }

    my @tablerows = ();
    my $tablerowsdata = $db->rows($params->{tablename});
    foreach my $row (@$tablerowsdata) {
        my @data = ();
        foreach my $cellvalue (@$row) {
            push (@data, {Value => $cellvalue} ); 
        }
        my $template = HTML::Template->new(filename => getFolder() . 'tablerow.tmpl');
        $template->param(
            Cells => \@data
        );
        # die Dumper($template->output());
        push(@tablerows, $template->output());
    }
    my @tabledata = ();
    foreach my $outputrow (@tablerows) {
        push(@tabledata, {row => $outputrow});
    }

    $table->param(
        TABLENAME => $tablename,
        HEADERS => \@tableheaders,
        rows => \@tabledata
    );

    my $template = &_::template('dbview::welcome', {
        email => user()->get('email'),
        content => $table->output()
    });

    return $template->output();
}

sub dashboard {
    my $self = shift;
    my $request = shift;

    # TODO: Do something useful.

    app()->pushToStack('scripts', servicePath('dbview') . '/script.js');

    my $template = &_::template('dbview::dashboard', {
        #
    });

    return $template->output();
}

sub showMessage {
    my $self = shift;
    my $request = shift;

    # TODO: Do something useful.

    return $self->welcome($request);
}

sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}

1;
