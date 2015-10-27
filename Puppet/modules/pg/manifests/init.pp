###
class pg (
    $user,
    $password,
    ){
    user { 'creating_user':
        name => $user, 
        ensure   => present,
        password => "$password",
    }
}
