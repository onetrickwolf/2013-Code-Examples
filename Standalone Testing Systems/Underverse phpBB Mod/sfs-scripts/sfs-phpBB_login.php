<?php
define( "IN_PHPBB", true );
define( "PHPBB_PATH", "phpbb" );

$phpbb_root_path = "../" . PHPBB_PATH . "/";

$phpEx = substr( strrchr( __FILE__ , "." ), 1 );
include( $phpbb_root_path . "common." . $phpEx );
require( $phpbb_root_path . "includes/functions_user." . $phpEx );
require( $phpbb_root_path . "includes/functions_module." . $phpEx );
require( $phpbb_root_path . "includes/auth/auth_db." . $phpEx );
$user->session_begin();
$user->setup('ucp');

$username = $_POST['username'];
$password = $_POST['password'];

$result = login_db($username, $password);
$err = $user->lang[$result['error_msg']];

echo $err; // NOTE: Add sprintf to this to get custom variables.
?>