package ghostintheshell::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use Data::Dump qw/dump/;

any '/' => sub {
    my ($c) = @_;
    return $c->render('index.tt');
};

get '/campaign/add' => sub {
    my ($c) = @_;
    return $c->render('create_campaign.tt');
};

post '/campaign/add' => sub {
    my ($c) = @_;
    return $c->redirect('/');
};

any '/campaign/list' => sub {
    my ($c) = @_;
    return $c->render('list_campaign.tt');
};

any '/tags/create' => sub {
    my ($c) = @_;
    return $c->render('create_tag.tt');
};

1;
