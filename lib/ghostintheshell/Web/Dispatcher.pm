package ghostintheshell::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON qw/encode_json decode_json/;
use LWP::UserAgent;
use Furl;
use HTTP::Request;
use Data::Dump qw/dump/;

any '/' => sub {
    my ($c) = @_;
    return $c->render('index.tt');
};

get '/login' => sub {
    my ($c) = @_;
    return $c->render('login.tt');
};

get '/outer_api/spot_viewersip' => sub {
    my ($c) = @_;
    my $spot_viewersip = +{
        'data' => {
            'url' => 'http://news.example.com',
            'map' => [
                {
                    'x' => 300,
                    'y' => 100,
                    'signal' => 30,
                },
                {
                    'x' => 260,
                    'y' => 100,
                    'signal' => 70,
                },
                {
                    'x' => 170,
                    'y' => 100,
                    'signal' => 90,
                },
            ]
        }
    };
    return $c->render_json($spot_viewersip);
};

get '/batou_api/asorted_spots' => sub {
    my ($c) = @_;
    my $asorted_spots = +{
        'asorted_spots' => [
            10000,
            20000,
            15000
        ]
    };
    return $c->render_json($asorted_spots);
};

get '/campaign/add' => sub {
    my ($c) = @_;
    return $c->render('create_campaign.tt');
};

post '/campaign/add' => sub {
    my ($c) = @_;
    my $access_token = $c->config->{Access_Token};
    my $api_req_body = +{};
    $api_req_body->{name}  = $c->req->param('campaign_name');
    $api_req_body->{monthly_budget} = $c->req->param('monthly_budget');
    $api_req_body->{daily_budget}   = $c->req->param('daily_budget');
    $api_req_body->{reset_time}     = $c->req->param('reset_time');
    $api_req_body->{is_scheduled}   = 0;

    my $body = encode_json $api_req_body;
    my $furl    = Furl->new( agent => 'FOut team1 Apps' );
    my $headers = [
        'Content-Type'  => 'application/json',
        'Country'       => 'JP',
        'Authorization' => "Bearer 8ybTbZhkS4UkA21j3h6PKMSHz3Jno5lIwUyFFESTP3Ur-n0KbKoW0G7LVkrq6aawSWWU",
    ];
    my $res = $furl->post( 'https://api.fout.jp/v1/advertiser/campaign/set', $headers, $body);

    return $c->redirect('/campaign/list');
};

any '/campaign/list' => sub {
    my ($c) = @_;

    my $furl    = Furl->new( agent => 'FOut team1 Apps' );
    my $headers = [
        'Content-Type'  => 'application/json',
        'Country'       => 'JP',
        'Authorization' => "Bearer 8ybTbZhkS4UkA21j3h6PKMSHz3Jno5lIwUyFFESTP3Ur-n0KbKoW0G7LVkrq6aawSWWU",
    ];
    my $res = $furl->post( 'https://api.fout.jp/v1/advertiser/campaign/get', $headers, '{}');

    my $result = decode_json $res->content;
    #die dump $result;

    return $c->render(
        'list_campaign.tt' => {
            result => $result->{result},
        }
    );
};

any '/tags/create' => sub {
    my ($c) = @_;
    return $c->render('create_tag.tt');
};

1;
