<?php

define( "IN_PHPBB", true );
define( "PHPBB_PATH", "phpbb" );

$phpbb_root_path = "../" . PHPBB_PATH . "/";

$phpEx = substr( strrchr( __FILE__ , "." ), 1 );
include( $phpbb_root_path . "common." . $phpEx );
require( $phpbb_root_path . "includes/functions_user." . $phpEx );
require( $phpbb_root_path . "includes/functions_module." . $phpEx );
include($phpbb_root_path . 'includes/functions_display.' . $phpEx);
     


// Start session management
$user->session_begin();
$auth->acl($user->data);
$user->setup('ucp');


include($phpbb_root_path . 'includes/functions_profile_fields.' . $phpEx);

$coppa = (isset($_REQUEST['coppa'])) ? ((!empty($_REQUEST['coppa'])) ? 1 : 0) : false;
$agreed = (!empty($_POST['agreed'])) ? 1 : 0;
$submit = (isset($_POST['submit'])) ? true : false;
$change_lang = request_var('change_lang', '');
$user_lang = request_var('lang', $user->lang_name);

if ($change_lang || $user_lang != $config['default_lang'])
{
	$use_lang = ($change_lang) ? basename($change_lang) : basename($user_lang);

	if (file_exists($user->lang_path . $use_lang . '/'))
	{
		if ($change_lang)
		{
			//$submit = false;
			// Setting back agreed to let the user view the agreement in his/her language
			//$agreed = (empty($_GET['change_lang'])) ? 0 : $agreed;
		}

		$user->lang_name = $user_lang = $use_lang;
		$user->lang = array();
		$user->data['user_lang'] = $user->lang_name;
		$user->add_lang(array('common', 'ucp'));
	}
	else
	{
		$change_lang = '';
		$user_lang = $user->lang_name;
	}
}


$cp = new custom_profile();
$error = $cp_data = $cp_error = array();


// Try to manually determine the timezone and adjust the dst if the server date/time complies with the default setting +/- 1
$timezone = date('Z') / 3600;
$is_dst = date('I');

if ($config['board_timezone'] == $timezone || $config['board_timezone'] == ($timezone - 1))
{
	$timezone = ($is_dst) ? $timezone - 1 : $timezone;

	if (!isset($user->lang['tz_zones'][(string) $timezone]))
	{
		$timezone = $config['board_timezone'];
	}
}
else 
{
	$is_dst = $config['board_dst'];
	$timezone = $config['board_timezone'];
}

$data = array(
 'username'         => $_POST['username'],
 'new_password'      => request_var('new_password', '', true),
 'password_confirm'   => request_var('password_confirm', '', true),
 'email'            => strtolower(request_var('email', '')),
 'email_confirm'      => strtolower(request_var('email_confirm', '')),
 'lang'            => basename(request_var('lang', $user->lang_name)),
 'tz'            => request_var('tz', (float) $timezone),
);

// Check and initialize some variables if needed
if ($submit)
{
	$error = validate_data($data, array(
		'username'         => array(
		   array('string', false, $config['min_name_chars'], $config['max_name_chars']),
		   array('username', '')),
		'new_password'      => array(
		   array('string', false, $config['min_pass_chars'], $config['max_pass_chars']),
		   array('password')),
		'password_confirm'   => array('string', false, $config['min_pass_chars'], $config['max_pass_chars']),
		'email'            => array(
		   array('string', false, 6, 60),
		   array('email')),
		'email_confirm'      => array('string', false, 6, 60),
		'tz'            => array('num', false, -14, 14),
		'lang'            => array('match', false, '#^[a-z_\-]{2,}$#i'),
	));

	// Replace "error" strings with their real, localised form
	$error = preg_replace('#^([A-Z_]+)$#e', "(!empty(\$user->lang['\\1'])) ? \$user->lang['\\1'] : '\\1'", $error);

	// DNSBL check
	if ($config['check_dnsbl'])
	{
		if (($dnsbl = $user->check_dnsbl('register')) !== false)
		{
			$error[] = sprintf($user->lang['IP_BLACKLISTED'], $user->ip, $dnsbl[1]);
		}
	}

	 // validate custom profile fields
	 $cp->submit_cp_field('register', $user->get_iso_lang_id(), $cp_data, $error);

	 if (!sizeof($error))
	 {
		if ($data['new_password'] != $data['password_confirm'])
		{
		   $error[] = $user->lang['NEW_PASSWORD_ERROR'];
		}

		if ($data['email'] != $data['email_confirm'])
		{
		   $error[] = $user->lang['NEW_EMAIL_ERROR'];
		}
	 }

	 if (!sizeof($error))
	 {
		$server_url = generate_board_url();

		// Which group by default?
		$group_name = ($coppa) ? 'REGISTERED_COPPA' : 'REGISTERED';

		$sql = 'SELECT group_id
		   FROM ' . GROUPS_TABLE . "
		   WHERE group_name = '" . $db->sql_escape($group_name) . "'
			  AND group_type = " . GROUP_SPECIAL;
		$result = $db->sql_query($sql);
		$row = $db->sql_fetchrow($result);
		$db->sql_freeresult($result);

		if (!$row)
		{
		   trigger_error('NO_GROUP');
		}

		$group_id = $row['group_id'];

		if (($coppa ||
		   $config['require_activation'] == USER_ACTIVATION_SELF ||
		   $config['require_activation'] == USER_ACTIVATION_ADMIN) && $config['email_enable'])
		{
		   $user_actkey = gen_rand_string(mt_rand(6, 10));
		   $user_type = USER_INACTIVE;
		   $user_inactive_reason = INACTIVE_REGISTER;
		   $user_inactive_time = time();
		}
		else
		{
		   $user_type = USER_NORMAL;
		   $user_actkey = '';
		   $user_inactive_reason = 0;
		   $user_inactive_time = 0;
		}

		$user_row = array(
		   'username'            => $data['username'],
		   'user_password'         => phpbb_hash($data['new_password']),
		   'user_email'         => $data['email'],
		   'group_id'            => (int) $group_id,
		   'user_timezone'         => (float) $data['tz'],
		   'user_dst'            => $is_dst,
		   'user_lang'            => $data['lang'],
		   'user_type'            => $user_type,
		   'user_actkey'         => $user_actkey,
		   'user_ip'            => $user->ip,
		   'user_regdate'         => time(),
		   'user_inactive_reason'   => $user_inactive_reason,
		   'user_inactive_time'   => $user_inactive_time,
		);

		if ($config['new_member_post_limit'])
		{
		   $user_row['user_new'] = 1;
		}

		// Register user...
		$user_id = user_add($user_row, $cp_data);

		// This should not happen, because the required variables are listed above...
		if ($user_id === false)
		{
		   trigger_error('NO_USER', E_USER_ERROR);
		}

		if ($coppa && $config['email_enable'])
		{
		   $message = $user->lang['ACCOUNT_COPPA'];
		   $email_template = 'coppa_welcome_inactive';
		}
		else if ($config['require_activation'] == USER_ACTIVATION_SELF && $config['email_enable'])
		{
		   $message = $user->lang['ACCOUNT_INACTIVE'];
		   $email_template = 'user_welcome_inactive';
		}
		else if ($config['require_activation'] == USER_ACTIVATION_ADMIN && $config['email_enable'])
		{
		   $message = $user->lang['ACCOUNT_INACTIVE_ADMIN'];
		   $email_template = 'admin_welcome_inactive';
		}
		else
		{
		   $message = $user->lang['ACCOUNT_ADDED'];
		   $email_template = 'user_welcome';
		}

		if ($config['email_enable'])
		{
		   include_once($phpbb_root_path . 'includes/functions_messenger.' . $phpEx);

		   $messenger = new messenger(false);

		   $messenger->template($email_template, $data['lang']);

		   $messenger->to($data['email'], $data['username']);

		   $messenger->headers('X-AntiAbuse: Board servername - ' . $config['server_name']);
		   $messenger->headers('X-AntiAbuse: User_id - ' . $user->data['user_id']);
		   $messenger->headers('X-AntiAbuse: Username - ' . $user->data['username']);
		   $messenger->headers('X-AntiAbuse: User IP - ' . $user->ip);

		   $messenger->assign_vars(array(
			  'WELCOME_MSG'   => htmlspecialchars_decode(sprintf($user->lang['WELCOME_SUBJECT'], $config['sitename'])),
			  'USERNAME'      => htmlspecialchars_decode($data['username']),
			  'PASSWORD'      => htmlspecialchars_decode($data['new_password']),
			  'U_ACTIVATE'   => "$server_url/ucp.$phpEx?mode=activate&u=$user_id&k=$user_actkey")
		   );

		   if ($coppa)
		   {
			  $messenger->assign_vars(array(
				 'FAX_INFO'      => $config['coppa_fax'],
				 'MAIL_INFO'      => $config['coppa_mail'],
				 'EMAIL_ADDRESS'   => $data['email'])
			  );
		   }

		   $messenger->send(NOTIFY_EMAIL);

		   if ($config['require_activation'] == USER_ACTIVATION_ADMIN)
		   {
			  // Grab an array of user_id's with a_user permissions ... these users can activate a user
			  $admin_ary = $auth->acl_get_list(false, 'a_user', false);
			  $admin_ary = (!empty($admin_ary[0]['a_user'])) ? $admin_ary[0]['a_user'] : array();

			  // Also include founders
			  $where_sql = ' WHERE user_type = ' . USER_FOUNDER;

			  if (sizeof($admin_ary))
			  {
				 $where_sql .= ' OR ' . $db->sql_in_set('user_id', $admin_ary);
			  }

			  $sql = 'SELECT user_id, username, user_email, user_lang, user_jabber, user_notify_type
				 FROM ' . USERS_TABLE . ' ' .
				 $where_sql;
			  $result = $db->sql_query($sql);

			  while ($row = $db->sql_fetchrow($result))
			  {
				 $messenger->template('admin_activate', $row['user_lang']);
				 $messenger->to($row['user_email'], $row['username']);
				 $messenger->im($row['user_jabber'], $row['username']);

				 $messenger->assign_vars(array(
					'USERNAME'         => htmlspecialchars_decode($data['username']),
					'U_USER_DETAILS'   => "$server_url/memberlist.$phpEx?mode=viewprofile&u=$user_id",
					'U_ACTIVATE'      => "$server_url/ucp.$phpEx?mode=activate&u=$user_id&k=$user_actkey")
				 );

				 $messenger->send($row['user_notify_type']);
			  }
			  $db->sql_freeresult($result);
		   }
		}

		//$message = $message . '<br /><br />' . sprintf($user->lang['RETURN_INDEX'], '<a href="' . append_sid("{$phpbb_root_path}index.$phpEx") . '">', '</a>');
		//trigger_error($message);
	 }
}

//
$l_reg_cond = '';
switch ($config['require_activation'])
{
	case USER_ACTIVATION_SELF:
		$l_reg_cond = $user->lang['UCP_EMAIL_ACTIVATE'];
	break;

	case USER_ACTIVATION_ADMIN:
		$l_reg_cond = $user->lang['UCP_ADMIN_ACTIVATE'];
	break;
}

if( isset($error)&& sizeof($error))
{
	echo "|" . implode('|', $error);
} else {

	echo $l_reg_cond;

}

?>