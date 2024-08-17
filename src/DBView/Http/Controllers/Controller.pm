package DBView::Http::Controllers::Controller;

use strict;
use warnings;

use Data::Dumper;
use DBView::DB;
use DBView::TableBuilder;
use Foundation::Appify;
use HTML::Template;

my $templateprefix = '../../../../templates/';

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

    my $DB = DBView::DB->new(app()->database);
    my $tablenames = $DB->tablelist();
    my @tabledata = ();
    foreach my $name (@$tablenames) {
        push (@tabledata, {TABLENAME => $name});
    }
    my $tablebuttons = HTML::Template->new(filename => getFolder() . $templateprefix . 'tablebuttons.tmpl');
 
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

    my $db = DBView::DB->new(app()->database);
    my $params = \%{$request->Vars};
    
    my $tablename = $params->{tablename};
    my $tablebuilder = DBView::TableBuilder->new($tablename, $db->indexlist($tablename));

    my $headers = $tablebuilder->headers();
    my $rows = $tablebuilder->dataFromRows($tablebuilder->rows());

    my $table = $tablebuilder->fillTemplate($headers, $rows);
    my $subtitle = $tablebuilder->subtitle();
    
    my $template = &_::template('dbview::welcome', {
        email => user()->get('email'),
        content => $table->output(),
        subtitle => $subtitle->output()
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
