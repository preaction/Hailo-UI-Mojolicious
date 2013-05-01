#!/usr/bin/env perl

use Mojolicious::Lite;
use Hailo;
my $hailo = Hailo->new;
$hailo->train( 'ulysses.trn' );

get '/' => 'hailo';

post '/talk' => sub {
    my ( $self ) = @_;
    $self->respond_to(
        txt => { text => $hailo->reply( $self->req->body ) 
                    // "I don't know enough to answer you right now.",
        },
    );
};

app->start;
__DATA__
@@ hailo.html.ep
<!DOCTYPE html>
<html ng-app="Hailo">
    <head>
        <title>Hailo</title>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
        <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
        <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>
        <script type="text/javascript">
angular.module( 'Hailo', [] );
function HailoCtrl( $scope, $http ) {
    $scope.conversation = [];
    $scope.talk = function () {
        if ( !$scope.text ) {
            return;
        }
        $scope.conversation.push({
            name: "You",
            text: $scope.text
        });
        $scope.text = '';
        $http.post('/talk', $scope.text ).success(
            function (data) {
                $scope.conversation.push({
                    name: "Bot",
                    text: data
                });
            }
        );
    }
}
        </script>
    </head>
    <body ng-controller="HailoCtrl">
        <form class="form" ng-submit="talk()">
            <input type="text" class="input input-block" ng-model="text">
            <button class="btn">Submit</button>
        </form>
        <ul>
            <li ng-repeat="item in conversation">
                {{item.name}}: {{item.text}}
            </li>
        </ul>
    </body>
</html>
__END__

=head1 NAME

Hailo::UI::Mojolicious

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS


