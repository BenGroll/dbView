#!/usr/bin/perl

use strict;
use warnings;

use Http::Route;
use DBView::Http::Controllers::Controller;
use Foundation::Appify;

Http::Route::group({

    middlewares => [

        # Check if the visitor is signed in.
        'Http::Middlewares::Auth',
        
        # TODO: Implement service middleware classes instead of only using
        # TODO: closures.
        sub {
            my $request = shift;
            my $next = shift;

            return &$next($request); 
        }

    ],

}, sub {

    # Routes within this scope require the visitor to be signed in.

    Http::Route::group({

        # The prefix of the http route.
        prefix => '/apps/dbview',

        # The prefix of the route name.
        as => 'apps.dbview.',

    }, sub {
        
        Http::Route::get('/', sub {

            my $request = shift;

            # TODO: Implement default controller routing instead of creating
            # TODO: an instance of the controller class.

            return DBView::Http::Controllers::Controller->new()->welcome(
                $request,
            );

        }),

        Http::Route::get('/messages/{id}', sub {

            my $request = shift;

            return DBView::Http::Controllers::Controller->new()->showMessage(
                $request,
            );

        }),

        Http::Route::group({

            # The prefix of the http route.
            prefix => '/admin',

            # The prefix of the route name.
            as => 'admin.',

            middlewares => [

                sub {
                    my $request = shift;
                    my $next = shift;
                    
                    unless (user()->isDBViewAdmin()) {
                        abort('Unauthorized.', 403);
                    }

                    return &$next($request); 
                },

            ],

        }, sub {
            
            Http::Route::get('/', sub {

                my $request = shift;

                return DBView::Http::Controllers::Controller->new()->dashboard(
                    $request,
                );

            }),

        });

    });

});
